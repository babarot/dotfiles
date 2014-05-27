#!/bin/sh

FILE="$HOME/.fetch_dir"

if ! type git >/dev/null 2>&1; then
	echo "This script needs git command!" >/dev/stderr
	exit 1
fi

# Make blank file
:> $FILE

auto_fetch()
{
	CLONE=$( history | tail -n 2 | head -n 1 | grep "git clone" )
	if [ ! -z "$CLONE" ]; then 
		echo "$PWD" >>$FILE
		return
	fi

	if [ -d "$PWD"/.git ]; then
		if ! grep "$PWD" $FILE >/dev/null; then
			echo "$PWD" >>$FILE
			git fetch
		fi
	fi
}
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'auto_fetch
