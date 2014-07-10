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

PS_HOST="\[${COLOUR_GREEN}\]\h\[${COLOUR_DEFAULT}\]"
PS_USER="\[${COLOUR_GREEN}\]\u\[${COLOUR_DEFAULT}\]"
PS_WORK="\[${COLOUR_HIGHLIGHT_YELLOW}\]\w\[${COLOUR_DEFAULT}\]"
PS_HIST="\[${COLOUR_RED}\](\!)\[${COLOUR_DEFAULT}\]"

if [ -n "${WINDOW}" ] ; then
	PS_SCREEN="\[${COLOUR_CYAN}\]#${WINDOW}\[${COLOUR_DEFAULT}\]"
else
	PS_SCREEN=""
fi

if [ -n "${TMUX}" ] ; then
    TMUX_WINDOW=$(tmux display -p '#I-#P')
	PS_SCREEN="\[${COLOUR_CYAN}\]#${TMUX_WINDOW}\[${COLOUR_DEFAULT}\]"
else
	PS_SCREEN=""
fi

if [ -n "${SSH_CLIENT}" ] ; then
	PS_SSH="\[${COLOUR_MAGENTA}\]/$(echo ${SSH_CLIENT} | sed 's/ [0-9]\+ [0-9]\+$//g')\[${COLOUR_DEFAULT}\]"
else
	PS_SSH=""
fi

PS1=
if type __git_ps1 >/dev/null 2>&1; then
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWUPSTREAM=auto
	PS_GIT="${COLOUR_RED}"'$(__git_ps1)'"${COLOUR_DEFAULT}"

	PS1+="${PS_USER}@${PS_HOST}:${PS_WORK}${PS_GIT}"
	PS1+='$ '
else
	PS1+="[${PS_USER}${PS_ATODE}@${PS_HOST}${PS_SCREEN}${PS_SSH}:${PS_WORK}]\[\033[01;32m\]"
	PS1+='$(if git status &>/dev/null;then echo git[branch:$(git branch | cut -d" "  -f2-) change:$(git status -s |wc -l)];fi)\[\033[00m\]'
	PS1+='$ '
fi
export PS1;
