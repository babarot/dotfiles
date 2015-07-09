#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! contains "${SHELL:-}" "${1:-zsh}"; then
    path="$(which "${1:-zsh}")"
    if [ -f "$path" -a -x "$path" ]; then
        sudo chsh -s "${path:-}"
        if [ $? -eq 0 ]; then
            echo "[verbose] chsh -s ${path:-\"\"}"
        else
            die "run chsh -l; chsh"
        fi
    else
        die "$path: invalid path"
    fi
fi
