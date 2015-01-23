#!/bin/bash

trap 'echo Error: $0: stopped' ERR
set -e
set -u

#
# A system that judge if this script is necessary or not
# {{{
is_osx() { [[ "$OSTYPE" =~ ^darwin ]] || return 1; }
is_ubuntu() { [[ "$(cat /etc/issue 2>/dev/null)" =~ Ubuntu ]] || return 1; }
if ! is_osx || ! is_ubuntu; then exit; fi
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

echo -n "Translate home directory into English? (y/N) "
read
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if is_osx; then
        rm -vf ~/Desktop/.localized
        rm -vf ~/Documents/.localized
        rm -vf ~/Downloads/.localized
        rm -vf ~/Library/.localized
        rm -vf ~/Movies/.localized
        rm -vf ~/Music/.localized
        rm -vf ~/Pictures/.localized
        rm -vf /Applications/.localized

        error=0
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
    elif is_ubuntu; then
        LANG=C xdg-user-dirs-gtk-update
    fi
fi

# vim:fdm=marker
