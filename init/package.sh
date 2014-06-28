#!/bin/bash

	if [ "$OS" == "darwin" ]; then
		PACMAN="brew"
	elif [ "$OS" == "linux" ]; then
		if [ -f /etc/issue ]; then
			KIND=$(cat /etc/issue | cut -d' ' -f1)
			case "$KIND" in
				"Ubuntu"|"Debian" ) PACMAN="apt-get" ;;
				"CentOS"|"Fedora" ) PACMAN="yum" ;;
				* ) PACMAN=""
			esac
		fi
	fi
	
	COMMANDS=(
		'ack'
		'bash-completion'
		'colordiff' 
		'cowsay'
		'figlet'
		'fortune'
		'gawk'
		'gist'
		'gisty'
		'hub'
		'tig'
		'tree'
		'vim'
		'wget'
	);
	
	if [ -z "$PACMAN" ]; then
		read -p "Enter package manager name you want to use: " PACMAN
	fi
	
	for cmd in "${COMMANDS[@]}"
	do
		sudo "$PACMAN" install "$cmd" 2>/dev/null
		if [ $? -ne 0 ]; then
			failed+=("$cmd")
		fi
	done
	
	if [ $cmd ]; then
		echo "${failed[@]}: not installed"
	fi
