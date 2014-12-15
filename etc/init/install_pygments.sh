#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

type pygmentize >/dev/null 2>&1 && exit 0

declare installer='unknown'
if type pip >/dev/null 2>&1; then
    installer='pip'
elif type easy_install >/dev/null 2>&1; then
    installer='easy_install'
fi

echo -n "Do you want to install the pygments is a syntax highlighter written in python? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if [[ "$installer" == 'unknown' ]]; then
        echo "Please install python tools." 1>&2
        exit 1
    fi

    eval sudo "$installer" install Pygments
    echo ""
    echo "For more information, see <http://pygments.org>"
    echo "For installing solarized style,"
    echo "see <http://www.realultimateprogramming.com/solarized-dark-pygments/>"
    echo "and <https://github.com/john2x/solarized-pygment>"
fi
