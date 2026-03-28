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

source <(afx init)
source <(afx completion zsh)

export XDG_CONFIG_HOME="$HOME/.config"

# word split: `-`, `_`, `.`, `=`
export WORDCHARS='*?[]~&;!#$%^(){}<>'

eval "$(mise activate zsh)"

# bun completions
[ -s "/Users/babarot/.bun/_bun" ] && source "/Users/babarot/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.cargo/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

eval "$(enter --init-shell zsh)"
export PATH="$HOME/.local/bin:$PATH"
