#                                                                     
#                     .o8  oooo         o8o               .           
#                    "888  `888         `"'             .o8           
#      .ooooo.   .oooo888   888 .oo.   oooo   .oooo.o .o888oo         
#     d88' `"Y8 d88' `888   888P"Y88b  `888  d88(  "8   888           
#     888       888   888   888   888   888  `"Y88b.    888           
#     888   .o8 888   888   888   888   888  o.  )88b   888 .         
#     `Y8bod8P' `Y8bod88P" o888o o888o o888o 8""888P'   "888"         
#                                                                     
######################################################################
# 
# Cdhist adds 'web-browser like history' to your BASH shell.          
# Every time you change the current directory it records the          
# directory you can go back by simply typing a short command          
# such as '-' or '+', just like clicking web-browsers's 'back' button.
# It's more convenient than using directory stacks                    
# when you walk around two or three directories.                      
# 
if [ -z "$BASH_VERSION" ]; then
	echo "Require bash"
	exit 1
fi

# Declare and initialize a variable
declare    CDHIST_CDLOG="$HOME/.cdhistlog"
declare -i CDHIST_CDQMAX=10
declare -a CDHIST_CDQ=()

# Loading configure file about cdhist, if exist
if [ -f ~/.cdhist.conf ]; then
	source ~/.cdhist.conf
fi

# Enable/disable this script
if [ "$disable_cdhist" ]; then
	return
fi

# Enable after cd automatically
function do_eachtime_cd() {
	if [ "$OLDPWD" != "$PWD" ]; then
		# enable ls after cd, if $enable_auto_cdls exist
		[ "$disable_auto_cdls" ] || ls
		pwd >>$CDHIST_CDLOG
		OLDPWD="$PWD"
	fi
}
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'do_eachtime_cd

############################################################################################
#                                                                                          #
# These are the function group that users operate INDIRECTLY.                              #
# Declare functions that manipulate the data structure in this cdhist.                     #
# *_cdhist_usage:      how to use cdhist                                                   #
# *_cdhist_initialize: when loading cdhist, assign a recent cd-history to the CDHIST_CDQ   #
# *_cdhist_reset:      if CDHIST_CDQMAX do not exist, initialize the CDHIST_CDQ            #
# *_cdhist_disp:       view HOME as ~                                                      #
# *_cdhist_add:        add rear of CDHIST_CDQ                                              #
# *_cdhist_del:        delete rear of CDHIST_CDQ                                           #
# *_cdhist_rot:        rotate the CDHIST_CDQ                                               #
# *_cdhist_cd:         cd function in cdhist script                                        #
# *_cdhist_history:    listup the CDHIST_CDQ                                               #
# *_cdhist_forward:    cd +: advance PWD                                                   #
# *_cdhist_back:       cd -: return PWD(OLDPWD)                                            #
# *_cdhist_list:       enumerate path high number of uses                                  #
# *_cdhist_narrow:     search path from CDHIST_CDLOG                                       #
#                                                                                          #
############################################################################################

function _cdhist_usage() {
	echo -e "cd [OPTION] path\n"
	echo -e "\t-h\t\tdisplay this help"
	echo -e "\t-s word\t\tnarrow down from the past movement history"
	echo -e "\t\t\trepeat all the given arguments until it is gone"
	echo -e "\t-l [num]\tlist up a high number of uses"
	echo -e "\t\t\tmove to the path of argument\n"
}

function _cdhist_initialize() {
	OLDIFS=$IFS; IFS=$'\n'
	
	local -a mylist=( $( cat $CDHIST_CDLOG ) )
	local -a temp=()
	local -i i=count=0

	# I want to do 'sort $CDHIST_CDLOG | uniq | tail 10'
	# However, if I do that, the order of the lasted log file is messed up.
	# The following for-loop execute "uniq" disposal without "sort".
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
	builtin cd "$@" || return 1
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
		if builtin cd "$d"; then
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
	fi
}

