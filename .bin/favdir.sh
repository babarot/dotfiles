# Only shell script for bash and zsh
if [ ! "$BASH_VERSION" -a ! "$ZSH_VERSION" ]; then
  echo "Require bash or zsh"
  exit
fi

# Declare and initialize a variable
declare favdir="$HOME/.favdir"
declare favdir_list="$favdir/favdirlist"
declare favdir_log="$favdir/favdirlog"
declare favdir_temp="$favdir/favdirtemp"

# Usage {{{1
function _favdir_usage()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  local list
  local -i i width
  local -a commands

  width=$( stty 'size' <'/dev/tty' | cut -d' ' -f2 )
  commands=('show' 'regist' 'gg' 'print' 'delete')

  if [ $# -eq 0 ]; then
    echo -en "${commands[@]}\n\n"
    _favdir_usage "${commands[@]}" | ${PAGER:-less}
    return 0
  fi

  for list in "$@"
  do
    echo -en 'Usage: '
    case "$list" in
      'show')
        echo -en "show [OPTION]\n"
        echo -en "  Display all registered names and paths.\n"
        echo -en "  Need to run independently for all options.\n\n"
        echo -en "Options:\n"
        echo -en "  -h, --help     display this help and exit\n"
        echo -en "  -e, --edit     edit list\n"
        echo -en "  -p, --plane    to output the bookmark list without a color\n"
        echo -en "  -R, --refresh  to update all the paths that are not valid\n\n"
        shift
        ;;
      'regist')
        echo -en "reg [OPTION] [name]\n"
        echo -en "  If there is arguments, save the argument as a registered name.\n"
        echo -en "  Otherwise, save current directory name.\n\n"
        echo -en "Options:\n"
        echo -en "  -h, --help     display this help and exit\n"
        echo -en "  -t, --temp     save paths as a disposable\n\n"
        shift
        ;;
      'gg')
        echo -en "gg name\n"
        echo -en "  Go to the registered path just like jumping\n\n"
        echo -en "Options:\n"
        echo -en "  -h, --help     display this help and exit\n\n"
        shift
        ;;
      'print')
        echo -en "p name\n"
        echo -en "  Output the registered name and path.\n\n"
        echo -en "Options:\n"
        echo -en "  -h, --help     display this help and exit\n\n"
        shift
        ;;
      'delete')
        echo -en "del name\n"
        echo -en "  Delete the registered name and path.\n\n"
        echo -en "Options:\n"
        echo -en "  -h, --help     display this help and exit\n\n"
        shift
        ;;
    esac
    [ $# -ne 0 ] && for (( i=0; i<$width; i++ )); do
    echo -en '_'
  done && echo -en "\n\n"
done

  return 0
}

# initialize {{{1
function _favdir_initialize()
{
  # Check for $favdir
  if [ -d "$favdir" ]; then
    return 1
  fi

  mkdir -p "$favdir"
  touch "$favdir_list" "$favdir_log" "$favdir_temp"

  return 0
}

#----------------------#
# favdir MAIN commands #
#----------------------#

