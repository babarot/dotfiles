#!/bin/bash


if [ $# -eq 0 ]; then
	echo "usage: rm files"
	exit 1
fi

trash_log=~/.safe/log
trash_safe=~/.safe/$(date '+%Y')/$(date '+%m')/$(date '+%d')
[ -e $trash_safe ] || mkdir -p $trash_safe || {
	echo "$trash_safe: could not create"
	exit 1
}

if [ "$1" = '-b' ]
then
	src="$( tail -n 1 $trash_log | awk '{print $3}' )"
	dst="$( tail -n 1 $trash_log | awk '{print $4}' )"
	read -p "$src? " ANS
	[ "$ANS" = 'y' ] && cp -p $dst $src
	exit 0
fi

if [ "$1" = '-l' ]
then
	shift
	OLDIFS=$IFS && IFS=$'\n'

	array_a=( $(tail -n "${1:-10}" $trash_log | awk '{print $1,$2}' | sed "s $HOME ~ g") )
	array=(   $(tail -n "${1:-10}" $trash_log | awk '{print $3}' | sed "s $HOME ~ g") )
	array_e=( $(tail -n "${1:-10}" $trash_log | awk '{print $4}' | sed "s $HOME ~ g") )

	max=`for((I = 0; I < ${#array[*]}; ++I)); do
		echo "${#array[I]}"
	done | sort -nr | head -1`

	for ((I = 0; I < ${#array[*]}; ++I))
	do
		printf "%s\t%-${max}s\t%s\n" ${array_a[I]} ${array[I]} ${array_e[I]}
	done

	IFS=$OLDIFS
	exit 0
fi

# main "rm" part
type abs_path >/dev/null 2>&1 || . $MASTERD/function.sh

error=""
for path do
	# Checking if the file you want to delete exists
	if [ -e "$path" ]
	then
		in_trash="$trash_safe/${path##*/}.$(date '+%H')_$(date '+%M')_$(date '+%S')"

		if mv "$path" "$in_trash"
		then
			echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$( abs_path $path )\t$in_trash" >>$trash_log
		else
			echo "$path: could not move to trash" >&2
			error="YES"
		fi
	else
		# It is an error to try to remove a file that does not exist.
		echo "$path: not exist" >&2
		error="YES"
	fi
done && unset path in_trash trash_safe trash_log

[ -n "$error" ] && exit 1
exit 0
