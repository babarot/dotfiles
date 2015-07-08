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
