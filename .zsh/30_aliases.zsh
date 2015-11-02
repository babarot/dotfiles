# Check whether the vital file is loaded
if ! vitalize 2>/dev/null; then
    echo "cannot run as shell script" 1>&2
    return 1
fi

# For mac, aliases
if is_osx; then
    has "qlmanage" && alias ql='qlmanage -p "$@" >&/dev/null'
fi

if has 'git'; then
    alias gst='git status'
fi

if has 'richpager'; then
    alias cl='richpager'
fi

# Common aliases
alias ..='cd ..'
alias ld='ls -ld'          # Show info about the directory
alias lla='ls -lAF'        # Show hidden all files
alias ll='ls -lF'          # Show long file information
alias l='ls -1F'           # Show long file information
alias la='ls -AF'          # Show hidden files
alias lx='ls -lXB'         # Sort by extension
alias lk='ls -lSr'         # Sort by size, biggest last
alias lc='ls -ltcr'        # Sort by and show change time, most recent last
alias lu='ls -ltur'        # Sort by and show access time, most recent last
alias lt='ls -ltr'         # Sort by date, most recent last
alias lr='ls -lR'          # Recursive ls

# The ubiquitous 'll': directories first, with alphanumeric sorting:
#alias ll='ls -lv --group-directories-first'

alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

#autoload -Uz zmv
alias zmv='noglob zmv -W'

alias du='du -h'
alias job='jobs -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use if colordiff exists
if has 'colordiff'; then
    alias diff='colordiff -u'
else
    alias diff='diff -u'
fi

alias vi="vim"

# Use plain vim.
alias nvim='vim -N -u NONE -i NONE'

# The first word of each simple command, if unquoted, is checked to see 
# if it has an alias. [...] If the last character of the alias value is 
# a space or tab character, then the next command word following the 
# alias is also checked for alias expansion
alias sudo='sudo '

# Global aliases
alias -g G='| grep'

#less_alias() {
#    local stdin
#    stdin="$(cat <&0)"
#    if [[ -n $stdin ]]; then
#        if [[ -f $stdin ]]; then
#            less $stdin
#        else
#            echo "$stdin" | less
#        fi
#    fi
#}
##alias -g L='| cat_alias | less'
#alias -g L='| less_alias'

alias -g W='| wc'
alias -g X='| xargs'
alias -g F='| "$(available $INTERACTIVE_FILTER)"'

(( $+galiases[H] )) || alias -g H='| head'
(( $+galiases[T] )) || alias -g T='| tail'

if has "emojify"; then
    alias -g E='| emojify'
fi

if is_osx; then
    alias -g CP='| pbcopy'
    alias -g CC='| tee /dev/tty | pbcopy'
fi

#cat_alias() {
#    local stdin
#    stdin="$(cat <&0)"
#    if [[ -n $stdin ]]; then
#        if [[ -f $stdin ]]; then
#            cat $stdin
#        else
#            echo "$stdin" | cat
#        fi
#    fi
#}
#alias -g C="| cat_alias"

#cat_all_alias() {
#    local i
#    for i in $(cat <&0)
#    do
#        if [[ -n $i ]]; then
#            if [[ -f $i ]]; then
#                cat $i
#            else
#                echo "$i" | cat
#            fi
#        fi
#    done
#}
#alias -g CA="| cat_all_alias"
#alias -g C="| cat_all_alias"

cat_alias() {
    local i stdin file=0
    stdin=("${(@f)$(cat <&0)}")
    for i in "${stdin[@]}"
    do
        if [[ -f $i ]]; then
            cat "$@" "$i"
            file=1
        fi
    done
    if [[ $file -eq 0 ]]; then
        echo "${(F)stdin}"
    fi
}
alias -g C="| cat_alias"

pygmentize_alias() {
    has "pygmentize" || return

    local get_styles styles style
    get_styles="from pygments.styles import get_all_styles
    styles = list(get_all_styles())
    print('\n'.join(styles))"
    styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )

    style=${${(M)styles:#solarized}:-default}

    #local i stdin file=0
    #stdin=("${(@f)$(cat <&0)}")
    #for i in "${stdin[@]}"
    #do
    #    if [[ -f $i ]]; then
    #        pygmentize -O style="$style" "$i"
    #        file=1
    #    fi
    #done
    #[[ $file -eq 0 ]] && echo "${(F)stdin}" | pygmentize -O style="$style"
    cat_alias "$@" | pygmentize -O style="$style"
}
alias -g P="| pygmentize_alias"
alias -g L="| cat_alias | less"

awk_alias() {
    if (( ${ZSH_VERSION%%.*} < 5 )); then
        #local one
        #one="$1"
        #shift
        #cat_alias | awk "$@" '{print $'"${one:-0}"'}'
        return
    fi

    local f=0 opt=
    if [[ $# -gt 0 && ${@[-1]} =~ ^[0-9]+$ ]]; then
        f=${@[-1]}
        opt=${@:1:-1}
    fi
    awk $opt '{print $'"$f"'}'
}
alias -g A="| awk_alias"

alias -g S="| sort"
alias -g V="| tovim"

alias -g N=" >/dev/null 2>&1"
alias -g N1=" >/dev/null"
alias -g N2=" 2>/dev/null"

vim_mru_files() {
    local -a f
    f=(
    ~/.unite/file_mru(N)
    ~/.vim_mru_files(N)
    ~/.cache/ctrlp/mru/cache.txt(N)
    ~/.frill(N)
    )
    if [[ $#f -eq 0 ]]; then
        echo "There is no available MRU Vim plugins" >&2
        return 1
    fi

    local cmd q k res
    while cmd="$(
        cat <$f \
            | sed -e '/^#/d;/^$/d' \
            | perl -pe 's/^(\/.*\/)(.*)$/\033[34m$1\033[m$2/' \
            | fzf --ansi --multi --no-sort --query="$q" \
            --print-query --expect=ctrl-v --exit-0 --prompt="MRU> "
            )"; do
        q="$(head -1 <<< "$cmd")"
        k="$(head -2 <<< "$cmd" | tail -1)"
        res="$(sed '1,2d;/^$/d' <<< "$cmd")"
        [ -z "$res" ] && continue
        if [ "$k" = "ctrl-v" ]; then
            vim "$res" < /dev/tty > /dev/tty
        else
            echo "$res"
            break
        fi
    done
}
alias -g mru='$(vim_mru_files)'
