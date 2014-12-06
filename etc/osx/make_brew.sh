#!/bin/bash

trap "echo Error: $0: stopped" ERR
set -e
set -u

echo -n "Brewfile? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash ./Brewfile
fi

echo -n "Caskfile? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    bash ./Caskfile
fi
