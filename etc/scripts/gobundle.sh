#!/bin/bash

get_list() {
    skip=0
    cat $DOTPATH/etc/init/assets/go/config.toml \
        | while read line
    do
        if [[ $line =~ ^repo ]]; then
            skip=1
            continue
        fi
        [ $skip -eq 0 ] && continue
        [ "$line" = "]" ] && break
        echo $line
    done \
        | sed -e 's/^"//g;s/",$//g'
}

cnt=0
if [[ -p /dev/stdin ]]; then
    cat <&0
else
    get_list
fi | while read line
do
    echo "Installing $line"
    go get -u "$line" &
    # Prevent having too many subprocesses
    (( (cnt += 1) % 4 == 0 )) && wait
done
wait
