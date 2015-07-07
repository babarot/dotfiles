#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

trap "die $0: $LINENO" INT ERR

unit1() {
    p=($(
    cat $DOTPATH/etc/init/assets/brew/Brewfile |
    grep "^brew" |
    sed -e "s/[^']*'\([^']*\)'.*/\1/"
    ))

    e_arrow "check Brewfile..."

    err=0
    for i in "${p[@]}"
    do
        if has "$i"; then
            success "installed '$i'"
        else
            echo "not installed '$i'"
        fi
    done

    if [ "$err" = 0 ]; then
        : e_done "check Brewfile"
    else
        failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
