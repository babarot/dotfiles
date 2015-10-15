#!/bin/bash
#                                    
#         _ _        _       _       
#        (_) |      | |     | |      
#  __   ___| |_ __ _| |  ___| |__    
#  \ \ / / | __/ _` | | / __| '_ \   
#   \ V /| | || (_| | |_\__ \ | | |  
#    \_/ |_|\__\__,_|_(_)___/_| |_|  
#                                    
#                                    

# PLATFORM is the environment variable that
# retrieves the name of the running platform
export PLATFORM

_TAB_="$(printf "\t")"
_SPACE_=' '
_BLANK_="${_SPACE_}${_TAB_}"
_IFS_="$IFS"

vitalize() {
    return 0
}

# Gerenal utilities {{{1
is_interactive() {
    if [ "${-/i/}" != "$-" ]; then
        return 0
    fi
    return 1
}

is_bash() {
    [ -n "$BASH_VERSION" ]
}

is_zsh() {
    [ -n "$ZSH_VERSION" ]
}

is_at_least() {
    if [ -z "$1" ]; then
        return 1
    fi

    # For Z shell
    if is_zsh; then
        autoload -Uz is-at-least
        is-at-least "${1:-}"
        return $?
    fi

    atleast="$(echo $1 | sed -e 's/\.//g')"
    version="$(echo ${BASH_VERSION:-0.0.0} | sed -e 's/^\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/' | sed -e 's/\.//g')"

    # zero padding
    while [ ${#atleast} -ne 6 ]
    do
        atleast="${atleast}0"
    done

    # zero padding
    while [ ${#version} -ne 6 ]
    do
        version="${version}0"
    done

    # verbose
    #echo "$atleast < $version"
    if [ "$atleast" -le "$version" ]; then
        return 0
    else
        return 1
    fi
}

# ostype returns the lowercase OS name
ostype() {
    # shellcheck disable=SC2119
    uname | lower
}

# os_detect export the PLATFORM variable as you see fit
os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='osx'     ;;
        *'bsd'*)    PLATFORM='bsd'     ;;
        *)          PLATFORM='unknown' ;;
    esac
}

# is_osx returns true if running OS is Macintosh
is_osx() {
    os_detect
    if [ "$PLATFORM" = "osx" ]; then
        return 0
    else
        return 1
    fi
}
alias is_mac=is_osx

# is_linux returns true if running OS is GNU/Linux
is_linux() {
    os_detect
    if [ "$PLATFORM" = "linux" ]; then
        return 0
    else
        return 1
    fi
}

# is_bsd returns true if running OS is FreeBSD
is_bsd() {
    os_detect
    if [ "$PLATFORM" = "bsd" ]; then
        return 0
    else
        return 1
    fi
}

# get_os returns OS name of the platform that is running
get_os() {
    local os
    for os in osx linux bsd; do
        if is_$os; then
            echo $os
        fi
    done
}

e_newline() {
    printf "\n"
}

e_header() {
    printf " \033[37;1m%s\033[m\n" "$*"
}

e_error() {
    printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

e_warning() {
    printf " \033[31m%s\033[m\n" "$*"
}

e_done() {
    printf " \033[37;1m%s\033[m...\033[32mOK\033[m\n" "✔ $*"
}

e_arrow() {
    printf " \033[37;1m%s\033[m\n" "➜ $*"
}

e_indent() {
    for ((i=0; i<${1:-4}; i++)); do
        echon " "
    done
    if [ -n "$2" ]; then
        echo "$2"
    else
        cat <&0
    fi
}

e_success() {
    printf " \033[37;1m%s\033[m%s...\033[32mOK\033[m\n" "✔ " "$*"
}

e_failure() {
    die "${1:-$FUNCNAME}"
}

ink() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <color> <text>"
        echo "Colors:"
        echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
        return 1
    fi

    local open="\033["
    local close="${open}0m"
    local black="0;30m"
    local red="1;31m"
    local green="1;32m"
    local yellow="1;33m"
    local blue="1;34m"
    local purple="1;35m"
    local cyan="1;36m"
    local gray="0;37m"
    local white="$close"

    local text="$1"
    local color="$close"

    if [ "$#" -eq 2 ]; then
        text="$2"
        case "$1" in
            black | red | green | yellow | blue | purple | cyan | gray | white)
            eval color="\$$1"
            ;;
        esac
    fi

    printf "${open}${color}${text}${close}"
}

