#!/bin/bash

set -e
set -u

echo ''
echo '    | |     | |  / _(_) |           '
echo '  __| | ___ | |_| |_ _| | ___  ___  '
echo ' / _` |/ _ \| __|  _| | |/ _ \/ __| '
echo '| (_| | (_) | |_| | | | |  __/\__ \ '
echo ' \__,_|\___/ \__|_| |_|_|\___||___/ '
echo ''

declare msg='
By executing ./bootstrap.sh, the following commands are run
    1. git clone https://github.com/b4b4r07/dotfiles
    2. make deploy

Author: b4b4r07 aka BABAROT <b4b4r07@gmail.com>
'
echo -e "$msg";

main()
{
    if [[ "$0" =~ $(basename "${BASH_SOURCE:-NONE}") ]]; then
        echo "That this file is started directly is not recommended" 1>&2
        return 1
    fi

    local DOTFILES_PATH=~/.dotfiles
    if [ -d "$DOTFILES_PATH" ]; then
        cd $DOTFILES_PATH
        make update
    else
        if type git >/dev/null 2>&1; then
            # --recursive equals to ...
            # git submodule init
            # git submodule update
            git clone --recursive https://github.com/b4b4r07/dotfiles.git $DOTFILES_PATH
        else
            cd /tmp
            curl -fsSL -o dotfiles.zip https://github.com/b4b4r07/dotfiles/archive/master.zip
            unzip -oq dotfiles.zip
            mv dotfiles-master ~/.dotfiles
        fi

        cd $DOTFILES_PATH
        make deploy

        if [[ "${1:-NONE}" == "install" ]]; then
            echo ''
            make install
        fi

        exec ${SHELL:-/bin/bash}
    fi
}

main "$@"
