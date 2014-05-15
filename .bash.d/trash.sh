#!/bin/sh

# trash.sh ($HOME/.trash)

if [ $# -eq 0 ]; then
	echo "usage: trash files to trash..."
	exit 1
fi

# if you dont use [test -e]
if /bin/sh -c 'test -e "$0"' 2>/dev/null; then
	command=""
else
	command="command"  # Solaris
fi

# $HOME/.trash does not exist
if [ ! -d ~/.trash ]; then
	mkdir ~/.trash
fi
DATE=`date "+%y%m%d"`
if [ ! -d ~/.trash/$DATE ]; then
	mkdir ~/.trash/$DATE
fi

#$command [ -e "$HOME/.trash" ] || mkdir "$HOME/.trash" || {
#	echo "Could not create ~/.trash"
#	exit 1
#}

# to deal with removing
error=""
for path do  # all arguments

	# check whether files (which are) subject to remove exist or not
	if $command [ -e "$path" ]; then

		# if the files exist
		# check the same name in trash
		fname=`basename "$path"`
		in_trash="$HOME/.trash/$DATE/$fname"
		suffix=0
		while $command [ -e $in_trash ]; do
			# if the same name exists
			# add incriment numbers at the end of filename
			in_trash="$HOME/.trash/$DATE/${fname}.${suffix}"
			suffix=`expr $suffix + 1`
		done

		# move files to trash
		if mv "$path" "$in_trash"; then
			# if you successed
			:
		else
			# if you dont successed
			echo "$path: could not move to trash" >&2
			error="YES"
		fi

	else
		# if files dont exist
		# display error messages
		echo "$path: not exist" >&2
		error="YES"
	fi
done

[ -n "$ERROR" ] && exit 1 # if error arise
exit 0
