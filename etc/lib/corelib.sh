#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

available() {
    local x candidates

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [ -n "$candidates" ]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is available
        if has "$x"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

reverse() {
    if [ -z "$1" ]; then
        cat <&0
    else
        cat "$1"
    fi | awk '
    {
        line[NR] = $0
    }
    END {
        for (i = NR; i > 0; i--) {
            print line[i]
        }
    }' 2>/dev/null
}

ask() {
    local ans

    printf "%s [y/N]: " "$1"
    read ans

    case "$ans" in
        y|Y|yes|YES)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
