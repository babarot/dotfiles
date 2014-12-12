#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

if [[ $OSTYPE != darwin* ]]; then
    echo 'OS X only' 1>&2
    exit 1
fi

if ! type xcode-select >/dev/null 2>&1; then
    echo -n "Do you install Xcode CLI tools? (y/N) "
    read
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        xcode-select --install
    fi
fi
