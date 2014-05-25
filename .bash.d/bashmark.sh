#  @(#) This script is directory bookmarker on bash.
#  @(#) bookmarks.sh ver.1.4.0 2013.08.12
#
#  Copyright (c) 2013, b4b4r07
#  All rights reserved.
#
###################################################################################################################

[ "$BASH_VERSION" ] || return 1

declare -r bookmarkdir=~/.bookmarkdir
declare -r bookmarklist=$bookmarkdir/bookmarklist
declare -r bookmarklog=$bookmarkdir/bookmarklog
declare -r bookmarktemp=$bookmarkdir/bookmarktemp
declare -i exit_usage=0

function _bookmark_usage() {
	local -i width=$( stty 'size' <'/dev/tty' | cut -d' ' -f2 )
	local -a commands=( "show" "regist" "go" "print" "delete" )

	if [ $# -eq 0 ]; then
		echo -en "${commands[@]}\n\n"
		_bookmark_usage "${commands[@]}" | ${PAGER:-less}
		return 0
	fi

	for list do
		echo -en "Usage: "
		case "$list" in
			'show')
				echo -en "show [OPTION]\n"
				echo -en "  Display all registration names and paths.\n"
				echo -en "  All options cannot be used together.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit.\n"
				echo -en "  -e, --edit     edit bookmark-list.\n"
				echo -en "  -p, --plane    display the list without a color.\n\n"
				echo -en "  -R, --refresh  update the list by deleting unavailable directorirs.\n\n"
				shift
				;;
			'regist')
				echo -en "reg [OPTION] [name]\n"
				echo -en "  If there is an argument, register by the argument name\n"
				echo -en "  and otherwise register it current directory name.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit.\n"
				echo -en "  -t, --temp     generate the name and path as disposable element.\n\n"
				shift
				;;
			'go')
				echo -en "go [name]\n"
				echo -en "  If there is an argument, go to the name of path\n"
				echo -en "  and otherwise do movement like 'show'.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit.\n\n"
				shift
				;;
			'print')
				echo -en "p name\n"
				echo -en "  print the name of path.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit.\n\n"
				shift
				;;
			'delete')
				echo -en "del name\n"
				echo -en "  delete the name and path.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit.\n\n"
				shift
				;;
		esac
		[ "$#" -ne 0 ] && for (( i=0; i < $width; i++ )); do
			echo -en "_"
		done && echo -en "\n\n"
	done

	return $exit_usage
}

function _bookmark_initialize() {
	[ -d $bookmarkdir ] && return 1

	local ans=
	mkdir -p $bookmarkdir
	touch $bookmarklist $bookmarklog $bookmarktemp

	echo -en "Do you display a help about bashmark? [y/N]: "
	read -t 3 ans
	if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
		_bookmark_usage | ${PAGER:-less}
		return $exit_usage
	elif [ -z "$ans" ]; then
		echo ''
	fi
	unset ans

	return 0
}