function _cdhist_back() {
	_cdhist_rot ${#CDHIST_CDQ[@]} ${1:-1}
	if ! builtin cd "${CDHIST_CDQ[0]}"; then
		_cdhist_del 0
	fi
}

function _cdhist_list() {
	if [ -z "$1" ]; then
		sort $CDHIST_CDLOG | uniq -c | sort -nr | head | sed "s $HOME ~ g" | awk '{printf "%-50s (%4d)\n", $2, $1}' | nl
	else
		if [ $1 -le 10 ]; then
			_cdhist_cd $(sort $CDHIST_CDLOG | uniq -c | sort -nr | head | nl | awk '{if($1=='$1') print $3}' | sed "s ~ $HOME g")
		fi
	fi
}

function _cdhist_narrow() {
	[ -z "$1" ] && {
		echo "too few arguments" 1>&2
		return 1
	}

	local db=$(sort $CDHIST_CDLOG | uniq | \grep -i "/\.\?$1")
	shift

	for i do
		if [ "${!#}" = $i ]; then
			if ( expr "${!#}" : '[0-9]*' ) >/dev/null; then
				_cdhist_cd $(echo "${db}" | nl | awk '{if($1=='${!#}') print $2}' | sed "s ~ $HOME g")
				return
			fi
		fi
		db=$(echo "${db}" | \grep -i "/\.\?${i}")
	done

	if [ $(echo "${db}" | wc -l) -eq 1 ]; then
		_cdhist_cd "${db}"
	elif [ $(echo "${db}" | wc -l) -le 10 ]; then
		echo "${db}" | sed "s $HOME ~ g" | nl
	else
		echo "${db}" | sed "s $HOME ~ g"
	fi
}

############################################################################################
#                                                                                          #
# These are the function group that users operate DIRECTLY.                                #
# Using function accutually                                                                #
# * +:  go to the next directory (do _cdhist_forward)                                      #
# * -:  go back to the old directory (do _cdhist_back)                                     #
# * =:  displays the ring buffer of the movement history (do _cdhist_history)              #
# * cd: change directory                                                                   #
#                                                                                          #
############################################################################################

function +() {
	_cdhist_forward "$@";
}

function -() {
	_cdhist_back "$@";
}

function =() { 
	if [ -z "$1" ]; then
		_cdhist_history "$@"
		return 0
	fi
	if expr "$1" : '[0-9]*' >/dev/null; then
		_cdhist_history "$1"
		return
	fi
	if expr "${!#}" : '[0-9]*' >/dev/null; then
		_cdhist_history "${!#}"
		return
	fi

	local db=$(_cdhist_history | \grep -i "/\.\?$1")
	shift
	for i do
		db=$(echo "${db}" | \grep -i "/\.\?${i}")
	done

	if [ $(echo "${db}" | wc -l) -eq 1 ]; then
		_cdhist_cd $(echo "${db}" | awk '{print $2}' | sed "s ~ $HOME g")
	else
		echo "${db}" | sed "s $HOME ~ g"
	fi
}

function cd() {
	_cdhist_cd "$@"
}

function qfind() {
	if [ -z "$1" ]; then
		return 1
	fi
	local IFS=$'\n'
	local array=( $(sort $CDHIST_CDLOG | uniq) )
	
	if [ "$1" == '-n' ]; then
		array=( $(tail -n 100 $CDHIST_CDLOG | sort | uniq) )
		shift
	fi
	
	for i in "${array[@]}"
	do
		find "$i" -maxdepth 1 -type f -name "*$1*" 2>/dev/null
	done | sed "s $HOME ~ g" | \grep --color "$1"
}

function nw() {
	_cdhist_narrow "$@"
}

#
# This is a real practice department in this script
# If $CDHIST_CDLOG exist, substitute $CDHIST_CDLOG records for $CDHIST_CDQ
# Otherwise, execute _cdhist_reset that substitute $PWD for $CDHIST_CDQ
#
if [ -f $CDHIST_CDLOG ]; then
	_cdhist_initialize
	unset -f _cdhist_initialize
	cd $HOME
else
	_cdhist_reset
fi
