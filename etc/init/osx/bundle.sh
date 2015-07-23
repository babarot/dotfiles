#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if has "brew"; then
    brew tap Homebrew/bundle 2>/dev/null
    if [ $? -ne 0 ]; then
        log_fail "Homebrew/bundle couldn't tapped"
        exit 1
    fi

    cd "$DOTPATH"/etc/init/assets/brew
    if [ ! -f Brewfile ]; then
        brew bundle dump
    fi

    brew bundle
else
    log_fail "brew: not found"
    exit 1
fi

log_pass "ok: tapping brew bundle"
