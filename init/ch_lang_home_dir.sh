#!/bin/bash

trap "echo; exit 1" INT

read -p "Changes to English notation home directory? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

if uname -s | grep -qi "linux"; then
	LANG=C xdg-user-dirs-gtk-update
	exit
fi

if uname -s | grep -qi "darwin"; then
	#sudo -v

	# CF: http://qiita.com/is0me/items/0b7b846f1f0860629950
	if [ $(echo "$(sw_vers -productVersion | cut -d . -f1,2) > 10.8" | bc) -eq 1 ]; then
		cd /System/Library/CoreServices/SystemFolderLocalizations/ja.lproj
	else
		cd /System/Library/CoreServices/SystemFolderLocalizations/Japanese.lproj
	fi

	mv SystemFolderLocalizations.strings SystemFolderLocalizations.strings.back
	cp ../en.lproj/SystemFolderLocalizations.strings .

	killall Finder
	exit
fi
