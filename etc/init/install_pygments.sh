#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR
set -e
set -u

declare installer='unknown'
if type pip >/dev/null 2>&1; then
    installer='pip'
elif type easy_install >/dev/null 2>&1; then
    installer='easy_install'
fi

# A system that judge if this script is necessary or not
# {{{
if type pygmentize >/dev/null 2>&1; then
    exit 0
fi
if [[ $installer == 'unknown' ]]; then
    exit 0
fi
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo -n "Do you want to install the pygments is a syntax highlighter written in python? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if [[ "$installer" == 'unknown' ]]; then
        echo "Please install python tools." 1>&2
        exit 1
    fi

    sudo "$installer" install Pygments
    echo ""
    echo "For more information, see <http://pygments.org>"
    echo "For installing solarized style,"
    echo "see <http://www.realultimateprogramming.com/solarized-dark-pygments/>"
    echo "and <https://github.com/john2x/solarized-pygment>"
fi

# vim:fdm=marker
