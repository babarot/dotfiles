#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

echo -n "Translate home directory into English? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if [[ $OSTYPE == darwin* ]]; then
        rm -vf ~/Desktop/.localized
        rm -vf ~/Documents/.localized
        rm -vf ~/Downloads/.localized
        rm -vf ~/Library/.localized
        rm -vf ~/Movies/.localized
        rm -vf ~/Music/.localized
        rm -vf ~/Pictures/.localized
        rm -vf /Applications/.localized

        declare error=0
        sudo -v

        # cf. http://qiita.com/is0me/items/0b7b846f1f0860629950
        cd /System/Library/CoreServices/SystemFolderLocalizations
        if [[ -d ja.lproj && -d en.lproj ]]; then
            cd ja.lproj
        elif [[ -d Japanese.lproj ]]; then
            cd Japanese.lproj
        else
            error=1
        fi

        if [[ $error -eq 0 ]]; then
            sudo mv SystemFolderLocalizations.strings SystemFolderLocalizations.strings.back
            sudo cp ../en.lproj/SystemFolderLocalizations.strings .
            killall Finder
        fi
    else
        LANG=C xdg-user-dirs-gtk-update
    fi
fi
