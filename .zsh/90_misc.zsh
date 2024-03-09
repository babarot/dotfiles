# need colors
printf "\n${fg_bold[cyan]} ${SHELL} ${fg_bold[red]}${ZSH_VERSION}"
printf "${fg_bold[cyan]} - DISPLAY on ${fg_bold[red]}${TMUX:+$(tmux -V)}${reset_color}\n\n"
neofetch