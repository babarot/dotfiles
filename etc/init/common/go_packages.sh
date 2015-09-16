#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have Gotcha command,
# to install it with optimal method.
if ! has "gotcha"; then
    # With go command
    if has "go"; then
        log_echo "Install gotcha command form go get!"
        if [ -z "${GOPATH:-}" ]; then
            export GOPATH=$HOME
        fi
        go get -u github.com/b4b4r07/gotcha
    else
        # With git.io/gotcha
        log_echo "Install gotcha command from git.io/gotcha!"

        # curl / wget
        if has "curl"; then
            curl -L   git.io/gotcha | bash
        elif has "wget"; then
            wget -O - git.io/gotcha | bash
        else
            log_fail "error: require: go, curl or wget"
            exit 1
        fi
    fi
fi

# Append the GOPATH/bin to the PATH
if [ -x "${GOPATH%%:*}"/bin/gotcha ]; then
    PATH="${GOPATH%%:*}/bin:$PATH"
    export PATH
fi

# It should be able to use Gotcha command if its installation is success
if has "gotcha"; then
    log_echo "Grab go packages"
    gotcha --verbose "$DOTPATH"/etc/init/assets/go/config.toml
else
    log_fail "error: gotcha: not found"
    exit 1
fi

log_pass "Gotcha!"
