#!/bin/bash
# debris.sh ($HOME/.debris)

Y=`date '+%Y'`
y=`date '+%y'`
m=`date '+%m'`
D=`date '+%d'`
H=`date '+%H'`
M=`date '+%M'`
S=`date '+%S'`
DIR=$Y/$m/$D

if [[ $# -eq 0 ]]; then
	echo "usage: $(basename ${0%.*}) files to trash..."
	exit 1
fi

[ -e "$HOME/.debris/$DIR" ] || mkdir -p "$HOME/.debris/$DIR" || {
	echo "Could not create ~/.debris/$DIR"
	exit 1
}

# This function is a part performing a thing about the elimination
error=""
for path do
	# Checking if the file you want to delete exists
	if [[ -e "$path" ]]; then
		fname=$(basename "$path")
		in_trash="$HOME/.debris/$DIR/${fname}.${H}_${M}_${S}"

		# Transport files from current to trash
		if mv "$path" "$in_trash"; then
			: # If you successed
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

[ -n "$ERROR" ] && exit 1
exit 0
