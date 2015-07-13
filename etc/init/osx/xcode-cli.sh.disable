#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. $DOTPATH/etc/lib/vital.sh

is_osx || die "osx only"

if has "xcode-select"; then
    xcode-select --install
fi
