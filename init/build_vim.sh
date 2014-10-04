#!/bin/bash

trap "exit 0" INT EXIT

function check_vim_type()
{
	if `which vim` --version | grep "version" | grep -q "^Huge"; then
		return 1
	else
		return 0
	fi
}

if check_vim_type; then
	read -p "Build huge vim from source (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		cd
		./vimbuild
		sudo mkdir -p /usr/bin
		sudo install -m 555 vim /usr/bin/vim
	fi
else
	if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
		read -p "Launch vim with +'NeoBundleInit' (y/n) " -n 1
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			vim +NeoBundleInit +qall
		fi
	fi
fi
