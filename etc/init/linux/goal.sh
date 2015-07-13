#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! has "goal"; then
    has "go" || sudo yum install -y go
    go get -u github.com/b4b4r07/goal
fi

if cd "$DOTPATH"/etc/init/assets/go; then
    goal
else
    exit 1
fi