logging() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <fmt> <msg>"
        echo "Formatting Options:"
        echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
        return 1
    fi

    local color=
    local text="$2"

    case "$1" in
        TITLE)
            color=yellow
            ;;
        ERROR | WARN)
            color=red
            ;;
        INFO)
            color=blue
            ;;
        SUCCESS)
            color=green
            ;;
        *)
            text="$1"
    esac

    timestamp() {
        ink gray "["
        ink purple "$(date +%H:%M:%S)"
        ink gray "] "
    }

    timestamp; ink "$color" "$text"; echo
}

log_pass() {
    logging SUCCESS "$1"
}

log_fail() {
    logging ERROR "$1" 1>&2
}

log_fail() {
    logging WARN "$1"
}

log_info() {
    logging INFO "$1"
}

log_echo() {
    logging TITLE "$1"
}

# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

# has is wrapper function
has() {
    is_exists "$@"
}

# die returns exit code error and echo error message
die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}

# is_login_shell returns true if current shell is first shell
is_login_shell() {
    [ "$SHLVL" = 1 ]
}

# is_git_repo returns true if cwd is in git repository
is_git_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
    return $?
}

# is_screen_running returns true if GNU screen is running
is_screen_running() {
    [ ! -z "$STY" ]
}

# is_tmux_runnning returns true if tmux is running
is_tmux_runnning() {
    [ ! -z "$TMUX" ]
}

# is_screen_or_tmux_running returns true if GNU screen or tmux is running
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_runnning
}

# shell_has_started_interactively returns true if the current shell is
# running from command line
shell_has_started_interactively() {
    [ ! -z "$PS1" ]
}

# is_ssh_running returns true if the ssh deamon is available
is_ssh_running() {
    [ ! -z "$SSH_CLIENT" ]
}

# is_debug returns true if $DEBUG is set
is_debug() {
    if [ "$DEBUG" = 1 ]; then
        return 0
    else
        return 1
    fi
}

# is_number returns true if $1 is int type
is_number() {
    if [ $# -eq 0 ]; then
        cat <&0
    else
        echo "$1"
    fi | grep -E '^[0-9]+$' >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
alias is_int=is_number
alias is_num=is_number

# echon is a script to emulate the -n flag functionality with 'echo'
# for Unix systems that don't have that available.
echon() {
    echo "$*" | tr -d '\n'
}

# noecho is the same as echon
noecho() {
    if [ "$(echo -n)" = "-n" ]; then
        echo "${*:-> }\c"
    else
        echo -n "${@:-> }"
    fi
}

# lower returns a copy of the string with all letters mapped to their lower case.
# shellcheck disable=SC2120
lower() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:upper:]" "[:lower:]"
}

# upper returns a copy of the string with all letters mapped to their upper case.
# shellcheck disable=SC2120
upper() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:lower:]" "[:upper:]"
}

