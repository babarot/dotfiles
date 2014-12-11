#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

for candidate in $(echo "$PATH" | tr ":" "\n")
do
    vim_candidate="$candidate/vim"
    if [ -x "$vim_candidate" ]; then
        if eval "$vim_candidate" --version | grep -q "+clipboard"; then
            vim_clipboard_path="$vim_candidate"
            unset vim_candidate
            #break
            exit 0
        fi
    fi
done

echo -n "Rebuild vim? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    export PATH="../../bin:$PATH"
    if type vimbuild >/dev/null 2>&1; then
        vimbuild
    else
        echo "Execute vimbuild at your terminal" 1>&2
        exit 1
    fi
fi
