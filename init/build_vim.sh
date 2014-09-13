#!/bin/bash

trap "exit 0" INT EXIT

function build_vim_from_source()
{
	INSTALL_DIR=/usr/local/bin/vim.new
	mkdir -p "$INSTALL_DIR"
	cd

	if type hg >/dev/null 2>&1; then
		sudo hg clone https://vim.googlecode.com/hg ~/Vim
		cd ~/Vim/
	elif type wget >/dev/null 2>&1; then
		wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
		tar jxvf vim-7.3.tar.bz2 
		cd vim73/
	else
		echo "You do not have a downloader."
		return 255
	fi

	./configure --prefix="$INSTALL_DIR" \
	--enable-multibyte \
	--with-features=huge \
	--enable-fontset \
	--enable-cscope \
	--disable-selinux \
	--disable-gui

	make 
	sudo make install
}

function check_vim_type()
{
	if `which vim` --version | grep "version" | grep -q "^Huge"; then
		false
	else
		true
	fi
}

if check_vim_type; then
	unset Huge

	read -p "Build huge vim from source (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		#set -e
		build_vim_from_source
		#set +e
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
