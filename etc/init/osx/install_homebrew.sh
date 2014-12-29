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
