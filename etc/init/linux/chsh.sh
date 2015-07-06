#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. $DOTPATH/etc/lib/vital.sh

if ! contains "${SHELL:-}" "${1:-zsh}"; then
    path="$(which "${1:-zsh}")"
    sudo chsh -s "${path:-}"
    if [ $? -eq 0 ]; then
        echo "[verbose] chsh -s ${path:-\"\"}"
    else
        die "run chsh -l; chsh"
    fi
fi
