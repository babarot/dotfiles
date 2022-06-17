# Vim-like keybind as default
bindkey -v
# Vim-like escaping jj keybind
bindkey -M viins 'jj' vi-cmd-mode

# Add emacs-like keybind to viins mode
bindkey -M viins '^F'  forward-char
bindkey -M viins '^B'  backward-char
# bindkey -M viins '^P'  up-line-or-history
# bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^K'  kill-line
# bindkey -M viins '^R'  history-incremental-pattern-search-backward
# bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^Y'  yank
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^D'  delete-char-or-list

bindkey -M vicmd '^A'  beginning-of-line
bindkey -M vicmd '^E'  end-of-line
bindkey -M vicmd '^K'  kill-line
bindkey -M vicmd '^P'  up-line-or-history
bindkey -M vicmd '^N'  down-line-or-history
bindkey -M vicmd '^Y'  yank
bindkey -M vicmd '^W'  backward-kill-word
bindkey -M vicmd '^U'  backward-kill-line
bindkey -M vicmd '/'   vi-history-search-forward
bindkey -M vicmd '?'   vi-history-search-backward

bindkey -M vicmd 'gg' beginning-of-line
bindkey -M vicmd 'G'  end-of-line

# # if is-at-least 5.0.8; then
#     autoload -Uz surround
#     zle -N delete-surround surround
#     zle -N change-surround surround
#     zle -N add-surround surround
#     bindkey -a cs change-surround
#     bindkey -a ds delete-surround
#     bindkey -a ys add-surround
#     bindkey -a S add-surround
# # fi

if false; then
# bind P and N for EMACS mode
type 'history-substring-search-up' &>/dev/null &&
    bindkey -M emacs '^P' history-substring-search-up
type 'history-substring-search-down' &>/dev/null &&
    bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
type 'history-substring-search-up' &>/dev/null &&
    bindkey -M vicmd 'k' history-substring-search-up
type 'history-substring-search-down' &>/dev/null &&
    bindkey -M vicmd 'j' history-substring-search-down

# bind P and N keys
type 'history-substring-search-up' &>/dev/null &&
    bindkey '^P' history-substring-search-up
type 'history-substring-search-down' &>/dev/null &&
    bindkey '^N' history-substring-search-down
fi

# Insert a last word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word

# Surround a forward word by single quote
quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N quote-previous-word-in-single
bindkey -M viins '^Q' quote-previous-word-in-single

# Surround a forward word by double quote
quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N quote-previous-word-in-double
bindkey -M viins '^Xq' quote-previous-word-in-double

bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete

#bindkey -s 'vv' "!vi\n"
#bindkey -s ':q' "^A^Kexit\n"

#
# functions
#
_delete-char-or-list-expand() {
    if [ -z "$RBUFFER" ]; then
        zle list-expand
    else
        zle delete-char
    fi
}
zle -N _delete-char-or-list-expand
bindkey '^D' _delete-char-or-list-expand

# Ctrl-R
_peco-select-history() {
    if true; then
        BUFFER="$(
        history 1 \
            | sort -k1,1nr \
            | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' \
            | fzf --query "$LBUFFER"
        )"

        CURSOR=$#BUFFER
        #zle accept-line
        #zle clear-screen
        zle reset-prompt
    else
        if is-at-least 4.3.9; then
            zle -la history-incremental-pattern-search-backward && bindkey "^r" history-incremental-pattern-search-backward
        else
            history-incremental-search-backward
        fi
    fi
}
# zle -N _peco-select-history
# bindkey '^r' _peco-select-history

# is_git_repo returns true if cwd is in git repository
is_git_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
    return $status
}

do-enter() {
    if [[ -n $BUFFER ]]; then
        zle accept-line
        return $status
    fi

    : ${ls_done:=false}
    : ${git_ls_done:=false}

    if [[ $PWD != $GIT_OLDPWD ]]; then
        git_ls_done=false
    fi

    echo
    if is_git_repo; then
        if $git_ls_done; then
            if [[ -n $(git status --short) ]]; then
                git status
            fi
        else
            ${=aliases[ls]} && git_ls_done=true
            GIT_OLDPWD=$PWD
        fi
    else
        if [[ $PWD != $OLDPWD ]] && ! $ls_done; then
            ${=aliases[ls]} && ls_done=true
        fi
    fi

    zle reset-prompt
}
zle -N do-enter
bindkey '^m' do-enter

peco-select-gitadd() {
    local selected_file_to_add
    selected_file_to_add="$(
    git status --porcelain \
        | perl -pe 's/^( ?.{1,2} )(.*)$/\033[31m$1\033[m$2/' \
        | fzf --ansi --exit-0 \
        | awk -F ' ' '{print $NF}' \
        | tr "\n" " "
    )"

    if [ -n "$selected_file_to_add" ]; then
        BUFFER="git add $selected_file_to_add"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle reset-prompt
}
zle -N peco-select-gitadd
bindkey '^g^a' peco-select-gitadd

# expand global aliases by space
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
    # zle expand-word
  fi
  zle self-insert
}

# zle -N globalias
# bindkey " " globalias
