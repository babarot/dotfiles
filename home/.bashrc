# Minimal settings for the occasional interactive bash. Non-interactive
# bash (scripts, AI agents) stops here and keeps the environment as is.
[[ -z "$PS1" ]] && return

export PATH="$HOME/bin:$PATH"
export PAGER=less
export LESS='-f -X -i -R'
export LESSCHARSET='utf-8'
export LANG=en_US.UTF-8

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000

shopt -s globstar autocd dirspell cdspell 2>/dev/null
