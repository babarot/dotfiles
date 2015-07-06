#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. $DOTPATH/etc/lib/vital.sh
. $DOTPATH/etc/lib/standard.sh

is_osx || die "osx only"