function _bookmark_show() {
	[ ! -e $bookmarklist ] && { echo "$(basename $bookmarklist): No exist"; return 1; }

	local opt=

	for opt in "$@"
	do
		case "$opt" in
			'-h'|'--help' )
				_bookmark_usage ${FUNCNAME##*_}
				return $exit_usage
				;;
			'-e'|'--edit' )
				"$EDITOR" $bookmarklist
				shift 1
				return 0
				;;
			'-p'|'--plane' )
				cat $bookmarklist | sed "s $HOME ~ g"
				shift 1
				return 0
				;;
			'-R'|'--refresh' )
				if _bookmark_refresh; then
					return 0
				else
					return 1
				fi
				;;
			'--' )
				shift 1
				param+=( "$@" )
				break
				;;
			-*)
				echo "${FUNCNAME##*_}: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
				return 1
				;;
			*)
				if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
					param+=( "$1" )
					shift 1
				fi
				;;
		esac
	done

	[ ! -f $bookmarklist ] && touch $bookmarklist
	[ ! -f $bookmarklog ]  && touch $bookmarklog
	[ ! -f $bookmarktemp ] && touch $bookmarktemp

	local -i i=
	local -a name=( $( awk '{print $1}' $bookmarklist ) )
	local -a path=( $( awk '{print $2}' $bookmarklist ) )

	for (( i=0; i < ${#name[*]}; i++ )); do
		if grep -w ${name[i]} $bookmarklog >/dev/null; then
			printf "\033[31m%-15s\033[m%s\n" ${name[i]} ${path[i]}

		elif grep -w ${name[i]} $bookmarktemp >/dev/null; then
			printf "\033[01;36m%-15s\033[m%s\n" ${name[i]} ${path[i]}

		else
			printf "\033[33m%-15s\033[m%s\n" ${name[i]} ${path[i]}
		fi
	done | sed "s $HOME ~ g"

	unset name path i opt
}

function _bookmark_regist() {
	[ ! -e $bookmarklist ] && touch $bookmarklist

	local opt=

	for opt in "$@"
	do
		case "$opt" in
			'-h'|'--help' )
				_bookmark_usage ${FUNCNAME##*_}
				return $exit_usage
				;;
			'-t'|'--temp' )
				shift 1 
				local -i option_t=1
				;;
			'--' )
				shift 1
				param+=( "$@" )
				break
				;;
			-*)
				echo "${FUNCNAME##*_}: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
				return 1
				;;
		esac
	done

	local -i limit=$(( $( stty 'size' <'/dev/tty' | cut -d' ' -f1 ) - 2 ))
	[ $( wc -l <$bookmarklist ) -ge $limit ] && {
		echo "The maximum number that can enroll in a bookmark-list is $limit cases."
		return 1
	}

	local -i i=
	local name=

	[ $# -eq 0 ] && name=${PWD##*/} || name="$1"
	[ ${#name} -gt 14 ] && { echo "Please input 14 characters or less."; return 1; }

	if awk '{print $1}' $bookmarklist | command grep -w "$name" >/dev/null; then
		echo "$name: Already exist"
		return 1
	else
		[ "$option_t" ] && printf "%-15s%s\n" $name $(pwd) >>$bookmarktemp
		printf "%-15s%s\n" $name $(pwd) >>$bookmarklist
		return 0
	fi
	unset limit i name opt option_t
}

function _bookmark_go() {
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _bookmark_usage ${FUNCNAME##*_}; return $exit_usage; }

	local name=$( awk '{print $1}' $bookmarklist | command grep -w -E "^$1$" )
	local path=$( awk '$1 ~ /'^$1'$/' $bookmarklist | awk '{print $2}' )

	if [ $# -eq 0 ]; then
		echo "${FUNCNAME##*_}: too few arguments"
		echo "Try '${FUNCNAME##*_} --help' for more information."
		return 1
	else
		# case of unregistered
		if [ -z "$name" ]; then
			echo "$1: No such path in $(basename $bookmarklist)"
			return 1
		# case of registered
		else
			if cd "$path" 2>/dev/null; then
				echo "$(date '+%Y-%m-%d %H:%M:%S')	$1" >>$bookmarklog
				# case of -t option
				if [ -f $bookmarktemp ]; then
					if awk '{print $2}' $bookmarktemp | grep -x $path >/dev/null; then
						_bookmark_delete $name
						sed -i '' "/^$1$/d" $bookmarktemp
					fi
				fi
				return 0
			else
				# case of not existing
				echo "$path: an invalid pass"
				_bookmark_delete "$name"
				echo "$name: Deleted now"
				return 1
			fi
		fi
	fi
	unset name path
}

function _bookmark_print() {
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _bookmark_usage ${FUNCNAME##*_}; return $exit_usage; }

	local name=$( awk '{print $1}' $bookmarklist | command grep -w -E "^$1$" )
	local path=$( awk '$1 ~ /'^$1'$/' $bookmarklist | awk '{print $2}' )

	if [ $# -eq 0 ]; then
		echo "${FUNCNAME##*_}: too few arguments"
		echo "Try '${FUNCNAME##*_} --help' for more information."
		return 1
	else
		if [ -z "$name" ]; then
			echo "$1: No such path in $(basename $bookmarklist)"
			return 1
		else
			if ( cd "$path" >/dev/null 2>&1 ); then
				echo "$path"
				return 0
			else
				echo "$path: an invalid pass"
				_bookmark_delete "$name"
				echo "$name: deleted"
				return 1
			fi
		fi
	fi
	unset name path
}

function _bookmark_delete() {
	[ ! -e $bookmarklist ] && { echo "$(basename $bookmarklist): No exist"; return 1; }
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _bookmark_usage ${FUNCNAME##*_}; return $exit_usage; }
	[ "$1" = "-r" ] || [ "$1" = "--refresh" ] && { _bookmark_refresh; return 0; }

	[ ! -s $bookmarklist ] && { echo "$(basename $bookmarklist) is empty."; return 1; }
	[ $# -eq 0 ] && {
		echo "${FUNCNAME##*_}: too few arguments"
		echo "Try '${FUNCNAME##*_} --help' for more information."
		return 1
	}

	local    f=
	local -i i=

	for f do
		local -a name=( $( awk '{print $1}' $bookmarklist | command grep -ivw -E "^$f" ) )
		local -a path=( $( command grep -ivw -E "^$f" $bookmarklist | awk '{print $2}' ) )

		if awk '{print $1}' $bookmarklist | command grep -w -E "^$f" >/dev/null; then
			# (main) delete from list
			for (( i=0; i < ${#name[*]}; i++ )); do
				printf "%-15s%s\n" ${name[i]} ${path[i]}
			done >$bookmarklist

			# delete the history
			sed -i '' "/"$'\t'"$f$/d" $bookmarklog 2>/dev/null

			# case of using -t option
			if [ -f $bookmarktemp ]; then
				if awk '{print $1}' $bookmarktemp | grep -w "$f" >/dev/null; then
					sed -i '' "/^$f/d" $bookmarktemp
				fi
			fi
		else
			echo "$1: No such path in $(basename $bookmarklist)"
			return 1
		fi
		unset f i name path
	done
}

function _bookmark_refresh() {
	local -i i=
	local -i count=0
	local -a name=( $( awk '{print $1}' $bookmarklist ) )
	local -a path=( $( awk '{print $2}' $bookmarklist ) )
	local -r line=$( wc -l <$bookmarklist )
	local -a str=()
	
	for ((i=0; i<"$line"; i++)); do
		if [ -d "${path[i]}" ]; then
			let count++
		else
			_bookmark_delete "${name[i]}"
			#str+="${name[i]}"
			str=("${str[@]}" "${name[i]}")
		fi
	done

	if [ $count -eq $line ]; then
		echo "All paths are available."
		return 1
	else
		#_bookmark_show
		echo "Non-existing ${#str[*]} items have been removed."
		echo "${#str[@]}: ${str[@]}"
		return 0
	fi

	unset i count name path line
}

function _bookmark_candidacy() {
	[ ! -f $bookmarklist ] && return 1
	echo $( awk '{print $1}' $bookmarklist )
}

function _bookmark_complement() {
	local curw
	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $( compgen -W '`_bookmark_candidacy`' -- $curw ) )
	return 0
}

[ -d $bookmarkdir ] && unset _bookmark_initialize || _bookmark_initialize

alias bashmark='_bookmark_usage'
alias show='_bookmark_show'
alias reg='_bookmark_regist'
alias go='_bookmark_go'
alias del='_bookmark_delete'
alias p='_bookmark_print'

complete -F _bookmark_complement go
complete -F _bookmark_complement del
complete -F _bookmark_complement p

