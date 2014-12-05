#!/bin/bash

set -e
set -u

echo ''
echo '     | |     | |  / _(_) |           '
echo '   __| | ___ | |_| |_ _| | ___  ___  '
echo '  / _` |/ _ \| __|  _| | |/ _ \/ __| '
echo ' | (_| | (_) | |_| | | | |  __/\__ \ '
echo '  \__,_|\___/ \__|_| |_|_|\___||___/ '
echo ''

declare dotfiles=~/.dotfiles
declare msg=$(
cat <<-EOF
By executing ./bootstrap.sh, the following commands are run
\t1. git clone https://github.com/b4b4r07/dotfiles
\t2. make deploy
\n
Author: b4b4r07 aka BABAROT <b4b4r07@gmail.com>
EOF
)

echo -e "$msg";
if [[ "$0" =~ "bootstrap.sh" ]]; then
    echo "That this file is started directly is not recommended";
else
    if [ -d "$dotfiles" ]; then
        cd "$dotfiles" && git pull --rebase
    else
        if type git >/dev/null 2>&1; then
            git clone https://github.com/b4b4r07/dotfiles.git "$dotfiles"
        else
            cd /tmp
            curl -LSfs -o dotfiles.zip https://github.com/b4b4r07/dotfiles/archive/master.zip
            unzip -oq dotfiles.zip
            mv dotfiles-master ~/.dotfiles
        fi
        cd "$dotfiles"
        make deploy
        echo ""; make help
        echo ""
        exec ${SHELL:-/bin/bash}
    fi

    git submodule init
    git submodule update
fi
echo "$0"
echo "$(basename $0)"
