#!/bin/bash

#
# Install Golang for Linux
#

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# This script is only supported with Linux
if ! is_linux; then
    log_fail "error: require: linux"
    exit 1
fi

uri="https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz"
tar="${uri##*/}"
grt="/usr/local/go"
dir="go"

# exit with true if you have go command
if has "go"; then
    log_pass "go: already installed"
    exit
fi

if has "wget"; then
    dler="wget"
elif has "curl"; then
    dler="curl -O"
else
    log_fail "error: require: wget or curl" 1>&2
    exit 1
fi

# Cleaning
command mv -f "$grt"{,.$$} 2>/dev/null && :
command mv -f "$tar"{,.$$} 2>/dev/null && :
command mv -f "$dir"{,.$$} 2>/dev/null && :

# Downloading
log_echo "Downloading golang..."
eval "$dler" "$uri"
if [ $? -eq 0 -a -f "$tar" ]; then
    log_echo "Unzip $tar ..."
    tar xzf "$tar"
else
    log_fail "error: failed to download from $uri" 1>&2
    exit 1
fi

if [ ! -d "$dir" ]; then
    log_fail "error: failed to expand $dir directory" 1>&2
    exit 1
fi

# Installing
command cp -f -v "$dir"/bin/go "${PATH%%:*}"
command mv -f -v "$dir" "$grt"
command rm -f -v "$tar"

# Result
if eval "${PATH%%:*}/go version"; then
    log_pass "go: installed successfully"
else
    log_fail "go: failed to install golang"
    exit 1
fi
