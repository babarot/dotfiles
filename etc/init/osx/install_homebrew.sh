#!/bin/bash

trap 'echo Error: $0: stopped' ERR INT
set -u
set -e

# A system that judge if this script is necessary or not
# {{{
type brew >/dev/null 2>&1 && exit
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo 'brew: command not found' 1>&2
echo -n 'Install now? (y/N) '
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# vim:fdm=marker