# contains returns true if the specified string contains
# the specified substring, otherwise returns false
# http://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-unix-shell-scripting
contains() {
    string="$1"
    substring="$2"
    if [ "${string#*$substring}" != "$string" ]; then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

# len returns the length of $1
len() {
    local length
    length="$(echo "$1" | wc -c | sed -e 's/ *//')"
    #echo "$(expr "$length" - 1)"
    echo $(("$length" - 1))
}

# is_empty returns true if $1 consists of $_BLANK_
is_empty() {
    if [ $# -eq 0 ]; then
        cat <&0
    else
        echo "$1"
    fi | grep -E "^[$_BLANK_]*$" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# path_remove returns new $PATH trailing $1 in $PATH removed
# It was heavily inspired by http://stackoverflow.com/a/2108540/142339
path_remove() {
    if [ $# -eq 0 ]; then
        die "too few arguments"
    fi

    local arg path

    path=":$PATH:"

    for arg in "$@"
    do
        path="${path//:$arg:/:}"
    done

    path="${path%:}"
    path="${path#:}"

    echo "$path"
}

# Dotfiles {{{1

# Set DOTPATH as default variable
if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

DOTFILES_GITHUB="https://github.com/b4b4r07/dotfiles.git"; export DOTFILES_GITHUB

# shellcheck disable=SC1078,SC1079,SC2016
dotfiles_logo='
      | |     | |  / _(_) |           
    __| | ___ | |_| |_ _| | ___  ___  
   / _` |/ _ \| __|  _| | |/ _ \/ __| 
  | (_| | (_) | |_| | | | |  __/\__ \ 
   \__,_|\___/ \__|_| |_|_|\___||___/ 

  *** WHAT IS INSIDE? ***
  1. Download https://github.com/b4b4r07/dotfiles.git
  2. Symlinking dot files to your home directory
  3. Execute all sh files within `etc/init/` (optional)

  See the README for documentation.
  https://github.com/b4b4r07/dotfiles

  Copyright (c) 2014 "BABAROT" aka @b4b4r07
  Licensed under the MIT license.
'

dotfiles_download() {
    if [ -d "$DOTPATH" ]; then
        log_fail "$DOTPATH: already exists"
        exit 1
    fi

    e_newline
    e_header "Downloading dotfiles..."

    if is_debug; then
        :
    else
        if is_exists "git"; then
            # --recursive equals to ...
            # git submodule init
            # git submodule update
            git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"

        elif is_exists "curl" || is_exists "wget"; then
            # curl or wget
            local tarball="https://github.com/b4b4r07/dotfiles/archive/master.tar.gz"
            if is_exists "curl"; then
                curl -L "$tarball"

            elif is_exists "wget"; then
                wget -O - "$tarball"

            fi | tar xvz
            if [ ! -d dotfiles-master ]; then
                log_fail "dotfiles-master: not found"
                exit 1
            fi
            command mv -f dotfiles-master "$DOTPATH"

        else
            log_fail "curl or wget required"
            exit 1
        fi
    fi
    e_newline && e_done "Download"
}

dotfiles_deploy() {
    e_newline
    e_header "Deploying dotfiles..."

    if [ ! -d $DOTPATH ]; then
        log_fail "$DOTPATH: not found"
        exit 1
    fi

    cd "$DOTPATH"

    if is_debug; then
        :
    else
        make deploy
    fi &&

        e_newline && e_done "Deploy"
}

dotfiles_initialize() {
    if [ "$1" = "init" ]; then
        e_newline
        e_header "Initializing dotfiles..."

        if is_debug; then
            :
        else
            if [ -f Makefile ]; then
                #DOTPATH="$(dotpath)"
                #export DOTPATH
                #bash "$DOTPATH"/etc/init/init.sh
                make init
            else
                log_fail "Makefile: not found"
                exit 1
            fi
        fi &&

            e_newline && e_done "Initialize"
    fi
}

# A script for the file named "install"
dotfiles_install() {
    # 1. Download the repository
    # ==> downloading
    #
    # Priority: git > curl > wget
    dotfiles_download &&

    # 2. Deploy dotfiles to your home directory
    # ==> deploying
    dotfiles_deploy &&

    # 3. Execute all sh files within etc/init/
    # ==> initializing
    dotfiles_initialize "$@"
}

if echo "$-" | grep -q "i"; then
    # -> source a.sh
    VITALIZED=1
    export VITALIZED

    : return
else
    # three patterns
    # -> cat a.sh | bash
    # -> bash -c "$(cat a.sh)"
    # -> bash a.sh

    # -> bash a.sh
    if [ "$0" = "${BASH_SOURCE:-}" ]; then
        exit
    fi

    # -> cat a.sh | bash
    # -> bash -c "$(cat a.sh)"
    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
        # if already vitalized, skip to run dotfiles_install
        if [ "${VITALIZED:=0}" = 1 ]; then
            exit
        fi

        trap "e_error 'terminated'; exit 1" INT ERR
        echo "$dotfiles_logo"
        dotfiles_install "$@"

        # Restart shell if specified "bash -c $(curl -L {URL})"
        # not restart:
        #   curl -L {URL} | bash
        if [ -p /dev/stdin ]; then
            e_warning "Now continue with Rebooting your shell"
        else
            e_newline
            e_arrow "Restarting your shell..."
            exec "${SHELL:-/bin/zsh}"
        fi
    fi
fi

# __END__ {{{1
# vim:fdm=marker
