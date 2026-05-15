#
# ~/.bashrc
#

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias l="exit"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sdn="systemctl poweroff -i"
alias clear="command clear && sigma"

PS1='\[\e[94m\]\W > \[\e[0m\]'

export PATH=$PATH:~/.spicetify

# opencode
export PATH=$HOME/.opencode/bin:$PATH
