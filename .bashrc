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

export MYHISTFILE=~/.bash_myhistory

#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------
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

ALERT=${BWhite}${On_Red} # Bold White on red background

bash_exit() { #{{{1
    HISTSIZE=50000
    HISTFILESIZE=50000

    show_exit() {
        if [ "$1" -eq 0 ]; then return; fi
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
}

#bash_shopt() { #{{{1
#    #set -o nounset     # These  two options are useful for debugging.
#    #set -o xtrace
#    alias debug="set -o nounset; set -o xtrace"
#
#    ulimit -S -c 0      # Don't want coredumps.
#    set -o notify
#    set -o noclobber
#    set -o ignoreeof
#
#
#    # Enable options:
#    shopt -s cdspell
#    shopt -s cdable_vars
#    shopt -s checkhash
#    shopt -s checkwinsize
#    shopt -s sourcepath
#    shopt -s no_empty_cmd_completion
#    shopt -s cmdhist
#    shopt -s histappend histreedit histverify
#    shopt -s extglob       # Necessary for programmable completion.
#
#    # Disable options:
#    shopt -u mailwarn
#    unset MAILCHECK        # Don't want my shell to warn me of incoming mail.
#}
#
#bash_alias() {
#    alias vi=vim
#}
#
#bash_function() {
#    if is_osx; then
#        op() {
#            if [ -p /dev/stdin ]; then
#                open $(cat -) "$@"
#            elif [ -z "$1" ]; then
#                open .
#            else
#                open "$@"
#            fi
#        }
#
#        tex() {
#            if ! $(has 'platex') || ! $(has 'dvipdfmx'); then
#                return 1
#            fi
#            platex "$1" && dvipdfmx "${1/.tex/.dvi}" && {
#            echo -e "\n\033[31mCompile complete!\033[m"
#        } && if $(has 'open'); then
#        open "${1/.tex/.pdf}"; fi
#    }
#
#    deadlink() {
#        local f
#        for f in `command ls -A "${1:-$PWD}"`; do
#            local fpath="${1:-$PWD}/$f"
#            if [ -h "$fpath" ]; then
#                [ -a "$fpath" ] || command rm -i "$fpath"
#            fi
#        done
#        unset f fpath
#    }
#
#    strlen() {
#        local length=`echo "$1" | wc -c | sed -e 's/ *//'`
#        echo `expr $length - 1`
#    }
#
#    sort() {
#        if [ "$1" = '--help' ]
#        then
#            command sort --help
#            echo -e '\n\nOptions that are described below is an additional option that was made by b4b4r07.\n'
#            echo -e '  -p, --particular-field    sort an optional field; if not given arguments, 2 as a default\n'
#            return 0
#        elif [ "$1" = '-p' -o "$1" = '--particular-field' ]
#        then
#            shift
#            gawk '
#            {
#                line[NR] = $'${1:-2}' "\t" $0;
#            }
#
#            END {
#            asort(line);
#            for (i = 1; i <= NR; i++) {
#                print substr(line[i], index(line[i], "\t") + 1);
#            }
#        }' 2>/dev/null
#        return 0
#        fi
#        command sort "$@"
#    }
#
#    repeat() {
#        local i max
#        max=$1; shift;
#        for ((i=1; i <= max ; i++)); do
#            eval "$@";
#        done
#    }
#
#    richpager()
#    # By the file number of lines, switch using cat or less.
#    # If the pygmentize exists, use it instead of cat.
#    {
#        # Use cat as default pager.
#        Pager='cat'
#        if type pygmentize >/dev/null 2>&1; then
#            # Use pygmentize, if exist.
#            Pager='pygmentize'
#        fi
#        # Less option.
#        Less='less -R +Gg'
#        # Get display lines.
#        DispLines=$[ $( stty 'size' < '/dev/tty' | cut -d' ' -f1 ) - 2 ]
#
#        # Normal case.
#        # Can use pygmentize to syntax highlight, if exist.
#        # ex) user$ ./richpager file
#        if [ $# -eq 1 ]; then
#            if [ -f $1 ]; then
#                Filename="$1"
#                FileLines=$(wc -l <$Filename)
#                if (( FileLines > DispLines )); then
#                    export LESSOPEN='| pygmentize %s'
#                    ${Less} $Filename
#                    unset LESSOPEN
#                else
#                    ${Pager} $Filename
#                fi
#            fi
#            return 0
#        else
#            # Many argument.
#            # Cannot use pygmentize bacause cannot judge filetype from extension.
#            # ex) user$ ./richpager file1 file2
#            while (( $# > 0 )) ; do
#                case "$1" in
#                    '-n')
#                        nflag='-n'
#                        shift && continue
#                        ;;
#                esac
#
#                # Directory.
#                if [[ -d "$1" ]] ; then
#                    ls "$1"
#                    exit 0
#
#                    # Readable files.
#                elif [[ -r "$1" ]] ; then
#                    List[${#List[@]}]=$( < "$1" )
#
#                    # Enigma.
#                else
#                    List[${#List[@]}]=$1
#                fi
#
#                shift
#            done
#
#            # Get file contents.
#            if (( ${#List[@]} > 0 )) ; then
#                File=$( for i in "${List[@]}" ; do echo "$i"; done )
#
#                # No argument, no pipe.
#            elif [[ -t 0 ]] ; then
#                echo "error: No argument." 1>&2
#                return 1
#
#                # Pipe detected.
#                # Cannot use pygmentize even if it exists.
#                # See also pygmentize -h (help file).
#            else
#                File=$( cat - )
#            fi
#
#            # Count file chars.
#            FileLines=$( echo -n "$File" | grep -c '' )
#
#            # File is empty.
#            if (( FileLines < 0 )); then
#                echo "error: No entry." 1>&2
#                return 1
#            fi
#        fi
#
#        # Judgement cat or less.
#        if (( FileLines > DispLines )); then
#            echo "$File" | cat ${nflag} |${Less}
#        else
#            echo "$File" | cat ${nflag}
#        fi
#
#        return 0
#    }
#}

bash_zshlike() {
    shopt -s globstar
    #shopt -s dotglob
    shopt -s extglob
    shopt -s cdspell
    shopt -s autocd
    shopt -s cdspell
}

bash_loading() { #{{{1
    if [ -d ~/.loading ]; then
        . ~/.loading/*.sh
    fi

    [ -f /etc/bash_completion ]     && . /etc/bash_completion
    [ -f /etc/git-completion.bash ] && . /etc/git-completion.bash
    [ -f /etc/git-prompt.bash ]     && . /etc/git-prompt.bash
}

bash_at_startup() { #{{{1
    echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (start)" >> $MYHISTFILE

    bash_loading

    #cowsay -f ghostbusters "$(fortune -s)"
    echo
}

if bash_at_startup; then
    PS1="[${Yellow}\u${NC}]:${Blue}\w${NC}\$ "
    export PS1

    #bash_shopt
    #bash_exit

    #if ! is_osx && has "dircolors"; then
    #    $(dircolors -b ~/.dir_colors)
    #fi
fi

# __END__{{{1
# vim:fdm=marker fdc=3 ft=sh ts=4 sw=4 sts=4:
