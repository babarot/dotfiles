#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# This script is dependent on git
if ! has "git"; then
    log_fail "error: require: git"
    exit 1
fi

# exit with true if you have rbenv
if has "rbenv"; then
    log_pass "rbenv: already installed"
    exit
fi

uri="https://github.com/rbenv/rbenv.git"
tar="${uri##*/}"
dir="$HOME/${tar%.*}"

log_echo "Cloning rbenv repository..."j
eval git clone "$uri" "$dir" 2>/dev/null && :
if [ $? -ne 0 ]; then
    log_fail "error: failed to clone rbenv repository"
    exit 1
fi

log_echo "Compiling dynamic bash extension..."
eval builtin cd "$dir" && src/configure && make -C src 2>/dev/null && :
if [ $? -ne 0 ]; then
    log_fail "error: failed to compile dynamic bash extension"
    exit 1
fi

uri="https://github.com/rbenv/ruby-build.git"
tar="${uri##*/}"
dir="$dir/plugins/${tar%.*}"

log_echo "Cloning rbenv-build repository..."j
eval git clone "$uri" "$dir" 2>/dev/null && :
if [ $? -ne 0 ]; then
    log_fail "error: failed to clone rbenv-build repository"
fi

export PATH="$dir/bin:$PATH"
eval "$(rbenv init -)"

# exit with true if you have ruby
if has "ruby"; then
    log_pass "ruby: already installed"
    exit
fi

ver=eval "${PATH%%:*}/rbenv install -l | grep -P '^\s+\d[.]\d[.]\d$' | tail -1"

log_echo "Installing Ruby $ver"
if eval "${PATH%%:*}/rbenv install $ver"; then
    log_pass "ruby: installed successfully"
else
    log_fail "ruby: failed to install ruby"
    exit 1
fi
