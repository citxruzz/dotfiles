#!/usr/bin/env bash
# Installs the sddm-astronaut-theme into /usr/share/sddm/themes.
# Run from anywhere:  ~/dotfiles/sddm-theme/install.sh
set -euo pipefail

SRC="$(cd "$(dirname "$0")/sddm-astronaut-theme" && pwd)"
DST="/usr/share/sddm/themes/sddm-astronaut-theme"
THEME_VARIANT="hyprland_kath"   # variant currently in use (metadata.desktop ConfigFile)

sudo mkdir -p "$(dirname "$DST")"
sudo rm -rf "$DST"
sudo cp -r "$SRC" "$DST"

# Point metadata at the active theme variant
sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${THEME_VARIANT}.conf|" "$DST/metadata.desktop"

echo "Installed to $DST (variant: ${THEME_VARIANT})"
echo "Make sure /etc/sddm.conf contains: Current=sddm-astronaut-theme"
