#       ___           ___           ___           ___           ___           ___      
#      /\  \         /\  \         /\  \         /\__\         /\  \         /\  \     
#     /::\  \       /::\  \       /::\  \       /:/  /        /::\  \       /::\  \    
#    /:/\:\  \     /:/\:\  \     /:/\ \  \     /:/__/        /:/\:\  \     /:/\:\  \   
#   /::\~\:\__\   /::\~\:\  \   _\:\~\ \  \   /::\  \ ___   /::\~\:\  \   /:/  \:\  \  
#  /:/\:\ \:|__| /:/\:\ \:\__\ /\ \:\ \ \__\ /:/\:\  /\__\ /:/\:\ \:\__\ /:/__/ \:\__\ 
#  \:\~\:\/:/  / \/__\:\/:/  / \:\ \:\ \/__/ \/__\:\/:/  / \/_|::\/:/  / \:\  \  \/__/ 
#   \:\ \::/  /       \::/  /   \:\ \:\__\        \::/  /     |:|::/  /   \:\  \       
#    \:\/:/  /        /:/  /     \:\/:/  /        /:/  /      |:|\/__/     \:\  \      
#     \::/__/        /:/  /       \::/  /        /:/  /       |:|  |        \:\__\     
#      ~~            \/__/         \/__/         \/__/         \|__|         \/__/     
#                                                                                      

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

[ -n "$VIMRUNTIME" ] && return

# It is necessary for the setting of DOTPATH
#[ -f ~/.path ] && source ~/.path

# DOTPATH environment variable specifies the location of dotfiles.
# On Unix, the value is a colon-separated string. On Windows,
# it is not yet supported.
# DOTPATH must be set to run make init, make test and shell script library
# outside the standard dotfiles tree.
if [ -z "$DOTPATH" ]; then
    echo "cannot start $SHELL, \$DOTPATH not set" 1>&2
    return 1
fi

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh
if ! vitalize 2>/dev/null; then
    echo "cannot vitalize, cannot start $SHELL" 1>&2
    return 1
fi

export PATH=~/bin:"$PATH"
export PAGER=less
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESS='-f -N -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESS='-f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC="\033[m"               # Color Reset
CR="$(echo -ne '\r')"
LF="$(echo -ne '\n')"
TAB="$(echo -ne '\t')"
ESC="$(echo -ne '\033')"

# If set to a number greater than zero, the value is used as the number of trailing
# directory components to retain when expanding the \w and \W prompt string
# escapes (see PROMPTING below). Characters removed are replaced with an ellipsis.
if is_at_least 4; then
    export PROMPT_DIRTRIM=3
fi

# man bash
export MYHISTFILE=~/.bash_myhistory
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000
export HISTFILESIZE=50000

show_exit() {
    if [ "$1" -eq 0 ]; then
        return
    fi
    echo -e "\007exit $1"
}

log_history() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD ($1) $(history 1)" >> $MYHISTFILE
}

prompt_cmd() {
    local s=$?
    show_exit $s;
    log_history $s;
}

end_history() {
    log_history $?;
    echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (end)" >> $MYHISTFILE
}
PROMPT_COMMAND="prompt_cmd;$PROMPT_COMMAND"

_exit() {
    end_history
    echo -e  "${BRed}Hasta la vista, baby!"
    echo -en "\033[m"
}
trap _exit EXIT

[ -z "$TMPDIR" ] && TMPDIR=/tmp

### Global
export GOPATH=~/src
mkdir -p $GOPATH 2>/dev/null
export EDITOR=vim
export LANG=en_US.UTF-8

# Prompt setting
if [ "$PLATFORM" = "linux" ]; then
    PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
    PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
    ### git-prompt
    __git_ps1() { :; }
    if [ -f ~/.modules/git-prompt.sh ]; then
        source ~/.modules/git-prompt.sh
    fi
    my__git_ps1() { is_git_repo && echo -e "${Red}$(__git_ps1)${NC}" || :; }
    PROMPT_COMMAND="my__git_ps1;$PROMPT_COMMAND"
    PS1="\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[35m\]:"
    PS1="$PS1\[\e[m\]\w\[\e[1;31m\]> \[\e[0m\]"
fi

export FZF_DEFAULT_OPTS='--extended'

bash_alias() {
    # For mac, aliases
    if is_osx; then
        has "qlmanage" && alias ql='qlmanage -p "$@" >&/dev/null'
    fi

    if has 'git'; then
        alias gst='git status'
    fi

    if has 'richpager'; then
        alias cl='richpager'
    fi

    # Common aliases
    alias ..='cd ..'
    alias ld='ls -ld'          # Show info about the directory
    alias lla='ls -lAF'        # Show hidden all files
    alias ll='ls -lF'          # Show long file information
    alias l='ls -1F'          # Show long file information
    alias la='ls -AF'          # Show hidden files
    alias lx='ls -lXB'         # Sort by extension
    alias lk='ls -lSr'         # Sort by size, biggest last
    alias lc='ls -ltcr'        # Sort by and show change time, most recent last
    alias lu='ls -ltur'        # Sort by and show access time, most recent last
    alias lt='ls -ltr'         # Sort by date, most recent last
    alias lr='ls -lR'          # Recursive ls

    # The ubiquitous 'll': directories first, with alphanumeric sorting:
    #alias ll='ls -lv --group-directories-first'

    alias cp="cp -i"
    alias mv="mv -i"

    alias du='du -h'
    alias job='jobs -l'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Use if colordiff exists
    if has 'colordiff'; then
        alias diff='colordiff -u'
    else
        alias diff='diff -u'
    fi

    alias vi="vim"

    # Use plain vim.
    alias nvim='vim -N -u NONE -i NONE'

    # The first word of each simple command, if unquoted, is checked to see 
    # if it has an alias. [...] If the last character of the alias value is 
    # a space or tab character, then the next command word following the 
    # alias is also checked for alias expansion
    alias sudo='sudo '
}

