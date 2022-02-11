_TAB_="$(printf "\t")"
_SPACE_=' '
_BLANK_="${_SPACE_}${_TAB_}"
_IFS_="$IFS"

is_interactive() {
  if [ "${-/i/}" != "$-" ]; then
    return 0
  fi
  return 1
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
    return 0  # $substring is in $string
  else
    return 1  # $substring is not in $string
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
    echo "too few arguments" >&2
    return 1
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
