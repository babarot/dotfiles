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
# if [[ -n $VIMRUNTIME ]]; then
#     return 0
# fi

autoload -Uz compinit
compinit

autoload -Uz colors
colors

export GOPATH=$HOME
export PATH=$PATH:/opt/homebrew/bin

source <(afx init)
source <(afx completion zsh)

export WORDCHARS='*?[]~&;!#$%^(){}<>'

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
