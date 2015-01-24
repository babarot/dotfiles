#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR
set -e
set -u

#
# A system that judge if this script is necessary or not
# {{{
for candidate in $(echo "$PATH" | tr ":" "\n")
do
    vim_candidate="$candidate/vim"
    if [ -x "$vim_candidate" ]; then
        if eval "$vim_candidate" --version | grep -q "+clipboard"; then
            exit 0
        fi
    fi
done
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo -n "Rebuild vim? But it takes time.(y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash "$(dirname "${BASH_SOURCE}")"/vimbuild
fi

# vim:fdm=marker
