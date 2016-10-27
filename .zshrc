#          _              
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#                         
#

umask 022
limit coredumpsize 0
bindkey -d

# It is necessary for the setting of DOTPATH
if [[ -f ~/.path ]]; then
    source ~/.path
else
    export DOTPATH="${0:A:t}"
fi

# DOTPATH environment variable specifies the location of dotfiles.
# On Unix, the value is a colon-separated string. On Windows,
# it is not yet supported.
# DOTPATH must be set to run make init, make test and shell script library
# outside the standard dotfiles tree.
if [[ -z $DOTPATH ]]; then
    echo "$fg[red]cannot start ZSH, \$DOTPATH not set$reset_color" 1>&2
    return 1
fi

# Vital
# vital.sh script is most important file in this dotfiles.
# This is because it is used as installation of dotfiles chiefly and as shell
# script library vital.sh that provides most basic and important functions.
# As a matter of fact, vital.sh is a symbolic link to install, and this script
# change its behavior depending on the way to have been called.
export VITAL_PATH="$DOTPATH/etc/lib/vital.sh"
if [[ -f $VITAL_PATH ]]; then
    source "$VITAL_PATH"
fi

export ENHANCD_FILTER="fzy:$ENHANCD_FILTER"

# Exit if called from vim
[[ -n $VIMRUNTIME ]] && return

# Check whether the vital file is loaded
if ! vitalize 2>/dev/null; then
    echo "$fg[red]cannot vitalize$reset_color" 1>&2
    return 1
fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
$DOTPATH/bin/tmuxx

if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE="$HOME/.zsh/zplug.zsh"
    #source ~/.zplug/init.zsh
    source ~/src/github.com/zplug/zplug/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        else
            echo
        fi
    fi
    zplug load --verbose
fi

# Display Zsh version and display number
printf "\n$fg_bold[cyan]This is ZSH $fg_bold[red]${ZSH_VERSION}"
printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n\n"

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:
