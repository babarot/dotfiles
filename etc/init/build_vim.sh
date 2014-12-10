#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

echo -n "Rebuild vim? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    ./vimbuild
fi
