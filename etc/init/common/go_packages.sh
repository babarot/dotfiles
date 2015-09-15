#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! has "gotcha"; then
    if has "go"; then
        log_echo "install gotcha form go"
        if [ -z "${GOPATH:-}" ]; then
            GOPATH=$HOME
            export GOPATH
        fi
        go get -u github.com/b4b4r07/gotcha
        if [ $? -eq 0 ]; then
            PATH=$GOPATH/bin:$PATH
            export PATH
        else
            log_fail "go get: exit status is not true"
            exit 1
        fi
    else
        log_echo "Download and install gotcha"
        if has "curl"; then
            curl -L git.io/gotcha | sh
        elif has "wget"; then
            wget -O - git.io/gotcha | sh
        else
            log_fail "require: go, curl or wget"
            exit 1
        fi
    fi
fi

if has "gotcha"; then
    cd "$DOTPATH"/etc/init/assets/go
    if [ -f config.toml ]; then
        log_echo "Grab go packages"
        gotcha --verbose
    else
        log_fail "something is wrong"
        exit 1
    fi
else
    log_fail "gotcha: not found"
    exit 
fi

log_pass "Gotcha!"
