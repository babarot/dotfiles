#!/bin/sh
#!/bin/bash
#!/bin/zsh

# SHELL
is_bash() { [[ -n $BASH_VERSION ]]; }
is_zsh() { [[ -n $ZSH_VERSION ]]; }

# PLATFORM
export SHELL_PLATFORM='unknown'
ostype() { echo "$OSTYPE" | tr '[:upper:]' '[:lower:]'; }
case "$(ostype)" in
    *'linux'*)  SHELL_PLATFORM='linux' ;;
    *'darwin'*) SHELL_PLATFORM='osx'   ;;
    *'bsd'*)    SHELL_PLATFORM='bsd'   ;;
esac
is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx()   { [[ $SHELL_PLATFORM == 'osx' ]]; }
is_bsd()   { [[ $SHELL_PLATFORM == 'bsd' || $SHELL_PLATFORM == 'osx' ]]; }

# Check if exists
#has() { type "$1" >/dev/null 2>&1; return $?; }
#has() {
#    if [[ ${1[1,1]} =~ / ]]; then
#        if [[ -e "$1" ]]; then
#            return 0
#        fi
#    else
#        if type "$1" >/dev/null 2>&1; then
#            return 0
#        fi
#    fi
#    return 1
#}

# Whether first login shell
is_login_shell() { [[ $SHLVL == 1 ]]; }

# Test whether we're in a git repo
is_git_repo() { git rev-parse --is-inside-work-tree &>/dev/null; }

# Check if running the screen or tmux
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_runnning() { [ ! -z "$TMUX" ]; }
is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
shell_has_started_interactively() { [ ! -z "$PS1" ]; }
is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

# Check if exists and sourcing file
import() { eval "[[ -${2:-f} $1 ]]" && source "$1"; }

cwd() {
    cd "$(dirname "${1:-${BASH_SOURCE:-$0}}")" && pwd
}

has() {
    type "$1" >/dev/null 2>&1
    return $?
}
alias is_exist=has
alias is_exists=has

hasnt() {
    has "$1" && return 1 || return 0
}
alias hasnot=hasnt

is_help() {
    [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]
}
