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

# Everything below is human UX: aliases, plugins, prompt, keybinds, setopts.
# AI agents get plain zsh; what they need (PATH, env) lives in .zshenv.
is_human || return 0

autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz compinit && compinit -u
autoload -Uz colors && colors

source <(afx init)
source <(afx completion zsh)

export XDG_CONFIG_HOME="$HOME/.config"

# word split: `-`, `_`, `.`, `=`
export WORDCHARS='*?[]~&;!#$%^(){}<>'

# Agents resolve versions through the shims on PATH (.zshenv);
# activate additionally keeps PATH in sync for interactive use
eval "$(mise activate zsh)"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

eval "$(enter --init-shell zsh)"
