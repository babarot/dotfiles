#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -u
set -e

if ! type brew >/dev/null 2>&1; then
    echo 'brew: command not found' 1>&2
    echo -n 'Install now? (y/N/) '
    read
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [ $? -eq 0 ]; then
            echo 'Complete!'
            exit 0
        fi
        exit 1
    else
        exit 0
    fi
fi

