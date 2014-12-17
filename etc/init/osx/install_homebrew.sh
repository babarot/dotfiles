#!/bin/bash

trap 'echo Error: $0: stopped' ERR INT
set -u
set -e

if ! type brew >/dev/null 2>&1; then
    echo 'brew: command not found' 1>&2
    echo -n 'Install now? (y/N/) '
    read
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
fi

echo -n 'Install Homebrew packages? (y/N/) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/Brewfile
fi

echo -n 'Install Homebrew Cask packages? (y/N/) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/Caskfile
fi
