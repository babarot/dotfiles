#!/bin/bash

function build_vim_from_source()
{
	INSTALL_DIR=/usr/local/bin/vim.new
	sudo -v
	sudo mkdir -p "$INSTALL_DIR"
	cd "$INSTALL_DIR"

	if type hg >/dev/null 2>&1; then
		hg clone https://vim.googlecode.com/hg Vim
		cd Vim/
	else
		wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
		tar jxvf vim-7.3.tar.bz2 
		cd vim73/
	fi

	./configure --prefix="$INSTALL_DIR" \ 
	--enable-multibyte \ 
	--with-features=huge \ 
	--enable-fontset \ 
	--enable-cscope \ 
	--disable-selinux \ 
	--disable-gui

	make 
	make test
	sudo make install
}

function check_vim_type()
{
	Huge=
	case "$EDITOR" in
		*vim*) : ;;
		*) return;;
	esac
	if "$EDITOR" --version | grep "version" | grep -q "^Huge"; then
		Huge='on'
	fi
}

if check_vim_type && test -n "$Huge"; then
	read -p "Build vim from source (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		build_vim_from_source
	fi

	if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
		read -p "Launch vim with +'NeoBundleInit' (y/n) " -n 1
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# same as vim -c "NeoBundleInit"
			vim +"NeoBundleInit"
		fi
	fi
fi
