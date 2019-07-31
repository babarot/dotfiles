# Return if zsh is called from Vim
# if [[ -n $VIMRUNTIME ]]; then
#     return 0
# fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
if [[ -x ~/bin/tmuxx ]]; then
    ~/bin/tmuxx
fi

# if [[ -f ~/.zplug/init.zsh ]]; then
#     export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
#     source ~/.zplug/init.zsh
#
#     if ! zplug check --verbose; then
#         printf "Install? [y/N]: "
#         if read -q; then
#             echo; zplug install
#         fi
#         echo
#     fi
#     zplug load
# fi

autoload -Uz colors; colors

export PATH=~/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

source <(antidote load)

printf "\n"
printf "$fg_bold[cyan] $SHELL $fg_bold[red]$ZSH_VERSION"
printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]${TMUX:+$(tmux -V)}$reset_color\n\n"
