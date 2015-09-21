#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

if [ -z "$DOTPATH" ]; then
    # shellcheck disable=SC2016
    echo '$DOTPATH not set' >&2
    exit 1
fi

link_sh() {
    log_echo "Any files ending in *.sh get symlinked into '$1'"

    # Change to platform directory
    builtin cd "$1"

    # Link sh files
    for i in ../common/*.sh
    do
        # overwritte if already exists
        ln -svf "$i" *${i##*/}
    done

    builtin cd "$OLDPWD"
}

link_sh "osx"
link_sh "linux"
