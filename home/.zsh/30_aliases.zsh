autoload -Uz zmv zcalc
alias zmv='noglob zmv -W'

alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
alias mkdir='nocorrect mkdir'

alias du='du -h'
alias job='jobs -l'
alias grep='grep --color=auto'

# Global aliases
alias -g G='| grep'
alias -g X='| xargs'
alias -g N=" >/dev/null 2>&1"
alias -g N1=" >/dev/null"
alias -g N2=" 2>/dev/null"
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

# List global aliases
alias galias='alias -g'
alias yy="fc -ln -1 | tr -d '\n' | pbcopy"

alias -g ESC='| sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