bashrc_shopt() {
    # This builtin allows you to change additional shell optional behavior.
    #
    # shopt
    #  shopt [-pqsu] [-o] [optname ...]
    #
    # Toggle the values of settings controlling optional shell behavior.
    # The settings can be either those listed below, or, if the -o option is used, 
    # those available with the -o option to the set builtin command (see The Set Builtin).
    # With no options, or with the -p option, a list of all settable options is displayed,
    # with an indication of whether or not each is set. The -p option causes output to be
    # displayed in a form that may be reused as input. Other options have the following meanings:
    #
    # -s
    # Enable (set) each optname.
    #
    # -u
    # Disable (unset) each optname.
    #
    # -q
    # Suppresses normal output; the return status indicates whether the optname is set or unset.
    # If multiple optname arguments are given with -q, the return status is zero if all optnames
    # are enabled; non-zero otherwise.
    #
    # -o
    # Restricts the values of optname to be those defined for the -o option to the set builtin
    # (see The Set Builtin).
    # http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

    # If set, Bash includes filenames beginning with a '.' in the results of
    # filename expansion.
    #shopt -s dotglob

    # If set, the extended pattern matching features described above
    # (see Pattern Matching) are enabled.
    shopt -s extglob

    # If set, minor errors in the spelling of a directory component in a cd command
    # will be corrected. The errors checked for are transposed characters, a missing
    # character, and a character too many. If a correction is found, the corrected path
    # is printed, and the command proceeds. This option is only used by interactive shells.
    shopt -s cdspell

    if is_at_least 4.0.0; then
        # If set, the pattern '**' used in a filename expansion context will match
        # all files and zero or more directories and subdirectories. If the pattern
        # is followed by a '/', only directories and subdirectories match.
        shopt -s globstar

        # If set, a command name that is the name of a directory is executed as
        # if it were the argument to the cd command. This option is only used by
        # interactive shells.
        shopt -s autocd

        # If set, Bash attempts spelling correction on directory names during word
        # completion if the directory name initially supplied does not exist.
        shopt -s dirspell
    fi
}

bashrc_loading() {
    echo -e "${Blue}Starting ${SHELL}...${NC}"

    # Load ~/.modules modules
    local f
    for f in ~/.modules/*.sh
    do
        # source non-executable file
        if [ ! -x "$f" ]; then
            . "$f" 2>/dev/null && echo "loading $f" | e_indent 2
        fi
    done
    echo

    local repo repos
    # repos is a list of bash plugins you want to download and use
    # The repo's name must consist of "username/reponame"
    repos=(
    "b4b4r07/enhancd"
    )

    # repo is available
    if [ "${#repos[@]}" -ne 0 ]; then
        e_arrow $(e_header "Setup plugins...")
        mkdir -p "$HOME/.repos"
    fi

    for repo in "${repos[@]}"
    do
        # repo need to be the string that consists of username/reponame
        if [[ ! $repo =~ ^[A-Za-z0-9_-]+/[A-Za-z0-9_-]+$ ]]; then
            # skip
            continue
        fi

        # get repo from github.com if it doesn't exist
        if [ ! -d "$HOME/.repos/$repo" ]; then
            # download to ~/.repo
            git clone "https://github.com/$repo" "$HOME/.repos/$repo"
        fi

        # finding and sourcing script file in repo
        . $(find "$HOME/.repos/$repo" -name "*${repo##*/}*" -depth 1 | grep -E "${repo##*/}($|\.sh$)")
        # displaying the info
        if [ $? -eq 0 ]; then
            echo "checking... $HOME/.repos/$repo/${repo##*/}".sh | e_indent 2
        fi
    done

    #[ -f /etc/bash_completion ]     && . /etc/bash_completion
    #[ -f /etc/git-completion.bash ] && . /etc/git-completion.bash
    #[ -f /etc/git-prompt.bash ]     && . /etc/git-prompt.bash
}

bashrc_startup() {
    # tmux_automatically_attach attachs tmux session automatically when your are in zsh
    tmux_automatically_attach

    bashrc_loading || return 1

    echo
    echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (start)" >> $MYHISTFILE

    #cowsay -f ghostbusters "$(fortune -s)"
    echo
}

if bashrc_startup; then
    bashrc_shopt
fi

# __END__{{{1
# vim:fdm=marker fdc=3 ft=sh ts=4 sw=4 sts=4:

complete -C /usr/local/bin/vault vault

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
