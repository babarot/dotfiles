# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# .zshrc
#   zshenv -> zprofile -> zshrc (current)
#
# | zshenv   : always
# | zprofile : if login shell
# | zshrc    : if interactive shell
# | zlogin   : if login shell, after zshrc
# | zlogout  : if login shell, after logout
#
# https://zsh.sourceforge.io/Doc/Release/Files.html#Files
#

# Return if zsh is called from Vim
if [[ -n $VIMRUNTIME ]]; then
    return 0
fi

autoload -Uz compinit
compinit

autoload -Uz colors
colors



source <(afx init)

source <(kubectl completion zsh)
source <(helm completion zsh)

# FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
. /opt/homebrew/opt/asdf/libexec/asdf.sh


source <(afx completion zsh)

# word split: `-`, `_`, `.`, `=`
export WORDCHARS='*?[]~&;!#$%^(){}<>'

