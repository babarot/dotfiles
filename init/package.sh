#!/bin/bash

if uname -s | grep -qi "darwin"; then
	echo "$0; should do 'brew bundle osx/Brewfile'"
	exit
elif uname -s | grep -qi "linux"; then
	:
	if type yum >/dev/null 2>&1; then
		PACMAN='yum'
	elif type apt-get >/dev/null 2>&1; then
		PACMAN='apt-get'
	fi
fi


read -p "Install some commands by package management system. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

COMMANDS=(
	ack
	bash-completion
	colordiff 
	coreutils
	cowsay
	figlet
	fortune
	gawk
	gist
	gisty
	go
	hg
	hub
	tig
	tree
	vim
	wget
)

sudo -v
for x in "${COMMANDS[@]}"; do
	sudo $PACMAN install $x
	if [ $? -ne 0 ]; then
		NOT_INSTALLED=( ${NOT_INSTALLED[@]} $x );
	fi
done

echo "$NOT_INSTALLED: not installed" >/dev/stderr
