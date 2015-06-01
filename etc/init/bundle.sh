#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. $DOTPATH/etc/lib/vital.sh
. $DOTPATH/etc/lib/standard.sh

# This script is
# Mac OS X only!!
is_osx || exit

if is_exist "brew"; then
    brew tap Homebrew/bundle 2>/dev/null
    cd $DOTPATH/etc/init/assets/brew
    if [ ! -f Brewfile ]; then
        brew bundle dump
    fi
    brew bundle
fi
