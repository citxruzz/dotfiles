#!/usr/bin/env bash
# Bootstrap: installs required packages, deploys dotfiles via GNU Stow,
# sets up tpm and zsh as default shell.
#
# Usage:
#   ./install.sh              full setup
#   ./install.sh --pkgs-only  install packages only (no stow/shell change)
#
# Supported: Arch/CachyOS/Manjaro, Debian/Ubuntu, Fedora, openSUSE,
#            Alpine, Void, Termux. Others: prints manual instructions.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGS_ONLY=false
[[ "${1:-}" == "--pkgs-only" ]] && PKGS_ONLY=true

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

IS_TERMUX=false
[[ -n "${TERMUX_VERSION:-}" || "$(uname -o 2>/dev/null || true)" == "Android" ]] && IS_TERMUX=true

# ---------- package manager detection ----------
detect_pm() {
  command -v pacman >/dev/null 2>&1 && { echo pacman; return; }
  command -v dnf    >/dev/null 2>&1 && { echo dnf; return; }
  command -v apt-get >/dev/null 2>&1 && { echo apt; return; }
  command -v zypper >/dev/null 2>&1 && { echo zypper; return; }
  command -v apk    >/dev/null 2>&1 && { echo apk; return; }
  command -v xbps-install >/dev/null 2>&1 && { echo xbps; return; }
  command -v emerge >/dev/null 2>&1 && { echo portage; return; }
  echo unknown
}

PM="${INSTALL_PM:-$(detect_pm)}"
$IS_TERMUX && PM="pkg"
case "$PM" in
  pacman|dnf|apt|zypper|apk|xbps|pkg|portage) ;;
  *) die "Unsupported distro. Install manually: git curl wget unzip ripgrep fzf jq zsh tmux neovim stow fastfetch alacritty, then re-run." ;;
esac

if [[ $EUID -eq 0 || $IS_TERMUX == true ]]; then SUDO=""
elif command -v sudo >/dev/null 2>&1; then SUDO="sudo"
else die "Not root and no sudo available."
fi

# ---------- package name maps ----------
required_pkgs() {
  case "$PM" in
    pacman)  echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    dnf)     echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    apt)     echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    zypper)  echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    apk)     echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    xbps)    echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    pkg)     echo "git curl wget unzip tar ripgrep fzf jq zsh tmux neovim stow" ;;
    portage) echo "dev-vcs/git net-misc/curl net-misc/wget app-arch/unzip sys-apps/ripgrep app-shells/fzf app-misc/jq app-shells/zsh app-misc/tmux app-editors/neovim app-admin/stow" ;;
  esac
}

refresh() {
  log "Refreshing package index ($PM)"
  case "$PM" in
    pacman)  $SUDO pacman -Sy --noconfirm ;;
    dnf)     $SUDO dnf makecache --quiet || true ;;
    apt)     $SUDO apt-get update -qq ;;
    zypper)  $SUDO zypper --non-interactive refresh ;;
    apk)     $SUDO apk update --quiet ;;
    xbps)    $SUDO xbps-install -S ;;
    pkg)     pkg update -y ;;
    portage) $SUDO emaint sync -a ;;
  esac
}

install_pkgs() {
  case "$PM" in
    pacman)  $SUDO pacman -S --needed --noconfirm "$@" ;;
    dnf)     $SUDO dnf install -y -q "$@" ;;
    apt)     DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y -q "$@" ;;
    zypper)  $SUDO zypper --non-interactive install "$@" ;;
    apk)     $SUDO apk add --quiet "$@" ;;
    xbps)    $SUDO xbps-install -Sy "$@" ;;
    pkg)     pkg install -y "$@" ;;
    portage) $SUDO emerge --ask=n "$@" ;;
  esac
}

try_install_one() {  # best-effort single package
  local p="$1"
  install_pkgs "$p" >/dev/null 2>&1 && { log "installed: $p"; return 0; }
  command -v "$p" >/dev/null 2>&1 && { log "already present: $p"; return 0; }
  warn "could not install '$p' via $PM (skipping)"
  return 1
}

