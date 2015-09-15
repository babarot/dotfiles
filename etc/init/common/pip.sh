#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

log_info "Install pip/easy_install and some python tools"

# error variable
err=0

if ! has "easy_install"; then
    if sudo yum install -y python-setuptools; then
        log_pass "easy_install: installed successfully"
    else
        log_fail "error: easy_install: failed to install"
        err=1
    fi
fi

if ! has "pip"; then
    if sudo yum install -y pip; then
        log_pass "pip: installed successfully"
    else
        log_fail "error: pip: failed to install"
        err=1
    fi
fi

if ! has "diff-highlight"; then
    if sudo pip install diff-highlight; then
        log_pass "diff-highlight: installed successfully"
    else
        log_fail "error: diff-highlight: failed to install"
        err=1
    fi
fi

if ! has "pygmentize"; then
    if sudo pip install Pygments; then
        log_pass "pygmentize: installed successfully"
    else
        log_fail "error: pygmentize: failed to install"
        err=1
    fi
fi

if [ "$err" = 0 ]; then
    log_pass "All python tools are installed successfully"
else
    exit 1
fi
