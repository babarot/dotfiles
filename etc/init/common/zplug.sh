#!/bin/bash

if [[ ! -f ~/.zplug/init.zsh ]]; then
    if (( ! $+commands[git] )); then
        echo "git: command not found" >&2
        exit 1
    fi

    git clone \
        https://github.com/zplug/zplug \
        ~/.zplug

    # failed
    if (( $status != 0 )); then
        echo "zplug: fails to installation of zplug" >&2
    fi
fi

if [[ -f ~/.zplug/init.zsh ]]; then
    echo "zplug: not found" >&2
    exit 1
fi
# load zplug
source ~/.zplug/init.zsh

if [[ -f $DOTPATH/.zsh/zplug.zsh ]]; then
    export ZPLUG_LOADFILE="$DOTPATH/.zsh/zplug.zsh"
fi

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi
zplug load --verbose
