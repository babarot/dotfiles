#!/bin/bash

. "$DOTPATH"/etc/lib/vital.sh

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
        if has "${x%% *}"; then
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

emphasis() {
    local word color emphasis

    word="$1"
    color="${2:-red}"

    case "$color" in
        black)
            emphasis="\033[30m${word}\033[m"
            ;;
        red)
            emphasis="\033[31m${word}\033[m"
            ;;
        green)
            emphasis="\033[32m${word}\033[m"
            ;;
        yellow)
            emphasis="\033[33m${word}\033[m"
            ;;
        blue)
            emphasis="\033[34m${word}\033[m"
            ;;
        purple)
            emphasis="\033[35m${word}\033[m"
            ;;
        cyan)
            emphasis="\033[36m${word}\033[m"
            ;;
        gray)
            emphasis="\033[37m${word}\033[m"
            ;;
        *)
            emphasis="\033[m${word}\033[m"
            ;;
    esac

    if [ -p /dev/stdin ]; then
        cat <&0
    else
        echo "$word"
    fi | perl -pe 's/'"${word}"'/\033[31m'"${emphasis}"'\033[m/'
}

normalize() {
    ruby -e 'puts File.expand_path(ARGV[0])' "${1:-$(cat <&0)}"
}

cpu_cores() {
    if is_osx; then
        sysctl -n hw.ncpu
    else
        grep -c "^processor.*[0-9]$" /proc/cpuinfo
    fi 2>/dev/null
}
PROC="$(cpu_cores)"
export PROC
