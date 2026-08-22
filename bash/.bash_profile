#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
