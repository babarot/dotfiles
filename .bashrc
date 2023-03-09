# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return
[[ -n "$VIMRUNTIME" ]] && return

export PATH="$HOME/bin:/usr/local/bin:$PATH"
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

export PROMPT_DIRTRIM=3
export MYHISTFILE=~/.bash_myhistory
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000
export HISTFILESIZE=50000
export LANG=en_US.UTF-8

show_exit() {
  if [[ "$1" -eq 0 ]]; then
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
  echo -e  "Bye!"
  echo -en "\033[m"
}
trap _exit EXIT

{
  shopt -s dotglob
  shopt -s extglob
  shopt -s cdspell
  shopt -s globstar
  shopt -s autocd
  shopt -s dirspell
} &>/dev/null
. "$HOME/.cargo/env"
