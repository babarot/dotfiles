#!/bin/bash
#
# @(#) gre ver.0.1 2014.10.2
#
# Usage:
#   gre file word...
#
# Description:
#   Multiple grep, wrapper script
#
######################################################################

narrowing()
{
	# Option parser
	if [ -p /dev/stdin ]; then
		if [ -z "$1" ]; then
			echo 'too few arguments' 1>&2
			return 1
		fi	
		local target='-'
	else
		if [ "$#" -ge 2 ]; then
			# if last arguments is exists
			if [ -f "$1" ]; then
				local target="$1"
				shift
			else
				echo "$1: no such file or directory" 1>&2
				return 1
			fi
		else
			echo 'too few arguments' 1>&2
			return 1
		fi
	fi

	# Main
	local target_sorted=$(cat "$target" | awk '!colname[$0]++{print $0}')
	#for i in "${@:1:$#-1}"
	for i in "${@}"
	do
		local target_sorted=$(echo "${target_sorted}" | \grep -i "${i}")
	done

	echo "${target_sorted}"
	return 0
}

narrowing ${@+"$@"}
