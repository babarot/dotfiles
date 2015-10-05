#!/bin/bash

# List commands within $DOTPATH/bin
for f in $DOTPATH/bin/*
do
    # check if $f is executable shell script file
    f="$(file "$f" | awk -F: '$2 ~ /shell script/{print $1}')"

    # If ok, add to the array
    if [ -n "$f" ]; then
        array=("${array[@]}" "$f")
    fi
done

# edit
$EDITOR "${array[@]}"
