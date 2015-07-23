#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

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
        log_fail "something is wrong"
        exit 1
    fi
else
    log_fail "install python before Pygments"
    exit 1
fi

log_pass "ok: installing pygmentize"
