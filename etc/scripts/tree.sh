#!/bin/bash

COMMAND="${0##*/}"
usage() {
    echo "${COMMAND} <find command options>"
    exit
}
[ "$1" = '-h' -o "$1" = '-help' ] && usage

FIND=`which find`
SED=`which sed`

[ -d "$1" ] && DIR=$1 && shift || DIR=.
(cd ${DIR}; pwd)
${FIND} "${DIR}" "$@" | \
${SED} -e "s,^${DIR},," \
       -e '/^$/d' \
       -e 's,[^/]*/\([^/]*\)$,\+--\1,' \
       -e 's,[^/]*/,   ,g' \
       -e 's,\(^\+--\)\|\(^   \),,'
