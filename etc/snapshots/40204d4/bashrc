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
#
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# Last modified: Tue Nov 20 22:04:47 CET 2012
#
#  This file is normally read by interactive shells only.
#+ Here is the place to define your aliases, functions and
#+ other interactive features like your prompt.
#
#  The choice of colors was done for a shell with a dark background
#+ (white on black), and this is usually also suited for pure text-mode
#+ consoles (no X server available). If you use a white background,
#+ you'll have to do some other choices for readability.
#
#  This bashrc file is a bit overcrowded.
#  Remember, it is just just an example.
#  Tailor it to your needs.
# =============================================================== #

# Initial. {{{1

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Language
export LANG=C
export LC_ALL=en_US.UTF-8

# Read /etc/bashrc, if present.
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Check existing.
function has()
{
	type $1 >/dev/null 2>&1; return $?;
}

# OS judgement. boolean.
is_mac=$( uname | grep -qi 'darwin' && true || false )
is_linux=$( uname | grep -qi 'linux' && true || false )

# environment variables
export OS=$(uname | awk '{print tolower($1)}')
export BIN="$HOME/.bin"
export PATH="$BIN:$PATH"

# Search executable file in $PATH.
function search()
{
	local    IFS=$'\n'
	local -i i=0
	local -a TARGET=( `echo $PATH | tr ':' "\n" | sort | uniq` )

	for ((i=0; i<${#TARGET[@]}; i++)); do
		if [ -x ${TARGET[i]}/"$1" ]; then
			echo "${TARGET[i]}/$1"
		fi
	done
}

#--------------------------------------------------------------
# Define EDITOR environment value with search().
# Use vim with compiled '+clipboard', if present.
#--------------------------------------------------------------
all_vim_path=( `search vim` )
for ((i=0; i<${#all_vim_path[@]}; i++)); do
	if ${all_vim_path[i]} --version 2>/dev/null | grep -qi '+clipboard'; then
		clipboard_vim_path="${all_vim_path[i]}"
		break
	fi
done
export EDITOR="${clipboard_vim_path:-vim}"
unset i all_vim_path clipboard_vim_path

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
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

#-------------------------------------------------------------
# Tailoring 'ls'
#-------------------------------------------------------------
all_ls_path=( `search ls` )
for ((i=0; i<${#all_ls_path[@]}; i++)); do
	if ${all_ls_path[i]} --version 2>/dev/null | grep -qi "GNU"; then
		export LSPATH="${all_ls_path[i]}"
		break
	fi
done
unset i all_ls_path
if $(has 'gls'); then
	alias ls="gls --color=auto -F -b"
else
	alias ls="$LSPATH --color=auto -F -b"
	if [ "$LSPATH" == "" ]; then
		unalias ls
	fi
fi

#--------------------------------------------------------------
#  Automatic setting of $DISPLAY (if not set already).
#  This works for me - your mileage may vary. . . .
#  The problem is that different types of terminals give
#+ different answers to 'who am i' (rxvt in particular can be
#+ troublesome) - however this code seems to work in a majority
#+ of cases.
#--------------------------------------------------------------

function get_xserver()
{
    case $TERM in
			xterm* )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            # Ane-Pieter Wieringa suggests the following alternative:
            #  I_AM=$(who am i)
            #  SERVER=${I_AM#*(}
            #  SERVER=${SERVER%*)}
            XSERVER=${XSERVER%%:*}
            ;;
            aterm | rxvt)
            # Find some code that works here. ...
            ;;
    esac
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) ||
       ${XSERVER} == "unix" ]]; then
          DISPLAY=":0.0"          # Display on local host.
    else
       DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi
fi

export DISPLAY

# Coloring variables {{{2
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
#}}}

# If completion files exist, load it.
[ -f /etc/bash_completion ]     && . /etc/bash_completion
[ -f /etc/git-completion.bash ] && . /etc/git-completion.bash
[ -f /etc/git-prompt.bash ]     && . /etc/git-prompt.bash

# Linux.
if [ "$OS" = "linux" ]; then
	:
	#[ -f ~/.bashrc.unix ] && source ~/.bashrc.unix

# Max OSX.
elif [ "$OS" = "darwin" ]; then
	:
	#[ -f ~/.bashrc.mac ] && source ~/.bashrc.mac
fi

# Local configure file.
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

# Start bash.
echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"

# Loads the file except executable one.
test -d $BIN || mkdir -p $BIN
if [ -d $BIN ]; then
	if ls -A1 $BIN/ | grep -q '.sh'; then
		for f in $BIN/*.sh ; do
			[ ! -x "$f" ] && . "$f" && echo " load $f"
		done
		echo ""
		unset f
	fi
fi

date

# Show fortune instead of nowon
# Makes our day a bit more fun.... :-)
# if nowon does not exist, ...
# execute handler:
# > nowon_on=1
if [ "$nowon_on"x == 'x' ]; then
	if $(has 'fortune'); then
		`which fortune` -s
	fi
fi

# Utilities. {{{1
#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------

if $is_mac; then
	function op()
	{
		if [ -p /dev/stdin ]; then
			open $(cat -) "$@"
		elif [ -z "$1" ]; then
			open .
		else
			open "$@"
		fi
	}

	function tex()
	{
		if ! $(has 'platex') || ! $(has 'dvipdfmx'); then
			return 1
		fi
		platex "$1" && dvipdfmx "${1/.tex/.dvi}" && {
		echo -e "\n\033[31mCompile complete!\033[m"
			} && if $(has 'open'); then
		open "${1/.tex/.pdf}"; fi
	}

	function poweroff() {
		osascript -e "set Volume 0"
		osascript -e 'tell application "Finder" to shut down'
	}
fi

function my_readlink()
{
	TARGET_FILE=$1
	
	builtin cd `dirname $TARGET_FILE`
	TARGET_FILE=`basename $TARGET_FILE`
	
	# Iterate down a (possible) chain of symlinks
	while [ -L "$TARGET_FILE" ]
	do
		TARGET_FILE=`readlink $TARGET_FILE`
		cd `dirname $TARGET_FILE`
		TARGET_FILE=`basename $TARGET_FILE`
	done
	
	# Compute the canonicalized name by finding the physical path 
	# for the directory we're in and appending the target file.
	PHYS_DIR=`pwd -P`
	RESULT=$PHYS_DIR/$TARGET_FILE
	echo $RESULT
}

function random_cowsay()
{
	# /usr/local/Cellar/cowsay/3.03/share/cows
	#COWS=$(readlink -f $(which cowsay))/../../share/cows
	COWS=`my_readlink $(which cowsay)/../../share/cows`
	NBRE_COWS=$(ls -1 $COWS | wc -l)
	COWS_RANDOM=$(expr $RANDOM % $NBRE_COWS + 1)
	COW_NAME=$(ls -1 $COWS | awk -F\. -v COWS_RANDOM_AWK=$COWS_RANDOM 'NR == COWS_RANDOM_AWK {print $1}')

	if [ -f ~/.cowsay_name ]; then
		COW_NAME=$(sed -n '1p' ~/.cowsay_name)
	else
		COW_NAME=$(ls -1 $COWS | awk -F\. -v COWS_RANDOM_AWK=$COWS_RANDOM 'NR == COWS_RANDOM_AWK {print $1}')
	fi

	cowsay -f $COW_NAME "`Fortune -s`"
}

function nowon()
{
	if which fortune cowsay >/dev/null; then
		while :
		do
			random_cowsay 2>/dev/null && break
		done
	fi && unset random_cowsay
	LANG=C
	echo -e  "\033[33m$(date +'%Y/%m/%d %T')\033[m"
	echo -en "\n"; pwd; echo -en "\n"
}

function richpager()
# By the file number of lines, switch using cat or less.
# If the pygmentize exists, use it instead of cat.
{
	# Use cat as default pager.
	Pager='cat'
	if type pygmentize >/dev/null 2>&1; then
		# Use pygmentize, if exist.
		Pager='pygmentize'
	fi
	# Less option.
	Less='less -R +Gg'
	# Get display lines.
	DispLines=$[ $( stty 'size' < '/dev/tty' | cut -d' ' -f1 ) - 2 ]

	# Normal case.
	# Can use pygmentize to syntax highlight, if exist.
	# ex) user$ ./richpager file
	if [ $# -eq 1 ]; then
		if [ -f $1 ]; then
			Filename="$1"
			FileLines=$(wc -l <$Filename)
			if (( FileLines > DispLines )); then
				export LESSOPEN='| pygmentize %s'
				${Less} $Filename
				unset LESSOPEN
			else
				${Pager} $Filename
			fi
		fi
		return 0
	else
		# Many argument.
		# Cannot use pygmentize bacause cannot judge filetype from extension.
		# ex) user$ ./richpager file1 file2
		while (( $# > 0 )) ; do
			case "$1" in
				'-n')
					nflag='-n'
					shift && continue
					;;
			esac

			# Directory.
			if [[ -d "$1" ]] ; then
				ls "$1"
				exit 0

				# Readable files.
			elif [[ -r "$1" ]] ; then
				List[${#List[@]}]=$( < "$1" )

				# Enigma.
			else
				List[${#List[@]}]=$1
			fi

			shift
		done

		# Get file contents.
		if (( ${#List[@]} > 0 )) ; then
			File=$( for i in "${List[@]}" ; do echo "$i"; done )

		# No argument, no pipe.
		elif [[ -t 0 ]] ; then
			echo "error: No argument." 1>&2
			return 1

		# Pipe detected.
		# Cannot use pygmentize even if it exists.
		# See also pygmentize -h (help file).
		else
			File=$( cat - )
		fi

		# Count file chars.
		FileLines=$( echo -n "$File" | grep -c '' )

		# File is empty.
		if (( FileLines < 0 )); then
			echo "error: No entry." 1>&2
			return 1
		fi
	fi

	# Judgement cat or less.
	if (( FileLines > DispLines )); then
		echo "$File" | cat ${nflag} |${Less}
	else
		echo "$File" | cat ${nflag}
	fi

	return 0
}

function tac()
{
	[ -z "$1" ] && exit 1
	`which ex` -s "${1}" <<-EOF
	g/^/mo0
	%p
	EOF
}

function deadlink()
{
	local f=

	for f in `command ls -A "${1:-$PWD}"`; do
		local fpath="${1:-$PWD}/$f"
		if [ -h "$fpath" ]; then
			[ -a "$fpath" ] || command rm -i "$fpath"
		fi
	done

	unset f fpath
}

function abs_path()
{
	if [ -z "$1" ]; then
		return 1
	fi

	if [ `expr x"$1" : x'/'` -ne 0 ]; then
		local rel="$1"
	else
		local rel="$PWD/$1"
	fi

	local abs="/"
	local _IFS="$IFS"; IFS='/'

	for comp in $rel; do
		case "$comp" in
			'.' | '')
				continue
				;;
			'..'	)
				abs=`dirname "$abs"`
				;;
			*		)
				[ "$abs" = "/" ] && abs="/$comp" || abs="$abs/$comp"
				;;
		esac
	done
	echo "$abs"
	IFS="$_IFS"
}

function rel_path()
{
	if [ -z "$1" ]; then
		return 1
	fi

	if [ `expr x"$1" : x'/'` -eq 0 ]; then
		echo "$1: not an absolute path"
		return 1
	fi

	local org=`expr x"$PWD" : x'/\(.*\)'`
	local abs=`expr x"$1"   : x'/\(.*\)'`
	local rel="."
	local org1=""
	local abs1=""

	while true; do
		org1=`expr x"$org" : x'\([^/]*\)'`
		abs1=`expr x"$abs" : x'\([^/]*\)'`

		[ "$org1" != "$abs1" ] && break

		org=`expr x"$org" : x'[^/]*/\(.*\)'`
		abs=`expr x"$abs" : x'[^/]*/\(.*\)'`
	done

	if [ -n "$org" ]; then
		local _IFS="$IFS"; IFS='/'
		for c in $org; do
			rel="$rel/.."
		done
		IFS="$_IFS"
	fi

	if [ -n "$abs" ]; then
		rel="$rel/$abs"
	fi

	rel=`expr x"$rel" : x'\./\(.*\)'`
	echo "$rel"
}

function is_pipe()
{
	if [ -p /dev/stdin ]; then
		#if [ -p /dev/fd/0  ]; then
		#if [ -p /proc/self/fd/0 ]; then
		#if [ -t 0 ]; then
		# echo a | is_pipe
		return 0
	elif [ -p /dev/stdout ]; then
		# is_pipe | cat
		return 0
	else
		# is_pipe (Only!)
		return 1
	fi
}

function nonewline()
{
	if [ "$(echo -n)" = "-n" ]; then
		echo "${@:-> }\c"
	else
		echo -n "${@:-> }"
	fi
}

function is_num()
{
	expr "$1" \* 1 >/dev/null 2>&1
	if [ $? -ge 2 ]; then
		return 1
	else
		return 0
	fi
}

function strcmp()
{
	# abc == abc (return  0)
	# abc =< def (return -1)
	# def >= abc (return  1)
	if [ $# -ne 2 ]; then
		echo "Usage: strcmp string1 string2" 1>&2
		exit 1
	fi
	if [ "$1" = "$2" ]; then
		#return 0
		echo "0"
	else
		local _TMP=`{ echo "$1"; echo "$2"; } | sort -n | sed -n '1p'`

		if [ "$_TMP" = "$1" ]; then
			#return -1
			echo "-1"
		else
			#return 1
			echo "1"
		fi
	fi
}

function strlen()
{
	local length=`echo "$1" | wc -c | sed -e 's/ *//'`
	echo `expr $length - 1`
}

function sort()
{
	if [ "$1" = '--help' ]
	then
		command sort --help
		echo -e '\n\nOptions that are described below is an additional option that was made by b4b4r07.\n'
		echo -e '  -p, --particular-field    sort an optional field; if not given arguments, 2 as a default\n'
		return 0
	elif [ "$1" = '-p' -o "$1" = '--particular-field' ]
	then
		shift
		gawk '
		{
			line[NR] = $'${1:-2}' "\t" $0;
		}

		END {
		asort(line);
		for (i = 1; i <= NR; i++) {
			print substr(line[i], index(line[i], "\t") + 1);
		}
	}' 2>/dev/null
	return 0
fi
command sort "$@"
}

function man()
{
    for i ; do
        xtitle The $(basename $1|tr -d .[:digit:]) manual
        command man -a "$i"
    done
}

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

function ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

function corename()   # Get name of app that created a corefile.
{
    for file ; do
        echo -n $file : ; gdb --core=$file --batch | head -1
    done
}

# Priority. {{{1

# history {{{2
#-------------------------------------------------------------
# Enrich your history file. The ~/.bash_history is default.
#-------------------------------------------------------------
HISTSIZE=50000
HISTFILESIZE=50000

export MYHISTFILE=$HOME/.bash_myhistory
function show_exit()
{
	if [ "$1" -eq 0 ]; then return; fi
	echo -e "\007exit $1"
}

function log_history()
{
	echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD ($1) $(history 1)" >> $MYHISTFILE
}

function prompt_cmd()
{
	local s=$?
	show_exit $s;
	log_history $s;
}

function end_history()
{
	log_history $?;
	echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (end)" >> $MYHISTFILE
}

echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (start)" >> $MYHISTFILE
#trap end_history EXIT
PROMPT_COMMAND="prompt_cmd;$PROMPT_COMMAND"
#}}}

function _exit()
# Function to run upon exit of shell.
{
	end_history
  echo -e  "${BRed}Hasta la vista, baby!"
  echo -en "\033[m"
}
trap _exit EXIT

if ! $is_mac && $(has 'dircolors'); then
	eval `dircolors -b ~/.dir_colors`
fi

if [ "$nowon_on"x != 'x' ]; then
	# If function 'nowon' exist, call and unset it.
	if type nowon >/dev/null 2>&1; then
		nowon && unset nowon
	fi
fi

if [ ! -f $BIN/cdhist.sh ]; then
	function cd()
	{
		builtin cd "$@" && ls;
	}
fi

# Appearance. {{{1
#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').


# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

#  Note that a variable may require special treatment
#+ if it will be exported.

DARKGRAY='\e[1;30m'
LIGHTRED='\e[1;31m'
GREEN='\e[32m'
YELLOW='\e[1;33m'
LIGHTBLUE='\e[1;34m'

#  For "literal" command substitution to be assigned to a variable,
#+ use escapes and double quotes:
#+       PCT="\` ... \`" . . .
#  Otherwise, the value of PCT variable is assigned only once,
#+ when the variable is exported/read from .bash_profile,
#+ and it will not change afterwards even if the user ID changes.

PS_HOST="\[${Green}\]\h\[${NC}\]"
PS_USER="\[${Green}\]\u\[${NC}\]"
PS_WORK="\[${Yellow}\]\w\[${NC}\]"
PS_HIST="\[${Red}\](\!)\[${NC}\]"

if [ -n "${WINDOW}" ] ; then
	PS_SCREEN="\[${Cyan}\]#${WINDOW}\[${NC}\]"
else
	PS_SCREEN=""
fi

if [ -n "${TMUX}" ] ; then
	TMUX_WINDOW=$(tmux display -p '#I-#P')
	PS_SCREEN="\[${Cyan}\]#${TMUX_WINDOW}\[${NC}\]"
else
	PS_SCREEN=""
fi

if [ -n "${SSH_CLIENT}" ] ; then
	PS_SSH="\[${Cyan}\]/$(echo ${SSH_CLIENT} | sed 's/ [0-9]\+ [0-9]\+$//g')\[${NC}\]"
else
	PS_SSH=""
fi

PS1=
if $(has '__git_ps1'); then
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWUPSTREAM=auto
	PS_GIT="${Red}"'$(__git_ps1)'"${NC}"

	PS1+="${PS_USER}@${PS_HOST}:${PS_WORK}${PS_GIT}"
	PS1+='$ '
	#PS1+=">>> "$(show_exit $?)"\n${PS_GIT} "
else
	PS1+="[${PS_USER}${PS_ATODE}@${PS_HOST}${PS_SCREEN}${PS_SSH}:${PS_WORK}]\[\033[01;32m\]"
	PS1+='$(if git status &>/dev/null;then echo git[branch:$(git branch | cut -d" "  -f2-) change:$(git status -s |wc -l)];fi)\[\033[00m\]'
	PS1+='$ '
fi

#PCT="\`if [[ \$EUID -eq 0 ]]; then T='$LIGHTRED' ; else T='$LIGHTBLUE'; fi; 
#echo \$T \`"
#PS1+="\`if [[ \$EUID -eq 0 ]]; then PCT='$LIGHTRED';
#else PCT='${LIGHTBLUE}'; fi; 
#	echo '$GREEN[\w] \n$DARKGRAY('\$PCT'\t$DARKGRAY)-('\$PCT'\u$DARKGRAY)-('\$PCT'\h$DARKGRAY)$YELLOW-> $NC'\`"

export PS1;

# Options. {{{1
#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

#set -o nounset     # These  two options are useful for debugging.
#set -o xtrace
alias debug="set -o nounset; set -o xtrace"

ulimit -S -c 0      # Don't want coredumps.
set -o notify
set -o noclobber
set -o ignoreeof


# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

# Aliases. {{{1
#============================================================

alias vi="$EDITOR"
alias vim="$EDITOR"

# Git.
if $(has 'git'); then
	alias gst='git status'
fi

if $is_mac; then
	if $(has 'qlmanage'); then
		alias ql='qlmanage -p "$@" >& /dev/null'
	fi
fi

# function
alias cl="richpager"

# Common aliases
alias ..="cd .."
alias ld="ls -ld"          # Show info about the directory
alias lla="ls -lAF"        # Show hidden all files
alias ll="ls -lF"          # Show long file information
alias la="ls -AF"          # Show hidden files
alias lx="ls -lXB"         # Sort by extension
alias lk="ls -lSr"         # Sort by size, biggest last
alias lc="ls -ltcr"        # Sort by and show change time, most recent last
alias lu="ls -ltur"        # Sort by and show access time, most recent last
alias lt="ls -ltr"         # Sort by date, most recent last
alias lr="ls -lR"          # Recursive ls

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"

alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"
alias jobs="jobs -l"
alias temp="test -e ~/temporary && command cd ~/temporary || mkdir ~/temporary && cd ~/temporary"
alias untemp="command cd $HOME && rm ~/temporary && ls"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use if colordiff exists
if $(has 'colordiff'); then
	alias diff='colordiff -u'
else
	if [ -f ~/.bin/colordiff ]; then
		alias diff='~/.bin/colordiff -u'
	else
		alias diff='diff -u'
	fi
fi

if [ -f ~/.bin/saferm.sh ]; then
	alias rm='~/.bin/saferm.sh'
fi

# Use plain vim.
alias nvim='vim -N -u NONE -i NONE'

# The first word of each simple command, if unquoted, is checked to see 
# if it has an alias. [...] If the last character of the alias value is 
# a space or tab character, then the next command word following the 
# alias is also checked for alias expansion
alias sudo='sudo '

#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================
# Pretty-print of some PATH variables:

alias path='echo -e ${PATH//:/\\n}'

# Misc. {{{1
#=========================================================================
#  PROGRAMMABLE COMPLETION SECTION
#  Most are taken from the bash 2.05 documentation and from Ian McDonald's
# 'Bash completion' package (http://www.caliban.org/bash/#completion)
#  You will in fact need bash more recent then 3.0 for some features.
#
#  Note that most linux distributions now provide many completions
# 'out of the box' - however, you might need to make your own one day,
#  so I kept those here as examples.
#=========================================================================

if [ "${BASH_VERSION%.*}" \< "3.0" ]; then
    echo "You will need to upgrade to version 3.0 for full \
          programmable completion features"
    return
fi

shopt -s extglob        # Necessary.

complete -A hostname   rsh rcp telnet rlogin ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # Currently same as builtins.
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract


# Documents - Postscript,pdf,dvi.....
complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X \
'!*.+(dvi|DVI)' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.+(pdf|PDF)' acroread pdf2ps
complete -f -o default -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?\
(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
complete -f -o default -X \
'!*.+(doc|DOC|xls|XLS|ppt|PPT|sx?|SX?|csv|CSV|od?|OD?|ott|OTT)' soffice

# Multimedia
complete -f -o default -X \
'!*.+(gif|GIF|jp*g|JP*G|bmp|BMP|xpm|XPM|png|PNG)' xv gimp ee gqview
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123
complete -f -o default -X \
'!*.@(mp[23]|MP[23]|ogg|OGG|wav|WAV|pls|\
m3u|xm|mod|s[3t]m|it|mtm|ult|flac)' xmms
complete -f -o default -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|\
asf|vob|VOB|bin|dat|vcd|ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|\
QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX)' xine



complete -f -o default -X '!*.pl'  perl perl5


#  This is a 'universal' completion function - it works when commands have
#+ a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'
#  Needs the '-o' option of grep
#+ (try the commented-out version if not available).

#  First, remove '=' from completion word separators
#+ (this will allow completions like 'ls --color=auto' to work correctly).

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}


_get_longopts()
{
  #$1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
  #grep ^"$2" |sort -u ;
    $1 --help | grep -o -e "--[^[:space:].,]*" | grep -e "$2" |sort -u
}

_longopts()
{
    local cur
    cur=${COMP_WORDS[COMP_CWORD]}

    case "${cur:-*}" in
       -*)      ;;
        *)      return ;;
    esac

    case "$1" in
       \~*)     eval cmd="$1" ;;
         *)     cmd="$1" ;;
    esac
    COMPREPLY=( $(_get_longopts ${1} ${cur} ) )
}
complete  -o default -F _longopts configure bash
complete  -o default -F _longopts wget id info a2ps ls recode

