#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

[ -z "${PS1:-}" ] && . "$DOTPATH"/etc/lib/vital.sh

if has "python"; then
    has "pygmentize" && exit

    sudo easy_install pip
    pip install Pygments
    pip install pygments-style-solarized

    cd "$DOTPATH"/etc/init/assets/pygments
    if [ -d solarized-pygment ]; then
        cd solarized-pygment
        git submodule update
        sudo ./setup.py install
    else
        die
    fi
else
    die "install python before Pygments"
fi
