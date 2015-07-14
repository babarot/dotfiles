#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

#[ -z "${PS1:-}" ] && . "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"
