#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

set -eu
trap "die $0: $LINENO" INT ERR

unit1() {
    bin=($(
    cat $DOTPATH/etc/init/assets/go/config.toml |
    grep "^ \{1,\}" |
    sed 's/ //g' |
    sed 's/"//g' |
    sed 's/,$//g' |
    sed 's/\/\.\.\.$//g'
    ))

    err=0
    for i in "${bin[@]}"
    do
        #has $(basename "$i") && e_arrow $i || e_error $i
        if ! has $(basename "$i"); then
            err=1
        fi
    done

    if [ "$err" = 0 ]; then
        e_done "installed all go packages"
    else
        : failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