# ---------- extras with special cases ----------
install_ghostty() {
  $IS_TERMUX && { warn "ghostty: GUI terminal not available on Termux (skip)"; return; }
  case "$PM" in
    pacman|xbps) try_install_one ghostty ;;
    dnf)
      if ! command -v ghostty >/dev/null 2>&1; then
        log "enabling pgdev/ghostty COPR for Fedora"
        $SUDO dnf copr enable -y pgdev/ghostty >/dev/null 2>&1 || true
      fi
      try_install_one ghostty ;;
    apt)
      if try_install_one ghostty; then return; fi
      log "trying Ghostty .deb from upstream releases (amd64)"
      local tmp deb url arch
      arch="$(dpkg --print-architecture 2>/dev/null || echo amd64)"
      [[ "$arch" != "amd64" ]] && { warn "no prebuilt ghostty for $arch — see https://ghostty.org/download"; return; }
      tmp="$(mktemp -d)" || return
      url="$(curl -fsSL https://api.github.com/repos/ghostty-org/ghostty/releases/latest \
             | grep -o '"browser_download_url": *"[^"]*-amd64\.deb"' \
             | head -1 | cut -d'"' -f4)" || true
      [[ -z "$url" ]] && { warn "ghostty .deb not found — see https://ghostty.org/download"; rm -rf "$tmp"; return; }
      curl -fsSL "$url" -o "$tmp/ghostty.deb" && \
        $SUDO apt-get install -y -q "$tmp/ghostty.deb" && log "installed: ghostty (upstream deb)" ||
        warn "ghostty .deb install failed — see https://ghostty.org/download"
      rm -rf "$tmp" ;;
    *) warn "ghostty: no automatic route for $PM — see https://ghostty.org/download" ;;
  esac
}

# ---------- main ----------
log "Detected environment: PM=$PM termux=$IS_TERMUX"
refresh

log "Installing required packages"
install_pkgs $(required_pkgs)

log "Installing extras (best-effort)"
# tree-sitter CLI is needed by nvim-treesitter main branch; package name
# differs per distro (arch/fedora/debian: tree-sitter-cli, else fallback)
if ! command -v tree-sitter >/dev/null 2>&1; then
  try_install_one tree-sitter-cli || true
  command -v tree-sitter >/dev/null 2>&1 || try_install_one tree-sitter || true
fi
try_install_one fastfetch || true
$IS_TERMUX || try_install_one alacritty || true
install_ghostty || true

if $PKGS_ONLY; then
  log "Packages done (--pkgs-only): skipping dotfiles deployment"
  exit 0
fi

# ---------- deploy dotfiles ----------
command -v stow >/dev/null 2>&1 || die "stow missing but packages were skipped — cannot deploy"

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d-%H%M%S)"
deploy_pkg() {
  local pkg="$1" src rel tgt
  while IFS= read -r src; do
    rel="${src#"$DOTFILES/$pkg"/}"
    tgt="$HOME/$rel"
    if [[ -e "$tgt" || -L "$tgt" ]]; then
      if [[ -L "$tgt" ]] && [[ "$(readlink -f "$tgt")" == "$DOTFILES"* ]]; then
        continue  # already managed by us
      fi
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$tgt" "$BACKUP_DIR/$rel"
      warn "existing ~/$rel moved to backup"
    fi
  done < <(find "$DOTFILES/$pkg" -mindepth 1 \( -type f -o -type l \) -not -path "*/.git/*")
  stow -d "$DOTFILES" -t "$HOME" "$pkg" && log "stowed: $pkg"
}

log "Deploying dotfiles with stow"
for d in "$DOTFILES"/*/; do
  pkg="$(basename "$d")"
  [[ "$pkg" == "sddm-theme" ]] && { log "skipping sddm-theme (run sddm-theme/install.sh separately)"; continue; }
  deploy_pkg "$pkg"
done
[[ -d "$BACKUP_DIR" ]] && warn "conflicting files backed up to: $BACKUP_DIR"

# ---------- tpm ----------
if [[ -f "$HOME/.config/tmux/tmux.conf" && ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  log "Installing tpm (tmux plugin manager)"
  git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ---------- default shell ----------
if command -v zsh >/dev/null 2>&1 && [[ "${SHELL##*/}" != "zsh" ]]; then
  if $IS_TERMUX; then
    chsh -s zsh && log "default shell set to zsh (restart Termux)" ||
      warn "could not change shell — run manually: chsh -s zsh"
  else
    ZSH_PATH="$(command -v zsh)"
    grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | $SUDO tee -a /etc/shells >/dev/null
    log "changing login shell to $ZSH_PATH (may ask for your password)"
    chsh -s "$ZSH_PATH" && log "default shell set to zsh" ||
      warn "could not change shell — run manually: chsh -s $ZSH_PATH"
  fi
fi

log "Done. Open a new terminal so zsh + zsh4humans bootstrap themselves."
