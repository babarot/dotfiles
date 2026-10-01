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

autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz compinit && compinit -u
autoload -Uz colors && colors

# word split: `-`, `_`, `.`, `=`
export WORDCHARS='*?[]~&;!#$%^(){}<>'

# Plugins, aliases and env from nix/home-manager/tools/*.nix (my.human), plus the
# hand-written ~/.zsh/[0-9]*.zsh
source ~/.config/zsh/human.zsh
