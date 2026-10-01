# Vim-like keybind as default
bindkey -v
# Vim-like escaping jj keybind
bindkey -M viins 'jj' vi-cmd-mode

# Add emacs-like keybind to both vi modes
for m in viins vicmd; do
  bindkey -M $m '^A'  beginning-of-line
  bindkey -M $m '^E'  end-of-line
  bindkey -M $m '^K'  kill-line
  bindkey -M $m '^P'  up-line-or-history
  bindkey -M $m '^N'  down-line-or-history
  bindkey -M $m '^Y'  yank
  bindkey -M $m '^W'  backward-kill-word
  bindkey -M $m '^U'  backward-kill-line
done
unset m
bindkey -M viins '^F'  forward-char
bindkey -M viins '^B'  backward-char
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^?'  backward-delete-char

bindkey -M vicmd '/'   vi-history-search-forward
bindkey -M vicmd '?'   vi-history-search-backward

bindkey -M vicmd 'gg' beginning-of-line
bindkey -M vicmd 'G'  end-of-line

# Insert a last word
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word

autoload -Uz modify-current-argument

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

# Automatically escape URLs when pasting
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

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

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line
