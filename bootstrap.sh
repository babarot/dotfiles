#!/bin/bash

echo ''
echo '     | |     | |  / _(_) |           '
echo '   __| | ___ | |_| |_ _| | ___  ___  '
echo '  / _` |/ _ \| __|  _| | |/ _ \/ __| '
echo ' | (_| | (_) | |_| | | | |  __/\__ \ '
echo '  \__,_|\___/ \__|_| |_|_|\___||___/ '
echo ''

function doIt() {
	if [ -d ~/.dotfiles ]; then
		mv  -f ~/.dotfiles ~/.dotfiles.old
	fi

	git clone https://github.com/b4b4r07/dotfiles.git ~/.dotfiles;
	if [ $? -eq 0 ]; then
		cd ~/.dotfiles;
		make deploy;
		cd;
		source ~/.bash_profile
		make help
		echo -e "You should do '\033[33mmake install\033[m' to setup your environment."
	fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	make help
	echo ""
	echo "By executing ./bootstrap.sh with -f option, the following commands are run."
	echo "  1. git clone b4b4r07/dotfiles.git"
	echo "  2. make deploy"
	echo "  3. source .bash_profile"
	echo ""
	echo "Otherwise, any other changes."
fi

unset doIt
