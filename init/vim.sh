#!/bin/bash

set -e

#http://d.hatena.ne.jp/hosikiti/20100910/1284079341
#http://qiita.com/srea/items/a540d1259c095ee3ba71
#http://qiita.com/__Attsun__/items/4d05ec5b37b1edbc288d
#http://qiita.com/deepriver@github/items/7a88a662a30ded96360b
#http://qiita.com/kinef/items/bac09fe6717ed16d7fad
#http://d.hatena.ne.jp/sasaplus1/20110719/1311005875


if type hg >/dev/null 2>&1; then
	INSTALL_DIR=/usr/loca/app/vim.new
	sudo -v
	sudo mkdir -p $INSTALL_DIR
	cd $INSTALL_DIR
	hg clone https://vim.googlecode.com/hg Vim
	cd Vim
	./configure --prefix=$INSTALL_DIR --enable-multibyte --with-features=huge --enable-fontset --enable-cscope --disable-selinux --disable-gui
	make
	sudo sudo make install
	exit
fi

cd /usr/local/src
sudo awget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
sudo tar jxvf vim-7.3.tar.bz2 
cd ./vim73/
sudo ./configure --enable-multibyte --disable-selinux --prefix='/usr/local/app/vim-7.3'
sudo make 
sudo make test
sudo make install
