#!/bin/bash

trap 'echo Error: $0: stopped' ERR INT
set -u
set -e

if type git >/dev/null 2>&1; then
    echo -n 'Install antigen zsh plugin manager? (y/N) '
    read
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        if [[ -e ~/.antigen ]]; then
            rm -rf ~/.antigen
        fi
        git clone https://github.com/zsh-users/antigen ~/.antigen
    fi
fi
