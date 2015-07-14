#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

#[ -z "${PS1:-}" ] && . "$DOTPATH"/etc/lib/vital.sh

if has "goal"; then
    cd "$DOTPATH"/etc/init/assets/go
    if [ -f config.toml ]; then
        goal --verbose
    else
        exit 1
    fi
else
    die "goal: not found"
fi
