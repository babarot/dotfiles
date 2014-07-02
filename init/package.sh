#!/bin/bash

read -p "Install some commands by package management system. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

if uname -s | grep -qi "darwin"; then
	if type brew >/dev/null 2>&1; then
		PACMAN='brew'
	elif type port >/dev/null 2>&1; then
		PACMAN='port'
		PACMAN="sudo $PACMAN"
	fi
elif uname -s | grep -qi "linux"; then
	if type yum >/dev/null 2>&1; then
		PACMAN='yum'
		PACMAN="sudo $PACMAN"
	elif type apt-get >/dev/null 2>&1; then
		PACMAN='apt-get'
		PACMAN="sudo $PACMAN"
	fi
else
	echo "Unknown package system."
fi

COMMANDS=( $(cat "$(dirname "${BASH_SOURCE}")"/package.list | grep -v "^#") )

sudo -v
for x in "${COMMANDS[@]}"; do
	$PACMAN install $x
	if [ $? -ne 0 ]; then
		NOT_INSTALLED=( ${NOT_INSTALLED[@]} $x );
	fi
done

echo "$NOT_INSTALLED: not installed" >/dev/stderr
