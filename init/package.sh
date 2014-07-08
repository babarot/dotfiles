#!/bin/bash

#case ${OSTYPE} in
#	darwin*)
#		echo "try 'brew bundle osx/Brewfile'"
#	    exit
#		;;
#esac

if type yum >/dev/null 2>&1; then
	PACMAN='yum'
elif type apt-get >/dev/null 2>&1; then
	PACMAN='apt-get'
else
	echo "No package manager"
	exit
fi

read -p "Install some commands via package (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

COMMANDS=(`awk '/^install/{print $2}' ../osx/Brewfile`)

sudo -v
for x in "${COMMANDS[@]}"; do
	sudo $PACMAN install $x
	if [ $? -ne 0 ]; then
		NOT_INSTALLED=( ${NOT_INSTALLED[@]} $x );
	fi
done

if [ "$NOT_INSTALLED" ]; then
	echo "$NOT_INSTALLED: failed"
fi
