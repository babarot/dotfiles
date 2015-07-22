#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if has "go"; then
    if [ -z "${GOPATH:-}" ]; then
        GOPATH=$HOME
    fi
    go get -u github.com/b4b4r07/gotcha
else
    if has "curl"; then
        curl -L git.io/gotcha | sh
    elif has "wget"; then
        wget -O - git.io/gotcha | sh
    else
        die "require: go, curl or wget"
    fi
fi

if has "gotcha"; then
    cd "$DOTPATH"/etc/init/assets/go
    if [ -f config.toml ]; then
        gotcha --verbose
    else
        die "something is wrong"
    fi
else
    die "gotcha: not found"
fi
