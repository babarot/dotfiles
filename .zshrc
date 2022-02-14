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

source <(afx init)

printf "\n${fg_bold[cyan]} ${SHELL} ${fg_bold[red]}${ZSH_VERSION}"
printf "${fg_bold[cyan]} - DISPLAY on ${fg_bold[red]}${TMUX:+$(tmux -V)}${reset_color}\n\n"
