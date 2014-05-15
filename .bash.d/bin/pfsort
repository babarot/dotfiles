#!/bin/bash

set -e
trap 'exit -1' ERR

if [ "$1" = "-h" -o "$1" = "--help" ]; then
	echo "Usage: $(basename $0) [-v | --help] [num]"
	echo "  When there is not an argument,"
	echo "  sort a field with 2 as a default."
	echo
	exit 1
fi

gawk '
{
	line[NR] = $'${1:-2}' "\t" $0;
}

END {
	asort(line);
	for (i = 1; i <= NR; i++) {
		print substr(line[i], index(line[i], "\t") + 1);
	}
}' 2>/dev/null
