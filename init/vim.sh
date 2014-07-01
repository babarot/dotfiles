#!/bin/bash

if vim --version | grep "version" | grep -q "^Huge"; then
	Huge='on'
elif vim --version | grep "version" | grep -q "^Small"; then
	Small='on'
else
	echo "Unknown vim"
	exit
fi

function Install_Vim_From_Source()
{
	INSTALL_DIR=/usr/loca/app/vim.new
	sudo -v
	sudo mkdir -p $INSTALL_DIR
	cd $INSTALL_DIR

	if type hg >/dev/null 2>&1; then
		hg clone https://vim.googlecode.com/hg Vim
		cd Vim/
	else
		wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
		tar jxvf vim-7.3.tar.bz2 
		cd vim73/
	fi

	./configure --prefix=$INSTALL_DIR --enable-multibyte --with-features=huge --enable-fontset --enable-cscope --disable-selinux --disable-gui
	make 
	make test
	sudo make install
}

if [ "$Huge" ]; then
	 
	# same as vim -c "NeoBundleInit";
	vim +"NeoBundleInit";
else
	Install_Vim_From_Source;
fi

#
# References
#
#	http://d.hatena.ne.jp/hosikiti/20100910/1284079341
#	http://qiita.com/srea/items/a540d1259c095ee3ba71
#	http://qiita.com/__Attsun__/items/4d05ec5b37b1edbc288d
#	http://qiita.com/deepriver@github/items/7a88a662a30ded96360b
#	http://qiita.com/kinef/items/bac09fe6717ed16d7fad
#	http://d.hatena.ne.jp/sasaplus1/20110719/1311005875
#
