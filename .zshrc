# Return if zsh is called from Vim
# if [[ -n $VIMRUNTIME ]]; then
#     return 0
# fi

if [[ -x ~/bin/tmuxx ]]; then
    ~/bin/tmuxx
fi

source <(pkg load)

printf "\n"
printf "${fg_bold[cyan]} ${SHELL} ${fg_bold[red]}${ZSH_VERSION}"
printf "${fg_bold[cyan]} - DISPLAY on ${fg_bold[red]}${TMUX:+$(tmux -V)}${reset_color}\n\n"
