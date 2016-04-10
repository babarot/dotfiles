#!/bin/bash
set -e

USAGE="Usage: dynamic-colors [help|cycle|init|list|switch <colorscheme>]"
HELP="\
dynamic-colors <command>

Basic commands:
  h,help                  print this help message
  c,cycle                 cycle through color schemes
  e,edit [<colorscheme>]  edit <colorscheme> when given or launch editor
                          in colorschemes directory otherwise
  i,init                  (re)load last color scheme
  l,list                  list available colorschemes
  s,switch <colorscheme>  change terminal colors to <colorscheme>

Creating colorschemes:
  a,audit <colorscheme>   check <colorscheme> for undefined colors
  c,create <colorscheme>  create a new colorscheme from scratch
"

die () {
  echo >&2 "$*"
  exit 1
}

change_color () {
  case $1 in
  color*)
    send_osc 4 "${1#color};$2" ;;
  foreground)
    send_osc 10 "$2" ;;
  background)
    send_osc 11 "$2" ;;
  cursor)
    send_osc 12 "$2" ;;
  mouse_foreground)
    send_osc 13 "$2" ;;
  mouse_background)
    send_osc 14 "$2" ;;
  highlight)
    send_osc 17 "$2" ;;
  border)
    send_osc 708 "$2" ;;
  esac
}

send_escape_sequence () {
  escape_sequence="$1"

  # wrap escape sequence when within a TMUX session
  [ ! -z "$TMUX" ] && escape_sequence="${DSC}tmux;${ESC}${escape_sequence}${ESC}\\"

  printf "${escape_sequence}"
}

send_osc () {
  Ps=$1
  Pt=$2
  command="$OSC$Ps;$Pt$BEL"
  send_escape_sequence $command
}

ESC="\033"
BEL="\007"
DSC="${ESC}P"
OSC="${ESC}]"

colors=( background foreground cursor mouse_background mouse_foreground highlight border color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15 )
color_names=( black red green yellow blue magenta cyan white brblack brred brgreen bryellow brblue brmagenta brcyan brwhite )

if [ -z "${DYNAMIC_COLORS_ROOT}" ]; then
  DYNAMIC_COLORS_ROOT="${HOME}"
else
  DYNAMIC_COLORS_ROOT="${DYNAMIC_COLORS_ROOT%/}"
fi
COLORSCHEMES="${DYNAMIC_COLORS_ROOT}/.colorschemes"

write_colorscheme_name () {
  echo "$1" > "${DYNAMIC_COLORS_ROOT}/colorscheme"
}

load_colorscheme_name () {
  head -1 "${DYNAMIC_COLORS_ROOT}/colorscheme"
}

init () {
  [ ! -f "${DYNAMIC_COLORS_ROOT}/colorscheme" ] && return
  colorscheme_name=$(load_colorscheme_name)
  load_colorscheme "$colorscheme_name"
  set_colors
}

unset_colors () {
  for color in ${colors[@]}; do
    unset ${!color}
  done
}

set_colors () {
  for color in ${colors[@]}; do
    [[ ${!color} ]] && change_color "$color" "${!color}"
  done
}

load_colorscheme () {
  [ ! -f "$COLORSCHEMES/$1.sh" ] && die "error: unknown colorscheme '$1'"
  . "$COLORSCHEMES/$1.sh" # source colorscheme file
}

switch () {
  write_colorscheme_name "$1"
  load_colorscheme "$1"
  set_colors
}

audit () {
  unset_colors
  load_colorscheme "$1"
  declare -a problems
  for color in ${colors[@]}; do
    if [ ! ${!color} ]; then
      problems=( "${problems[@]}" "\033[4m$color\033[0m is not defined" )
    fi
  done
  if [ ${#problems[@]} -ne 0 ]; then
    echo >&2 "$1:"
    for p in "${problems[@]}"
    do
      echo >&2 " * $p"
    done
    exit 1
  fi
}

cycle() {
    if [ -f "${DYNAMIC_COLORS_ROOT}/colorscheme" ]; then
        current=`head -1 "${DYNAMIC_COLORS_ROOT}/colorscheme"`
        found=false
        cd "$COLORSCHEMES"
        for file in *.sh; do
            if [ $found = true ]; then
                switch "${file%.sh}"
                return
            fi
            if [ $file = "${current}.sh" ]; then
                found=true
            fi
        done
    fi

    cd "$COLORSCHEMES"
    for file in *.sh; do
        switch "${file%.sh}"
        break
    done
}

list () {
  [ ! -d "$COLORSCHEMES" ] && die "error: colorschemes directory '$COLORSCHEMES' doesn't exist"
  cd "$COLORSCHEMES"
  for file in *.sh; do
    echo "${file%.sh}"
  done
}

edit () {
  cd "$COLORSCHEMES"
  if [ ${#@} -eq 0 ]; then
    ${EDITOR:-/usr/bin/vim} .
  else
    ${EDITOR:-/usr/bin/vim} "${@/%/.sh}"
  fi
}

create () {
  [ -f "$COLORSCHEMES/$1.sh" ] && die "error: colorscheme '$1' already exists"
  output="# $1\n"
  for color in ${colors[@]}; do
    output+="\n$color=\"\""
    [[ $color == color* ]] && output+=" # ${color_names[${color#color}]}"
  done
  cd "$COLORSCHEMES"
  echo -e "$output" >> "$1.sh"
  edit "$1"
}

usage () {
  die "$USAGE"
}

help () {
  echo "$HELP"
}

case "$#" in
0)
  usage ;;
*)
  cmd="$1"
  shift
  case "$cmd" in
  h|help)
    help ;;
  a|audit)
    audit "$1" ;;
  c|create)
    [ $# -ne 1 ] && usage
    create "$1" ;;
  e|edit)
    edit "$@" ;;
  i|init)
    init ;;
  l|list)
    list ;;
  s|switch)
    [ $# -ne 1 ] && usage
    switch "$1" ;;
  c|cycle)
    cycle ;;
  *)
    usage ;;
  esac
esac
