#!/bin/bash

myrm_log="$HOME/.myrm/log"
myrm_box="$HOME/.myrm/$(date '+%Y')/$(date '+%m')/$(date '+%d')"
#echo "$(date '+%Y/%m/%d')"
#echo "$(date '+%H_%M_%S')"
#echo "$(date '+%Y/%m/%d')"

function richrm()
{
	error=""
	for path do
		if [ -e "$path" ]; then
			in_trash="$myrm_box/${path##*/}.$(date '+%H')_$(date '+%M')_$(date '+%S')"

			if command mv -f "$path" "$in_trash"; then
				echo -e "$(date '+%Y-%m-%d %H:%M:%S') $(cd $(dirname $path) && pwd)/${path##*/} $in_trash" >>$myrm_log
			else
				echo "$path: could not move to trash" >&2
				error="YES"
			fi
		else
			# It is an error to try to remove a file that does not exist.
			echo "$path: not exist" >&2
			error="YES"
		fi
	done

	[ "$error" ] && return 1
	return 0
}

[ -f $myrm_log ] || touch $myrm_log
if [ ! -d $myrm_box ]; then
	mkdir -p $myrm_box
	if [ $? -ne 0 ]; then
		echo "$myrm_box: could not create"
		exit 1
	fi
fi

# Rm main part.
if [ -z "$1" ]; then
	echo "too few arguments"
	exit 1
elif [ "$1" = '-l' ]; then
	shift
	if [ -z "$1" ]; then
		sed "s $HOME ~ g" $myrm_log | nl
	else
		sed "s $HOME ~ g" $myrm_log | nl | tail -n "$1"
	fi
	exit
elif [ "$1" = '-b' ]; then
	shift
	if [ -z "$1" ]; then
		src="$( tail -n 1 $myrm_log | awk '{print $3}' )"
		dst="$( tail -n 1 $myrm_log | awk '{print $4}' )"
	else
		src="$( nl <$myrm_log | awk '{if($1=="'$1'") print $4}' | sed "s ~ $HOME g")"
		dst="$( nl <$myrm_log | awk '{if($1=="'$1'") print $5}' | sed "s ~ $HOME g")"
	fi
	test "$src" || exit
	read -p "$src? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		cp -p -R $dst $src
	fi
	exit
fi

richrm "$@"
