#!/bin/bash

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

function Check_The_Vim()
{
	Huge=Normal=moreNormal=Small=

	if vim --version | grep "version" | grep -q "^Huge"; then
		Huge='on'
		moreNormal='on'
	elif vim --version | grep "version" | grep -q "^Normal"; then
		Normal='on'
		moreNormal='on'
	elif vim --version | grep "version" | grep -q "^Small"; then
		Small='on'
	else
		echo "Unknown vim type"
		echo "If you had to choose one, which would you choose?"
		echo "  tiny, small, normal, big, huge"
		exit
	fi
}

Check_The_Vim;
if [ "$Small" ]; then
	read -p "Install vim from source. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		Install_Vim_From_Source;
		Check_The_Vim;
	fi
fi

if [ "$moreNormal" ]; then
	if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
		read -p "Execute vim with +'NeoBundleInit'. Are you sure? (y/n) " -n 1
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# same as vim -c "NeoBundleInit";
			vim +"NeoBundleInit";
		fi
	fi
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
