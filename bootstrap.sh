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
		echo ""
		make help
		echo ""
		echo "You should do 'make install' to setup your environment"
	fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	echo ""
	echo "By executing ./bootstrap.sh with -f option, the following commands are run."
	echo "  1. git clone b4b4r07/dotfiles.git"
	echo "  2. make deploy"
	echo "  3. source .bash_profile"
	echo ""
	echo "Otherwise, any other changes."
	echo "  Author; B4B4R07 <b4b4r07@gmail.com>"
	echo "  GitHub; https://github.com/b4b4r07/dotfiles.git"
	echo ""
	read -p "Cloning git repository and deploying dotfiles. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi
fi

if [[ -p /dev/stdin ]]; then
	doIt;
	cd ~/.dotfiles
	exec /bin/bash
fi

unset doIt
