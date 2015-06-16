#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. $DOTPATH/etc/lib/vital.sh
. $DOTPATH/etc/lib/standard.sh

if is_exist "python"; then
    has "pygmentize" && exit

    sudo easy_install pip
    pip install Pygments
    pip install pygments-style-solarized

    cd $DOTPATH/etc/init/assets/pygments
    if [ -d solarized-pygment ]; then
        cd solarized-pygment
        git submodule update
        sudo ./setup.py install
    fi
else
    e_error "install python before Pygments"
fi
