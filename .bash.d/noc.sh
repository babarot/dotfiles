#!/bin/sh

FILE=~/.bash_myhistory

if  [ "$1" = "-h" ]; then
	echo 1>&2 "usage: noc [-h|-l] [<num>]"
	echo 1>&2 "       -h    display this help and exit"
	echo 1>&2 "       -l    display most recently used list"
	echo 1>&2 "             (range: 0~<num>: default num zero)"
	exit 1
fi

if [ "$1" = "-l" ]; then
	for i in `seq 0 "${2:-9}"`
	do
		printf "%d\t%s\t%5d\n" $i $(date -v-${i}d '+%Y-%m-%d') $(grep -c `date -v-${i}d '+%Y-%m-%d'` $FILE)
	done
	exit 0
fi

grep -c `date -v-${1:-0}d '+%Y-%m-%d'` $FILE

exit 0
