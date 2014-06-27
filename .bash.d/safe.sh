#!/bin/bash

safety_rm_log="$HOME/.safe/log"
safety_rm_box="$HOME/.safe/$(date '+%Y')/$(date '+%m')/$(date '+%d')"
param_flag=''
option=''

function usage()
{
	echo -e "rm [options] files\n"
	echo -e "\tAll changes about removing files has been recorded $safety_rm_log"
	echo -e "\tToday, deleted all files are stored in the $safety_rm_box\n"
	echo -e "\toptions:"
	echo -e "\t\t-h, --help\tdisplay this help"
	echo -e "\t\t-b [num]\tback files default 1 ago"
	echo -e "\t\t-l [num]\tlist up deleted file default 10\n"
	echo -e "\tThis rm has a restore feature, because"
	echo -e "\tthere is no -i and -f option with the original rm.\n"
}

	num2=$( wc -l <$safety_rm_log | sed "s/ //g" )
	num3=( $(seq $num2 1)  )

function listup()
{
	OLDIFS=$IFS && IFS=$'\n'

	array_number=( $( seq $num2 1 | tail -n "${1:-10}" ) )
	array_front=(  $( tail -n "${1:-10}" $safety_rm_log | awk '{print $1,$2}' | sed "s $HOME ~ g" ) )
	array_center=( $( tail -n "${1:-10}" $safety_rm_log | awk '{print $3}'    | sed "s $HOME ~ g" ) )
	array_rear=(   $( tail -n "${1:-10}" $safety_rm_log | awk '{print $4}'    | sed "s $HOME ~ g" ) )

	max=`for((I = 0; I < ${#array_center[*]}; ++I)); do
		echo "${#array_center[I]}"
	done | sort -nr | head -1`

	for ((I = 0; I < ${#array_center[*]}; ++I))
	do
		printf "%3d %s\t%-${max}s\t%s\n" ${array_number[I]} ${array_front[I]} ${array_center[I]} ${array_rear[I]}
	done

	IFS=$OLDIFS
}

function restore()
{
	if [ -z "$1" ]; then
		src="$( tail -n 1 $safety_rm_log | awk '{print $3}' )"
		dst="$( tail -n 1 $safety_rm_log | awk '{print $4}' )"
	else
		src="$( listup $num2 | awk '{if($1=="'$1'") print $4}' | sed "s ~ $HOME g")"
		dst="$( listup $num2 | awk '{if($1=="'$1'") print $5}' | sed "s ~ $HOME g")"
	fi
	read -p "$src? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		cp -p -R $dst $src
	fi
}

function safety_rm()
{
	# main "rm" part
	type abs_path >/dev/null 2>&1 || . $MASTERD/function.sh

	error=""
	for path do
		# Checking if the file you want to delete exists
		if [[ "$path" =~ ^-+ ]]; then
			#loption=( ${loption[@]} "$path" )
			loption+=( "$path" )
			continue
		fi
		if [ -e "$path" ]
		then
			in_trash="$safety_rm_box/${path##*/}.$(date '+%H')_$(date '+%M')_$(date '+%S')"

			if command mv ${loption[@]} "$path" "$in_trash"
			then
				#echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$( abs_path $path )\t$in_trash" >>$safety_rm_log
				echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$(cd $(dirname $path) && pwd)/${path##*/}\t$in_trash" >>$safety_rm_log
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

	[ "$error" ] && exit 1
	exit 0
}

## MAIN PART
[ -f $safety_rm_log ] || touch $safety_rm_log
[ -e $safety_rm_box ] || mkdir -p $safety_rm_box || {
	echo "$safety_rm_box: could not create"
	exit 1
}

for opt do
	case "$opt" in
		'-h'|'--help' )
			usage
			exit 1
			;;
		'-b'|'--back' )
			param_flag=1
			if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
				restore
			else
				restore "$2"
				shift 2
			fi
			;;
		'-l'|'--list' )
			param_flag=1
			if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
				listup
			else
				listup "$2"
				shift 2
			fi
			;;
		'-o'|'--original' )
			shift 1
			command rm -rf "$@"
			break
			;;
		'-f'|'--find' )
			shift 1
			find $HOME/.safe -iname *$1*
			exit 0
			;;
		'--'|'-' )
			shift 1
			param+=( "$@" )
			break
			;;
		-*)
			option+=( "$1" )
			shift 1
			;;
		*)
			if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
				param+=( "$1" )
				shift 1
			fi
			;;
	esac
done

if [ -z $param_flag ] && [ -z $param ]; then
	echo "rm: too few arguments" 1>&2
	echo "Try 'rm --help' for more information." 1>&2
	exit 1
fi
 
safety_rm ${param[@]} ${option[@]}
