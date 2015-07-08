#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if has "goal"; then
    cd "$DOTPATH"/etc/init/assets/go
    if [ -f config.toml ]; then
        goal
    else
        exit 1
    fi
else
    die "goal: not found"
fi
