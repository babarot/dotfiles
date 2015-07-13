#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: $LINENO: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

unit1() {
    has "shellcheck" && :
    if [ $? -ne 0 ]; then
        return
    fi

    f=()
    f+=("$DOTPATH"/etc/init/*.sh)
    f+=("$DOTPATH"/etc/init/common/*.sh)
    f+=("$DOTPATH"/etc/init/osx/*.sh)
    f+=("$DOTPATH"/etc/init/linux/*.sh)

    e_arrow "check POSIX..."
    for i in "${f[@]}"
    do
        shellcheck "$i">/dev/null
        if [ $? -eq 0 ]; then
            e_success "$i" | e_indent
        else
            ERR=1
            e_failure "$i" | e_indent
        fi
    done

    if [ "$ERR" -eq 1 ]; then
        return 1
    fi
}

unit1
