#!/bin/bash

trap 'echo Error: $0: stopped' ERR INT
set -u
set -e

exit 0
cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner
if [[ ! -d $cli ]]; then
    #exit 1
    :
fi
