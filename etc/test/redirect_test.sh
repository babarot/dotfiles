#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

trap "die $0: $LINENO" INT ERR

unit1() {
    diff -qs \
        <(wget -qO - dot.b4b4r07.com) \
        <(wget -qO - raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install) | \
        grep -q "identical"
    
    if [ $? -eq 0 ]; then
        e_done "redirecting dot.b4b4r07.com to github.com"
    else
        failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
