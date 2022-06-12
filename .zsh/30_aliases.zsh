# Common aliases
alias ..='cd ..'

# alias ll="ls -l"
# alias ld='ls -ld'          # Show info about the directory
# alias lla='ls -lAF'        # Show hidden all files
# alias ll='ls -lF'          # Show long file information
# alias la='ls -AF'          # Show hidden files
# alias lx='ls -lXB'         # Sort by extension
# alias lk='ls -lSr'         # Sort by size, biggest last
# alias lc='ls -ltcr'        # Sort by and show change time, most recent last
# alias lu='ls -ltur'        # Sort by and show access time, most recent last
# alias lt='ls -ltr'         # Sort by date, most recent last
# alias lr='ls -lR'          # Recursive ls

alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

autoload -Uz zmv
alias zmv='noglob zmv -W'

alias du='du -h'
alias job='jobs -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# alias vi="vim"

# Use plain vim.
# alias nvim='vim -N -u NONE -i NONE'

if (( $+commands[kubectl] )); then
    alias k=kubectl
fi

# Global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g X='| xargs'
alias -g N=" >/dev/null 2>&1"
alias -g N1=" >/dev/null"
alias -g N2=" 2>/dev/null"
alias -g VI='| xargs -o vim'
alias -g CSV="| sed 's/,,/, ,/g;s/,,/, ,/g' | column -s, -t"

(( $+galiases[H] )) || alias -g H='| head'
(( $+galiases[T] )) || alias -g T='| tail'

(( $+commands[emojify] )) && alias -g E='| emojify'

if (( $+commands[jq] )); then
    alias -g J='| jq -C . | less -F'
    alias -g JQ='| jq -C .'
    alias -g JL='| jq -C . | less -R -X'
fi

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

alias -g P='$(kubectl get pods | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk "{print \$1}")'
alias -g F='| fzf --height 30 --reverse --multi --cycle'

function _gcloud_change_project() {
    local proj=$(gcloud projects list | fzf --height 50% --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $proj ]]; then
        gcloud config set project $proj
        return $?
    fi
}
alias gcp=_gcloud_change_project

alias yy="fc -ln -1 | tr -d '\n' | pbcopy"

if (( $+commands[iap_curl] )); then
    alias iap='iap_curl $(iap_curl --list | fzf --height 30% --reverse)'
fi

gchange() {
    if ! type gcloud &>/dev/null; then
        echo "gcloud not found" >&2
        return 1
    fi
    gcloud config configurations activate $(gcloud config configurations list | fzf-tmux --reverse --header-lines=1 | awk '{print $1}')
}

review() {
    git diff --name-only origin/master... \
        | fzf \
        --ansi \
        --multi \
        --reverse \
        --height 70% \
        --preview-window down:70% \
        --preview="if [[ -f {} ]]; then git diff --color=always origin/master... {}; fi" \
        --bind "enter:execute-silent(vim {} </dev/tty >/dev/tty)"
}
