#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

if [ -z "$DOTPATH" ]; then
    # shellcheck disable=SC2016
    echo '$DOTPATH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
#while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
while true
do
    sudo -n true
    sleep 60;
    kill -0 "$$" || exit
done 2>/dev/null &

# main

# shellcheck disable=SC2102
for i in "$DOTPATH"/etc/init/"$(get_os)"/*[^init].sh
do
    if [ "${DEBUG:-}" = 1 ]; then
        echo "$i"
    else
        bash "$i"
    fi
done || true

e_done "$0: Finish!!"
