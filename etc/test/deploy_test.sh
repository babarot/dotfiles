#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

unit1() {
    cd $DOTPATH
    make deploy >/dev/null
    if [ $? -eq 0 ]; then
        e_done "deploying dot files"
    else
        e_error "$0: $LINENO: $FUNCNAME"
    fi
}

unit1

readlink() {
    if [ $# -eq 0 ] ; then
        return 1
    fi

    file="$1"
    if [ ! -e "$file" ]; then
        return 1
    fi
    cd "$(dirname "$1")"
    file="$(basename "$file")"
    while [ -L "$file" ]; do
        file="$(command readlink "$file")"
        cd "$(dirname "$file")"
        file="$(basename "$file")"
    done
    phys="$(pwd -P)"
    result="$phys/$file"
    echo "$result"
}

unit2() {
    cd $DOTPATH
    for i in $(make list | sed "s|/$||g")
    do
        if [ $(readlink $HOME/"$i") = $DOTPATH/"$i" ]; then
            err=0
        else
            err=1
        fi
    done

    if [ "$err" = 0 ]; then
        e_done "linking valid paths"
    else
        e_error "$0: $LINENO: $FUNCNAME"
    fi
}

unit2
