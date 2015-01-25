#!/bin/bash
# Display a fancy multi-select menu.
# Inspired by http://serverfault.com/a/298312

#trap 'read -p "$0($LINENO) $BASH_COMMAND"' DEBUG
trap 'e_header "\rCanceled"; exit' INT

function e_header()   { echo -e "\033[1m$*\033[0m"; }
#function e_header()   { echo -e "\n\033[1m$*\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }
function e_blank()    { echo -e " \033[1;34m \033[0m  $@"; }

#init_file=~/caches/init/selected
#mkdir -p ~/caches/init

# OS detection
#function is_osx() {
#  [[ "$OSTYPE" =~ ^darwin ]] || return 1
#}
#function is_ubuntu() {
#  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
#}
#function get_os() {
#  for os in osx ubuntu; do
#    is_$os; [[ $? == ${1:-0} ]] && echo $os
#  done
#}

function prompt_menu() {
  local exitcode prompt choices nums i n
  #exitcode=0
  #if [[ "$2" ]]; then
  #  _prompt_menu_draws "$1"
  #  read -t $2 -n 1 -sp "To edit this list, press any key within $2 seconds. "
  #  exitcode=$?
  #  echo ""
  #fi 1>&2
  #if [[ "$exitcode" == 0 ]]; then
  e_header "Run the following init scripts."
  if _prompt_menu_draws "To edit this list, press any key except ENTER. " -1 && read -n 1 -rp "Enter to Go> " && [[ -n "$REPLY" ]]; then
    prompt="Press number to toggle, r/R to reverse (Separate options with spaces): "
    while _prompt_menu_draws "$1" 1 && read -rp "$prompt" nums && [[ "$nums" != '' ]]; do
       # [[ "$nums" == 'q' ]] && break
      _prompt_menu_adds $nums
    done
fi
  #fi 1>&2
  _prompt_menu_adds
}

function _prompt_menu_iter() {
  local i sel state
  local fn=$1; shift
  for i in "${!menu_options[@]}"; do
    state=0
    for sel in "${menu_selects[@]}"; do
      [[ "$sel" == "${menu_options[i]}" ]] && state=1 && break
    done
    $fn $state $i "$@"
  done
}

function _prompt_menu_draws() {
  e_header "$1"
  #echo "Press number to toggle, press r or R to reverse"
  _prompt_menu_iter _prompt_menu_draw "$2"
}

function _prompt_menu_draw()
{
  local modes=(error success)
  if [[ "$3" ]]; then
      if [[ $3 == '-1' ]]; then
    #e_arrow "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
            e_arrow "$(printf "%2d) %s\n" $(($2+1)) $(basename ${menu_options[$2]/.sh/} | toupper))" | sed 's/_/ /g'
else
    #e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
    e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) $(basename ${menu_options[$2]/.sh/} | toupper))" | sed 's/_/ /g'
fi
  else
    #e_${modes[$1]} "${menu_options[$2]}"
    e_${modes[$1]} $(basename ${menu_options[$2]/.sh/} | toupper) | sed 's/_/ /g'
  fi
}

function _prompt_menu_adds() {
  _prompt_menu_result=()
  _prompt_menu_iter _prompt_menu_add "$@"
  menu_selects=("${_prompt_menu_result[@]}")
}

function _prompt_menu_add() {
  local state i n keep match
  state=$1; shift
  i=$1; shift
  for n in "$@"; do
    if [[ $1 =~ ^[rR]$ ]]; then match=1; [[ "$state" == 0 ]] && keep=1; fi
    #if [[ $1 == 'r' ]]; then match=1; [[ "$state" == 0 ]] && keep=1; continue; fi
    #if [[ $1 == 'x' ]]; then match=1; continue; fi
    if [[ $n =~ ^[0-9]+$ ]] && (( n-1 == i )); then
      match=1; [[ "$state" == 0 ]] && keep=1
    fi
  done
  [[ ! "$match" && "$state" == 1 || "$keep" ]] || return
  _prompt_menu_result=("${_prompt_menu_result[@]}" "${menu_options[i]}")
  #_prompt_menu_result=("${_prompt_menu_result[@]}" "${menu[i]}")
}

  toupper() { awk '{ print toupper(substr($0, 1, 1)) substr($0, 2, length($0) - 1) }'; }
  tolower() { awk '{ print tolower(substr($0, 1, 1)) substr($0, 2, length($0) - 1) }'; }
function init_files() {
#prompt_delay=12
  local i f t dirname oses os opt remove
  dirname="$(dirname "$1")"
  #f=("$@")
  f=()
  for t in "$@"
  do
      f+=($(DEBUG=1 bash "$t"))
  done

  menu_options=(); menu_selects=()
  #for i in "${!f[@]}"; do menu_options[i]="$(basename "${f[i]/.sh/}" |sed 's/_/ /g')"; done
  #for i in "${!f[@]}"; do menu_selects[i]="$(basename "${f[i]/.sh/}" |sed 's/_/ /g')"; done
  for i in "${!f[@]}"
  do
      #menu_selects[i]="$(basename "${f[i]/.sh/}" | sed 's/_/ /g' | toupper)"
      #menu_options[i]="$(basename "${f[i]/.sh/}" | sed 's/_/ /g' | toupper)"
      menu_selects[i]="${f[i]}"
      menu_options[i]="${f[i]}"
  done
  #if [[ -e "$init_file" ]]; then
  #  # Read cache file if possible
  #  IFS=$'\n' read -d '' -r -a menu_selects < "$init_file"
  #else
  #  # Otherwise default to all scripts not specifically for other OSes
  #  oses=($(get_os 1))
  #  for opt in "${menu_options[@]}"; do
  #    remove=
  #    for os in "${oses[@]}"; do
  #      [[ "$opt" =~ (^|[^a-z])$os($|[^a-z]) ]] && remove=1 && break
  #    done
  #    [[ "$remove" ]] || menu_selects=("${menu_selects[@]}" "$opt")
  #  done
  #fi
  prompt_menu "\rPress ENTER to run checked files" 12
  # Write out cache file for future reading.
  #rm "$init_file" 2>/dev/null
  for i in "${!menu_selects[@]}"; do
    #echo "$dirname/$(echo ${menu_selects[i]// /_}.sh | tolower)"
    echo ${menu_selects[i]}
  done
}
files=(./etc/init/{,osx/}*.sh)
init_files "${files[@]}"
