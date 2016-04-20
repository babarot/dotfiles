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
    builtin cd "$DOTPATH"/etc/init/assets/pacman
    if [ ! -f pkglist ]; then
        log_fail "error: pkglist does not exist"
        exit 1
    fi

    log_echo "Installing packages with Yaourt"
    yaourt -S --noconfirm --needed - < pkglist
else
    log_fail "error: require: yaourt"
    exit 1
fi

log_pass "yaourt: packages installed successfully"
