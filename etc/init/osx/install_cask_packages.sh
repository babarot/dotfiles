#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -u
set -e

#
# A system that judge if this script is necessary or not
# {{{
[[ ! -f "$(dirname "${BASH_SOURCE}")"/Caskfile ]] && exit
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo -n 'Install Homebrew Cask packages? (y/N) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/Caskfile
fi

# vim:fdm=marker
