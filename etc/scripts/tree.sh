#!/bin/bash

set -eu

. $DOTPATH/etc/lib/vital.sh

usage=$(cat <<-'HELP'
usage: <find command options>
HELP
)

if has "tree"; then
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less # -FRNX;
else
    if [ "$1" = "-h" -o "$1" = "--help" ]; then
        echo "$usage"
        exit 1
    fi

    [ -d "$1" ] && DIR=$1 && shift || DIR=.
    (cd ${DIR}; pwd)
    find "${DIR}" "$@" | \
    sed  -e "s,^${DIR},," \
         -e '/^$/d' \
         -e 's,[^/]*/\([^/]*\)$,\+--\1,' \
         -e 's,[^/]*/,   ,g' \
         -e 's,\(^\+--\)\|\(^   \),,'
fi
