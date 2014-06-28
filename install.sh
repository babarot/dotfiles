#!/usr/bin/env bash

function doIt() {
	git clone https://github.com/b4b4r07/dotfiles.git ~/.dotfiles;
	if [ $? -eq 0 ]; then
		cd ~/.dotfiles;
		make deploy;
		cd;
		source ~/.bash_profile
	fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "Cloning dotfiles repo to your home. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
