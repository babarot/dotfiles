#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# The script is dependent on python
if ! has "python"; then
    log_fail "error: require: python"
    exit 1
fi

if ! has "easy_install"; then
    if sudo yum install -y python-setuptools; then
        log_pass "easy_install: installed successfully"
    else
        log_fail "error: easy_install: failed to install"
        exit 1
    fi
fi

if ! has "pip"; then
    if sudo easy_install pip; then
        log_pass "pip: installed successfully"
    else
        log_fail "error: pip: failed to install"
        exit 1
    fi
fi
