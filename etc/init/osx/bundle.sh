#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if has "brew"; then
    brew tap Homebrew/bundle 2>/dev/null

    cd "$DOTPATH"/etc/init/assets/brew
    if [ ! -f Brewfile ]; then
        brew bundle dump
    fi

    brew bundle
else
    die "you should install brew"
fi
