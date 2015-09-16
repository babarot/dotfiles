#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

if has "pygmentize"; then
    log_pass "pygmentize: already installed"
    exit
fi

# The script is dependent on pip
if ! has "pip"; then
    log_fail "error: require: pip"
    exit 1
fi

if ! has "pygmentize"; then
    if sudo pip install Pygments; then
        log_pass "pygmentize: installed successfully"
    else
        log_fail "error: pygmentize: failed to install"
    fi

    log_echo "install pygments-style-solarized ..."
    #pip install pygments-style-solarized
fi

#if builtin cd "$DOTPATH"/etc/init/assets/pygments/solarized-pygment; then
#    git submodule update
#    sudo ./setup.py install
#fi
