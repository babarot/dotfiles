#!/bin/bash

#
# Install Golang for OS X
#

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# This script is only supported with Linux
if ! is_osx; then
    log_fail "error: require: osx"
    exit 1
fi

# exit with false if you have brew command
if has "brew"; then
    log_pass "brew: already installed"
    exit 1
fi

brew install go
if has "go"; then
    log_pass "go: installed successfully"
else
    log_fail "go: failed to install golang"
    exit 1
fi
