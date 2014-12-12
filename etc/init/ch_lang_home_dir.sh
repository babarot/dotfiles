#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

echo -n "Translate home directory into English? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if [[ $OSTYPE == linux* ]]; then
        LANG=C xdg-user-dirs-gtk-update

    elif [[ $OSTYPE == darwin* ]]; then
        sudo -v
        # CF: http://qiita.com/is0me/items/0b7b846f1f0860629950
        if [ $(echo "$(sw_vers -productVersion | cut -d . -f1,2) > 10.8" | bc) -eq 1 ]; then
            cd /System/Library/CoreServices/SystemFolderLocalizations/ja.lproj
        else
            cd /System/Library/CoreServices/SystemFolderLocalizations/Japanese.lproj
        fi

        mv SystemFolderLocalizations.strings SystemFolderLocalizations.strings.back
        cp ../en.lproj/SystemFolderLocalizations.strings .

        killall Finder
    fi
fi
