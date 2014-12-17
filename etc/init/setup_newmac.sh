#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

if [[ $OSTYPE == darwin* ]]; then
    for file in $(echo $(dirname ${BASH_SOURCE})/osx/*.sh)
    do
        bash "$file" || true
    done
fi