#(1/5): show {{{1
function _favdir_show()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  # show help about show function
  [ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'show'; return 0; }
  # if listfile does not exist, output error message and exit
  [ -f $favdir_list ] || { echo "$(basename $bookmarklist): no exist"; return 1; }

  local opt
  local -i i 
  local -a param fname fpath

  for opt do
    case "$opt" in
      '-h'|'--help' )
        _favdir_usage 'show'
        return 0
        ;;
      '-e'|'--edit' )
        ${EDITOR:-vi} $favdir_list
        shift 1
        return 0
        ;;
      '-p'|'--plane' )
        cat $favdir_list | sed "s $HOME ~ g"
        shift 1
        return 0
        ;;
      '-R'|'--refresh' )
        if _favdir_show_refresh; then
          return 0
        else
          return 1
        fi
        ;;
      '--' )
        shift 1
        param+=( "$@" )
        break
        ;;
      -*)
        echo "show: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
        return 1
        ;;
      *)
        if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
          param+=( "$1" )
          shift 1
        fi
        ;;
    esac
  done

  [ ! -f "$favdir_list" ] && touch "$favdir_list"
  [ ! -f "$favdir_log" ]  && touch "$favdir_log"
  [ ! -f "$favdir_temp" ] && touch "$favdir_temp"

  fname=( `awk '{print $1}' "$favdir_list"` )
  fpath=( `awk '{print $2}' "$favdir_list"` )

  for (( i=0; i<${#fname[*]}; i++ )); do
    if grep -w "${fname[i]}" "$favdir_log" >/dev/null; then
      printf "\033[31m%-15s\033[m%s\n" "${fname[i]}" "${fpath[i]}"

    else
      printf "\033[33m%-15s\033[m%s\n" "${fname[i]}" "${fpath[i]}"
    fi
  done | sed "s $HOME ~ g"
}

#(2/5): regist {{{1
function _favdir_regist()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  # show help about regist function
  [ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'regist'; return 0; }
  # if listfile does not exist, create it
  [ -f "$favdir_list" ] || touch "$favdir_list"

  local opt option_t fname
  local -i limit i
  local -a param

  for opt do
    case "$opt" in
      '-h'|'--help' )
        _favdir_usage 'regist'
        return 0
        ;;
      '--' )
        shift 1
        param+=( "$@" )
        break
        ;;
      -*)
        echo "reg: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
        return 1
        ;;
    esac
  done

  limit=$(( $( stty 'size' <'/dev/tty' | cut -d' ' -f1 ) - 2 ))
  if [ $( wc -l <"$favdir_list" ) -ge "$limit" ]; then
    echo "The maximum number that can enroll in a bookmark list is $limit cases."
    return 1
  fi

  [ $# -eq 0 ] && fname=${PWD##*/} || fname="$1"
  if [ ${#fname} -gt 14 ]; then
    echo "Please input 14 characters or less."
    return 1
  fi

  if awk '{print $1}' "$favdir_list" | grep -w "$fname" >/dev/null; then
    echo "$fname: Already exist"
    return 1
  else
    [ "$option_t" ] && printf "%-15s%s\n" $fname "$PWD" >>$favdir_temp
    printf "%-15s%s\n" $fname "$PWD" >>$favdir_list
    return 0
  fi
}

#(3/5): gg {{{1
function _favdir_gg()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  # show gg about gg function
  [ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'gg'; return 0; }
  # if listfile does not exist, output error message and exit
  [ -f $favdir_list ] || { echo "$(basename $bookmarklist): no exist"; return 1; }

  local fname fpath

  fname=$( awk '{print $1}' $favdir_list | command grep -w -E "^$1$" )
  fpath=$( awk '$1 ~ /'"^$1"'$/' $favdir_list | awk '{print $2}' )

  if [ $# -eq 0 ]; then
    echo "gg: too few arguments"
    echo "Try 'gg --help' for more information."
    return 1
  else
    # case of unregistered
    if [ -z "$fname" ]; then
      echo "$1: No such path in $(basename $favdir_list)"
      return 1
      # case of registered
    else
      if cd "$fpath" 2>/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S')  $1  $fpath" >>$favdir_log
        # case of -t option
        if [ -f $favdir_temp ]; then
          if awk '{print $2}' $favdir_temp | grep -x $fpath >/dev/null; then
            _favdir_delete $fname
            sed -i '' "/^$1$/d" $favdir_temp
          fi
        fi
        return 0
      else
        # case of not existing
        echo "$fpath: an invalid pass"
        _favdir_delete "$fname"
        echo "$fname: deleted, now"
        return 1
      fi
    fi
  fi
  unset fname fpath
}

#(4/5): delete {{{1
function _favdir_delete()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  # show help about delete function
  [ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'delete'; return 0; }
  # if listfile does not exist, output error message and exit
  [ -f $favdir_list ] || { echo "$(basename $bookmarklist): no exist"; return 1; }

  [ "$1" = "-R" ] || [ "$1" = "--refresh" ] && { _favdir_show_refresh; return 0; }

  [ -s $favdir_list ] || { echo "$(basename $favdir_list) is empty."; return 1; }
  [ $# -eq 0 ] && {
  echo "del: too few arguments"
  echo "Try 'del --help' for more information."
  return 1
}

local    f
#local -i i
local -a fname
local -a fpath

#for f do
# fname=( $( awk '{print $1}' $favdir_list | command grep -ivw -E "^$f" ) )
# fpath=( $( command grep -ivw -E "^$f" $favdir_list | awk '{print $2}' ) )

# if awk '{print $1}' $favdir_list | command grep -w -E "^$f" >/dev/null; then
#   # (main) delete from list
#   for (( i=0; i<${#fname[*]}; i++ )); do
#     printf "%-15s%s\n" ${fname[i]} ${fpath[i]}
#   done >$favdir_list

#   # delete the history
#   sed -i '' "/"$'\t'"$f$/d" $favdir_log 2>/dev/null

#   # case of using -t option
#   if [ -f $favdir_temp ]; then
#     if awk '{print $1}' $favdir_temp | grep -w "$f" >/dev/null; then
#       sed -i '' "/^$f/d" $favdir_temp
#     fi
#   fi
# else
#   echo "$1: No such path in $(basename $favdir_list)"
#   return 1
# fi
# unset f i fname fpath
#done
#IFS=$'\n'
tmp=$(cat "${favdir_list}")

local i
for i in "$@"
do
  tmp=$(echo "${tmp}" | awk '$1 !~ /^'"$i"'$/')
done

#unset noclobber
echo "${tmp}" >|$favdir_list
}

#(5/5): print {{{1
function _favdir_print()
{
  # Fix array index for ZSH
  if [ "$ZSH_NAME" = "zsh" ];then
    setopt localoptions ksharrays
  fi

  # show go about print function
  [ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'print'; return 0; }
  # if listfile does not exist, output error message and exit
  [ -f $favdir_list ] || { echo "$(basename $bookmarklist): no exist"; return 1; }

  local fname
  fname=$( awk '{print $1}' $favdir_list | command grep -w -E "^$1$" )
  local fpath
  fpath=$( awk '$1 ~ /'"^$1"'$/' $favdir_list | awk '{print $2}' )

  if [ $# -eq 0 ]; then
    echo "p: too few arguments"
    echo "Try 'p --help' for more information."
    return 1
  else
    if [ -z "$fname" ]; then
      echo "$1: No such path in $(basename $favdir_list)"
      return 1
    else
      if ( cd "$fpath" >/dev/null 2>&1 ); then
        echo "$fpath"
        return 0
      else
        echo "$fpath: an invalid pass"
        _favdir_delete "$fname"
        echo "$fname: deleted"
        return 1
      fi
    fi
  fi
  unset fname fpath
}

#----------------------#
# favdir SUB functions #
#----------------------#

# refresh {{{1
function _favdir_show_refresh()
{
  local -i i=
  local -i count=
  local -a fname
  fname=( $( awk '{print $1}' $favdir_list ) )
  local -a fpath
  fpath=( $( awk '{print $2}' $favdir_list ) )
  local line
  line=$( wc -l <$favdir_list )
  local -a str

  command cp -f $favdir_list ${favdir_list}.bak
  for (( i=0; i<$line; i++ )); do
    if [ -d "${fpath[i]}" ]; then
      let count++
    else
      _favdir_delete "${fname[i]}"
      str=("${str[@]}" "${fname[i]}")
    fi
  done

  if [ $count -eq $line ]; then
    #echo "All paths are available."
    return 1
  else
    echo "Removed ${#str[*]} items that do not exist"
    command diff -u ${favdir_list}.bak $favdir_list
    return 0
  fi

  unset i count fname fpath line str
}

# complement {{{1
function _favdir_complement()
{
  if [ "$BASH_VERSION" ]; then
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $( compgen -W "`echo $( awk '{print $1}' $favdir_list )`" -- $curw ) )
  elif [ "$ZSH_VERSION" ]; then
    local -a all
    all=(`awk '{print $1}' $favdir_list`)
    _describe -t others "Favdir" all
  fi
  return 0
}

# Establishment {{{1
if [ -d "$favdir" ]; then
  unset _favdir_initialize
else
  _favdir_initialize
fi

alias favdir='_favdir_usage'
alias show='_favdir_show'
alias reg='_favdir_regist'
alias gg='_favdir_gg'
alias del='_favdir_delete'
alias p='_favdir_print'

if [ -n "$BASH_VERSION" ]; then
  complete -F _favdir_complement gg
  complete -F _favdir_complement del
  complete -F _favdir_complement p
fi

if [ -n "$ZSH_VERSION" ]; then
  #autoload -U compinit
  #compinit -u
  autoload -Uz compinit
  compinit
  compdef _favdir_complement _favdir_gg
  compdef _favdir_complement _favdir_delete
  compdef _favdir_complement _favdir_print
fi

# vim:fdm=marker expandtab fdc=3 ts=2 sw=2 sts=2:
