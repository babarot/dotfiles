MV='/bin/mv'

Safety_rm()
{
	local trash_root=~/.rmtrash
	local trash=$trash_root/$(date '+%Y/%m/%d')
	local log=$trash_root/rmlog

	if [ ! -d $trash ]; then
		mkdir -p $trash
		if [ $? -ne 0 ]; then
			echo "$trash: could not create"
			return 1
		fi
	fi

	local path=
	for path in "$@"
	do
		if [ -e "$path" ]; then
			in_trash="$trash/${path##*/}.$(date '+%H_%M_%S')"

			if "$MV" -f "$path" "$in_trash"; then
				echo -e "$(date '+%Y-%m-%d %H:%M:%S') $(cd $(dirname $path) && pwd)/${path##*/} $in_trash" >>"$log"
			else
				echo "$path: could not move to trash" >&2
				error=1
			fi
		else
			echo "$path: not exist" >&2
			error=1
		fi
	done

	if [ "$error" ]; then
		return 1;
	else
		return 0;
	fi
}

Safety_rm "$@"