_make()
{
    local mdef makef makef_dir="." makef_inc gcmd cur prev i;
    COMPREPLY=();
    cur=${COMP_WORDS[COMP_CWORD]};
    prev=${COMP_WORDS[COMP_CWORD-1]};
    case "$prev" in
        -*f)
            COMPREPLY=($(compgen -f $cur ));
            return 0
            ;;
    esac;
    case "$cur" in
        -*)
            COMPREPLY=($(_get_longopts $1 $cur ));
            return 0
            ;;
    esac;

    # ... make reads
    #          GNUmakefile,
    #     then makefile
    #     then Makefile ...
    if [ -f ${makef_dir}/GNUmakefile ]; then
        makef=${makef_dir}/GNUmakefile
    elif [ -f ${makef_dir}/makefile ]; then
        makef=${makef_dir}/makefile
    elif [ -f ${makef_dir}/Makefile ]; then
        makef=${makef_dir}/Makefile
    else
       makef=${makef_dir}/*.mk         # Local convention.
    fi


    #  Before we scan for targets, see if a Makefile name was
    #+ specified with -f.
    for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
        if [[ ${COMP_WORDS[i]} == -f ]]; then
            # eval for tilde expansion
            eval makef=${COMP_WORDS[i+1]}
            break
        fi
    done
    [ ! -f $makef ] && return 0

    # Deal with included Makefiles.
    makef_inc=$( grep -E '^-?include' $makef |
                 sed -e "s,^.* ,"$makef_dir"/," )
    for file in $makef_inc; do
        [ -f $file ] && makef="$makef $file"
    done


    #  If we have a partial word to complete, restrict completions
    #+ to matches of that word.
    if [ -n "$cur" ]; then gcmd='grep "^$cur"' ; else gcmd=cat ; fi

    COMPREPLY=( $( awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ \
                               {split($1,A,/ /);for(i in A)print A[i]}' \
                                $makef 2>/dev/null | eval $gcmd  ))

}

complete -F _make -X '+($*|*.[cho])' make gmake pmake

_killall()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}

    #  Get a list of processes
    #+ (the first sed evaluation
    #+ takes care of swapped out processes, the second
    #+ takes care of getting the basename of the process).
    COMPREPLY=( $( ps -u $USER -o comm  | \
        sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
        awk '{if ($0 ~ /^'$cur'/) print $0}' ))

    return 0
}

complete -F _killall killall killps

# settings for peco
_replace_by_history() {
  local l=$(HISTTIMEFORMAT= history | tac | sed -e 's/^\s*[0-9]*    \+\s\+//' | peco --query "$READLINE_LINE")
  READLINE_LINE="$l"
  READLINE_POINT=${#l}
}
peco-select-history() {
declare l=$(history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
READLINE_LINE="$l"
READLINE_POINT=${#l}
          }
bind -x '"\C-r": _replace_by_history'
bind    '"\C-xr": reverse-search-history'
          bind -x '"\C-r": peco-select-history'

# vim:fdm=marker fdc=3 ft=sh ts=2 sw=2 sts=2:
#}}}
