#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -u
set -e

#
# A system that judge if this script is necessary or not
# {{{
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo -n 'Setup Karabiner.app now? (y/N) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "setup Karabiner.app"
fi
#cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner
#if [[ ! -d $cli ]]; then
#    #exit 1
#    :
#fi

# vim:fdm=marker
