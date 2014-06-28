#!/bin/bash

echo ''
echo '     | |     | |  / _(_) |           '
echo '   __| | ___ | |_| |_ _| | ___  ___  '
echo '  / _` |/ _ \| __|  _| | |/ _ \/ __| '
echo ' | (_| | (_) | |_| | | | |  __/\__ \ '
echo '  \__,_|\___/ \__|_| |_|_|\___||___/ '
echo ''

function doIt() {
	git clone https://github.com/b4b4r07/dotfiles.git ~/.dotfiles;
	if [ $? -eq 0 ]; then
		cd ~/.dotfiles;
		make deploy;
		cd;
		source ~/.bash_profile
	fi;
}

#if [ "$1" == "--force" -o "$1" == "-f" ]; then
#	doIt;
#else
#	echo "Start to install..."
#	read -p "Cloning dotfiles repo to your home. Are you sure? (y/n) " -n 1;
#	echo "";
#	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
#	fi;
#fi;

unset doIt;
