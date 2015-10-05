#!/bin/bash
#
# @(#) rmr v0.0.1 2015-08-05
#
# Usage:
#   rmr [-r] file...
#
# Description:
#   rmr deletes files and restores the files
#
######################################################################

d=" "
rmr_trash=$HOME/.rmtrash
rmr_logfile=$rmr_trash/log

delete() {
    if [[ ! -d "$rmr_trash/$(date +'%Y/%m/%d')" ]]; then
        mkdir -p "$rmr_trash/$(date +'%Y/%m/%d')"
    fi

    local err=0
    local f f_trashpath f_abspath

    for f in "$@"
    do
        if [[ -e "$f" ]]; then
            f_trashpath="$rmr_trash/$(date +'%Y/%m/%d')/$(basename "$f").$(date '+%H_%M_%S')"
            f_abspath="$(cd "$(dirname "$f")" && pwd)/$(basename "$f")"

            if /bin/mv -f "$f" "$f_trashpath"; then
                echo "$f_abspath$d$f_trashpath"
            else
                echo "$f: could not move to $rmr_trash" >&2
                err=1
            fi
        else
            echo "$f: not exist" >&2
            err=1
        fi
    done

    if [ "$err" = 1 ]; then
        return 1
    fi
}

restore() {
    # requirement: peco

    # reverse: like tac, tail -r
    reverse()
    {
        $(which ex) -s "${1}" <<-EOF
        g/^/mo0
        %p
EOF
    }

    local max=$(
        local line
        awk '{print $3}' "$rmr_logfile" | sed "s $HOME ~ g" | while read line
        do
            echo "${#line}"
        done | sort -nr -u | head -n 1
    )

    local cp_mates cp_mates2
    cp_mates=$(
        reverse "$rmr_logfile" |
        sed "s $HOME ~ g" |
        #awk '{ printf("%s %s %-'"$max"'s %s\n",$1,$2,$3,$4) }' |
        awk '{ printf("%s %s %s\n",$1,$2,$3) }' |
        peco |
        sed "s ~ $HOME g"
    )

    if (("${#cp_mates}" > 0)); then
        cp_mates2=($(cat "$rmr_logfile" | grep "${cp_mates}" | awk '{print $4,$3}'))
        cp -R "${cp_mates2[0]}" "${1:-${cp_mates2[1]}}"
        #ln "${cp_mates2[0]}" "${1:-${cp_mates2[1]}}"
    fi
}

logging() {
    touch "$rmr_logfile"
    # log format
    # 2011-04-01 12:34:59 source-file destination-file.12_34_59
    local line

    if [ -t 0 ] ; then
        echo 'error: Not pipeline.' 1>&2
    else
        while read line
        do
            echo "$(date '+%Y-%m-%d')$d$(date '+%H:%M:%S')$d$line"
        done >>"$rmr_logfile"
    fi
}

main() {
    if [[ "$1" == "-r" || "$1" == "--restore" ]] && shift; then
        restore "$@"
        return
    fi

    delete "$@" | logging
}

main "$@"
