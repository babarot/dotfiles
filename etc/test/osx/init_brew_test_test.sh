#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

trap "die $0: $LINENO" INT ERR

unit1() {
    f=$DOTPATH/etc/init/$(get_os)/brew.sh

    if [ -f "$f" ]; then
        :
    else
        failure "$0: $LINENO: $FUNCNAME"
    fi

    bash "$f"
    if [ $? -eq 0 ]; then
        e_done "bash $f"
    else
        failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
