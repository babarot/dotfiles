#!/bin/sh

FILE="$HOME/.fetch_dir"

if [ -f $FILE ]; then
	:> $FILE
fi

auto_fetch()
{
	if [ -d $PWD/.git ]; then
		if ! grep $PWD $FILE >/dev/null; then
			echo "$PWD" >> $FILE
			git fetch
		fi
	fi
}
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'auto_fetch
