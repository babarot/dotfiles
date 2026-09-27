autoload -Uz zmv
alias zmv='noglob zmv -W'

alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

alias du='du -h'
alias job='jobs -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use plain vim.
alias suvim='vim -N -u NONE -i NONE'

# Global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g X='| xargs'
alias -g N=" >/dev/null 2>&1"
alias -g N1=" >/dev/null"
alias -g N2=" 2>/dev/null"
alias -g VI='| xargs -o vim'
alias -g CSV="| sed 's/,,/, ,/g;s/,,/, ,/g' | column -s, -t"
alias -g H='| head'
alias -g T='| tail'
alias -g W='| wc -l'

alias -g CP='| pbcopy'
alias -g CC='| tee /dev/tty | pbcopy'

awk_alias2() {
  local -a options fields words
  while (( $#argv > 0 ))
  do
    case "$1" in
      -*)
        options+=("$1")
        ;;
      <->)
        fields+=("$1")
        ;;
      *)
        words+=("$1")
        ;;
    esac
    shift
  done
  if (( $#fields > 0 )) && (( $#words > 0 )); then
    awk '$'$fields[1]' ~ '${(qqq)words[1]}''
  elif (( $#fields > 0 )) && (( $#words == 0 )); then
    awk '{print $'$fields[1]'}'
  fi
}
alias -g A="| awk_alias2"

# list galias
alias galias="alias | command grep -E '^[A-Z]'"
alias yy="fc -ln -1 | tr -d '\n' | pbcopy"

alias -g ESC='| sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias -g ANSI='| sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
