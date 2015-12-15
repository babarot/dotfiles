#!/bin/bash

# initialize
. "$DOTPATH"/etc/lib/corelib.sh
: "${PROC:=16}"

get_list() {
    skip=0
    cat $DOTPATH/etc/init/assets/brew/Brewfile \
        | while read line
    do
        if [[ $line =~ ^brew ]]; then
            echo $line
        fi \
            | sed -e "s/^brew '//g;s/'.*$//g"
    done
}

cnt=0
if [[ -p /dev/stdin ]]; then
    cat <&0
else
    get_list
fi | while read line
do
    echo "Installing $line"
    brew install "$line" >/dev/null &
    # Prevent having too many subprocesses
    (( (cnt += 1) % $PROC == 0 )) && wait
done
wait
