#!/bin/bash

trap 'echo Error: $0: stopped' ERR INT
set -u
set -e

echo -n 'Install Homebrew packages? (y/N) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/Brewfile
fi
