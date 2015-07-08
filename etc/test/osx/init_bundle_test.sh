#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

trap "die $0: $LINENO" INT ERR

unit1() {
    e_arrow "test bundle.sh..."

    if [ -f $DOTPATH/etc/init/osx/bundle.sh ]; then
        e_success "check if init script exists" | e_indent
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi

    if [ -f $DOTPATH/etc/init/assets/brew/Brewfile ]; then
        e_success "check if Brewfile exists" | e_indent
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
