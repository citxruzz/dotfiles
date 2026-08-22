#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"


# Added by Antigravity CLI installer
export PATH="/home/lemyn/.local/bin:$PATH"
