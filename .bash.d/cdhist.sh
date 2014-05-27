#   @(#) Directory history manager on bash.
#
#   Name:     cdhist.sh
#   Author:   b4b4r07 <b4b4r07@gmail.com>
#   URL:      https://github.com/b4b4r07/cdhist
#             (see this url for latest release & screenshots)
#   License:  OSI approved MIT license
#   Created:  Tue Sep 3 01:33:53 2013 +0900
#   Modified: 
#
#   Copyright (c) 2013, b4b4r07
#   All rights reserved.
#
###################################################################################################################

[ "$BASH_VERSION" ] || return 1

declare -r cdhistlist=~/.cdhistlog
declare -i CDHIST_CDQMAX=10
declare -a CDHIST_CDQ

function _cdhist_initialize() {
	OLDIFS=$IFS
	IFS=$'\n'
	
	#local -a mylist=( $( tail -r $cdhistlist ) )
	local -a mylist=( $( cat $cdhistlist ) )
	local -a temp=()
	local -i i=count=0
	
	#for ((i=0; i<${#mylist[*]}; i++)); do
	#	if ! echo "${temp[*]}" | grep -x "${mylist[i]}" >/dev/null; then
	#		temp[i]="${mylist[i]}"
	#		CDHIST_CDQ[$count]="${mylist[i]}"
	#		let count++
	#		[ $count -eq $CDHIST_CDQMAX ] && break
	#	fi
	#done
	for ((i=${#mylist[*]}-1; i>=0; i--)); do
		if ! echo "${temp[*]}" | grep -x "${mylist[i]}" >/dev/null; then
			temp[$count]="${mylist[i]}"
			CDHIST_CDQ[$count]="${mylist[i]}"
			let count++
			[ $count -eq $CDHIST_CDQMAX ] && break
		fi
	done
	
	IFS=$OLDIFS
}

function _cdhist_reset() {
	CDHIST_CDQ=( "$PWD" )
}

function _cdhist_disp() {
	echo "$*" | sed "s $HOME ~ g"
}

function _cdhist_add() {
	CDHIST_CDQ=( "$1" "${CDHIST_CDQ[@]}" )
}

function _cdhist_del() {
	local i=${1:-0}
	if [ ${#CDHIST_CDQ[@]} -le 1 ]; then return; fi
	for ((; i<${#CDHIST_CDQ[@]}-1; i++)); do
		CDHIST_CDQ[$i]="${CDHIST_CDQ[$((i+1))]}"
	done
	unset CDHIST_CDQ[$i]
}

function _cdhist_rot() {
	local i q
	for ((i=0; i<$1; i++)); do
		q[$i]="${CDHIST_CDQ[$(((i+$1+$2)%$1))]}"
	done
	for ((i=0; i<$1; i++)); do
		CDHIST_CDQ[$i]="${q[$i]}"
	done
}

function _cdhist_cd() {
	local i f=0
	builtin cd "$@" && pwd >>$cdhistlist || return 1
	for ((i=0; i<${#CDHIST_CDQ[@]}; i++)); do
		if [ "${CDHIST_CDQ[$i]}" = "$PWD" ]; then f=1; break; fi
	done
	if [ $f -eq 1 ]; then
		_cdhist_rot $((i+1)) -1
	elif [ ${#CDHIST_CDQ[@]} -lt $CDHIST_CDQMAX ]; then
		_cdhist_add "$PWD"
	else
		_cdhist_rot ${#CDHIST_CDQ[@]} -1
		CDHIST_CDQ[0]="$PWD"
	fi
}

function _cdhist_history() {
	local i d
	[ "$1" -eq 0 ] 2>/dev/null
	[ $? -ge 2 -a "$1" != "" ] && return 1
	if [ $# -eq 0 ]; then
		for ((i=${#CDHIST_CDQ[@]}-1; 0<=i; i--)); do
			_cdhist_disp " $i ${CDHIST_CDQ[$i]}"
		done
	elif [ "$1" -lt ${#CDHIST_CDQ[@]} ]; then
		d=${CDHIST_CDQ[$1]}
		if builtin cd "$d" && pwd >>$cdhistlist; then
			_cdhist_rot $(($1+1)) -1
		else
			_cdhist_del $1
		fi
	fi
}

function _cdhist_forward() {
	_cdhist_rot ${#CDHIST_CDQ[@]} -${1:-1}
	if ! builtin cd "${CDHIST_CDQ[0]}"; then
		_cdhist_del 0
	else
		pwd >>$cdhistlist
	fi
}

function _cdhist_back() {
	_cdhist_rot ${#CDHIST_CDQ[@]} ${1:-1}
	if ! builtin cd "${CDHIST_CDQ[0]}"; then
		_cdhist_del 0
	else
		pwd >>$cdhistlist
	fi
}

function cd { _cdhist_cd "$@"; }
function +  { _cdhist_forward "$@"; }
function -  { _cdhist_back "$@"; }
#function =  { _cdhist_history "$@"; }
function =  { 
	if expr "$1" : '[0-9]*' > /dev/null ; then
		# if 1..9
		_cdhist_history "$@"
	else
		# if a..z
		if [ $# -eq 0 ]; then
			_cdhist_history "$@"
		elif [ $# -eq 1 ]; then
			if [ $(_cdhist_history | grep -i "$1" | wc -l) -eq 1 ]; then
				cd $(_cdhist_history | grep -i "$1" | awk /$2/'{print $2}' | sed "s ~ $HOME g")
			else
				_cdhist_history | grep -i "$1"
			fi
		else
			cd $(_cdhist_history | grep -i "$1" | awk /$2/'{print $2}' | sed "s ~ $HOME g")
		fi

	fi
}

if [ -f $cdhistlist ]; then
	_cdhist_initialize
	unset -f _cdhist_initialize
	cd $HOME
else
	_cdhist_reset
fi

############################################################

_cdhist_list ()
{
	shift
	if [ -z "$1" ]; then
		sort $cdhistlist | uniq -c | sort -nr | head | sed "s $HOME ~ g"
	else
		_cdhist_cd $(sort $cdhistlist | uniq -c | sort -nr | head | nl | awk '{if($1=='$1') print $3}' | sed "s ~ $HOME g")
	fi
}

_cdhist_about ()
{
	local i=
	local result_even=/tmp/result.$$
	local result_odd=/tmp/result.$$2

	sort $cdhistlist | uniq | grep -i "$1" >$result_even
	sort $cdhistlist | uniq | grep -i "$1" >$result_odd
	
	shift
	for i in "$@"
	do
		if [ `expr $# % 2` == 0 ]; then
			awk '/\/'"$i"'/' $result_even >$result_odd
		else
			awk '/\/'"$i"'/' $result_odd >$result_even
		fi
		shift
	done 
	
	a=`wc -l $result_even | awk '{print $1}'`
	b=`wc -l $result_odd | awk '{print $1}'`
	
	if [ $a -lt $b ]; then
		cat $result_even
	else
		cat $result_odd
	fi | sed "s $HOME ~ g" | tr '\/' ' '
	
	command rm -r $result_even $result_odd
}

cd ()
{
	if [ "$1" = '-l' -o "$1" = '--most-used' ]; then
		_cdhist_list "$@"
		return 0
	#elif [ "$1" = '-a' -o "$1" = '--about' ]; then
	#	_cdhist_about "$@"
	#	return 0
	fi
	_cdhist_cd "$@"
}

if [ "$enable_auto_cdls" ]; then
	auto_cdls()
	{
		if [ "$OLDPWD" != "$PWD" ]; then
			ls
			OLDPWD="$PWD"
		fi
	}
	PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'auto_cdls
fi
