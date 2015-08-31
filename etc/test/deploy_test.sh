#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

unit1() {
    cd "$DOTPATH"
    make deploy >/dev/null
    if [ $? -eq 0 ]; then
        e_done "deploying dot files"
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

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
    cd "$DOTPATH"
    for i in $(make --silent list | sed "s|[*@/]$||g")
    do
        if [ "$(readlink "$HOME/$i")" = "$DOTPATH/$i" ]; then
            :
        else
            ERR=1
        fi
    done

    if [ "$ERR" = 0 ]; then
        e_done "linking valid paths"
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
unit2
