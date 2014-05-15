#-------------------------------------------------------------
# MY HISTORY
#-------------------------------------------------------------
HISTSIZE=50000
HISTFILESIZE=50000

export MYHISTFILE=$HOME/.bash_myhistory

function show_exit() {
	if [ "$1" -eq 0 ]; then return; fi
	echo -e "\007exit $1"
}

function log_history() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD ($1) $(history 1)" >> $MYHISTFILE
}

function prompt_cmd() {
	local s=$?
	show_exit $s;
	log_history $s;
}

function end_history() {
	log_history $?;
	echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (end)" >> $MYHISTFILE
}

echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (start)" >> $MYHISTFILE

trap end_history EXIT
#PROMPT_COMMAND=prompt_cmd
PROMPT_COMMAND="prompt_cmd;$PROMPT_COMMAND"
