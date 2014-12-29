#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

for candidate in $(echo "$PATH" | tr ":" "\n")
do
    vim_candidate="$candidate/vim"
    if [ -x "$vim_candidate" ]; then
        if eval "$vim_candidate" --version | grep -q "+clipboard"; then
            exit 0
        fi
    fi
done

echo -n "Rebuild vim? But it takes time.(y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/vimbuild
fi
