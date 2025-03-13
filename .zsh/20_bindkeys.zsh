# Vim-like keybind as default
bindkey -e
set -o emacs

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Some terminals use these instead
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line