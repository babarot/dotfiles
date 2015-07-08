#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

trap "die $0: $LINENO" INT ERR

unit1() {
    e_arrow "test brew.sh..."

    if [ -f $DOTPATH/etc/init/osx/brew.sh ]; then
        e_success "check if init script exists" | e_indent
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi

    if bash $DOTPATH/etc/init/osx/brew.sh; then
        e_success "check running" | e_indent
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
