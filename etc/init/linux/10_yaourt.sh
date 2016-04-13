#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# This script is only supported with Linux
if ! is_linux; then
    log_fail "error: this script is only supported with linux"
    exit 1
fi

if has "yaourt"; then
    log_pass "yaourt: already installed"
    exit
fi

# The script is dependent on ruby
if ! has "pacman"; then
    log_fail "error: require: pacman"
    exit 1
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if has "brew"; then
    brew doctor
else
    log_fail "error: brew: failed to install"
    exit 1
fi

log_pass "yaourt: installed successfully"
