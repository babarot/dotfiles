#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

[ -z "${PS1:-}" ] && . "$DOTPATH"/etc/lib/vital.sh

has "bash" && shell="bash"
has "zsh"  && shell="zsh"

if ! contains "${SHELL:-}" "${1:-"$shell"}"; then
    path="$(which "${1:-"$shell"}")"
    if [ -f "$path" -a -x "$path" ]; then
        if sudo chsh -s "${path:-}"; then
            echo "[verbose] chsh -s ${path:-\"\"}"
        else
            die "run chsh -l; chsh"
        fi
    else
        die "$path: invalid path"
    fi
fi

echo "\$SHELL=$SHELL"
