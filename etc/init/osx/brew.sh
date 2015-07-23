#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if has "brew"; then
    exit
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if has "brew"; then
    brew doctor
else
    log_fail "brew couldn't installed"
    exit 1
fi

log_pass "ok: installing brew"
