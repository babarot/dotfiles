#-------------------------------------------------------------
# ABOUT PROMPTO
#-------------------------------------------------------------
export CR="$(echo -ne '\r')"
export LF="$(echo -ne '\n')"
export TAB="$(echo -ne '\t')"
export ESC="$(echo -ne '\033')"
export COLOUR_BLACK="${ESC}[30m"
export COLOUR_RED="${ESC}[31m"
export COLOUR_GREEN="${ESC}[32m"
export COLOUR_YELLOW="${ESC}[33m"
export COLOUR_BLUE="${ESC}[34m"
export COLOUR_CYAN="${ESC}[35m"
export COLOUR_MAGENTA="${ESC}[36m"
export COLOUR_WHITE="${ESC}[37m"
export COLOUR_HIGHLIGHT_BLACK="${ESC}[30;1m"
export COLOUR_HIGHLIGHT_RED="${ESC}[31;1m"
export COLOUR_HIGHLIGHT_GREEN="${ESC}[32;1m"
export COLOUR_HIGHLIGHT_YELLOW="${ESC}[33;1m"
export COLOUR_HIGHLIGHT_BLUE="${ESC}[34;1m"
export COLOUR_HIGHLIGHT_CYAN="${ESC}[35;1m"
export COLOUR_HIGHLIGHT_MAGENTA="${ESC}[36;1m"
export COLOUR_HIGHLIGHT_WHITE="${ESC}[37;1m"
export COLOUR_DEFAULT="${ESC}[m"

PS_USER="\[${COLOUR_BLUE}\]\u\[${COLOUR_DEFAULT}\]"
PS_WORK="\[${COLOUR_HIGHLIGHT_YELLOW}\]\w\[${COLOUR_DEFAULT}\]"
#PS_HIST="\[${COLOUR_HIGHLIGHT_RED}\]\!\[${COLOUR_DEFAULT}\]"
PS_HIST="\[${COLOUR_RED}\](\!)\[${COLOUR_DEFAULT}\]"

if [ -n "${PARTTY_SESSION}" ] ; then
	PS_HOST="\[${COLOUR_GREEN}\]${PARTTY_SESSION}!\[${COLOUR_DEFAULT}\]"
else
	PS_HOST="\[${COLOUR_GREEN}\]\h\[${COLOUR_DEFAULT}\]"
fi

if [ -n "${WINDOW}" ] ; then
	PS_SCREEN="\[${COLOUR_CYAN}\]#${WINDOW}\[${COLOUR_DEFAULT}\]"
else
	PS_SCREEN=""
fi

if [ -n "${SSH_CLIENT}" ] ; then
	PS_SSH="\[${COLOUR_MAGENTA}\]/$(echo ${SSH_CLIENT} | sed 's/ [0-9]\+ [0-9]\+$//g')\[${COLOUR_DEFAULT}\]"
else
	PS_SSH=""
fi
ATODE_FILE="${HOME}/.atode"

if [ -f "${ATODE_FILE}" ]; then
	PS_ATODE="\[${COLOUR_RED}\]:\$(cat ${ATODE_FILE} 2>/dev/null | wc -l)\[${COLOUR_DEFAULT}\]"
else
	PS_ATODE=""
fi

if [ -f $BASH_COMPLETION_DIR/git ]; then
#if [ ! -z "$(type -t __git_ps1)" ]; then
	export PS1="[${PS_USER}${PS_ATODE}@${PS_HOST}${PS_SCREEN}${PS_SSH} ${PS_HIST}:${PS_WORK}]\[\033[01;32m\]"'$(if git status &>/dev/null;then echo git[branch:$(git branch | cut -d" "  -f2-) change:$(git status -s |wc -l)];fi)\[\033[00m\]\$ '
else
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWUPSTREAM=auto
	export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[33m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
fi
