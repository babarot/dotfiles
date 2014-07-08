#!/bin/bash

function make_ruby() {
	if (type ruby && type gem) >/dev/null 2>&1; then
		sudo gem install rubygems-update
		sudo update_rubygems
		sudo gem update
	
		gem install rake
		gem install tw
	fi
}

function make_tukubai() {
	mv -f ~/tukubai ~/tukubai.old
	git clone https://github.com/usp-engineers-community/Open-usp-Tukubai ~/tukubai
	cd ~/tukubai
	make install
}

read -p "Setup ruby (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	make_ruby
fi

read -p "Setup Open-usp-Tukubai (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	make_tukubai
fi
