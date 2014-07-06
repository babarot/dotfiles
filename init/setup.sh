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
	mv -f ~/tukubai ~/tukubai
	git clone https://github.com/usp-engineers-community/Open-usp-Tukubai ~/tukubai
	cd ~/tukubai
	make install
}

read -p "$0: Setup ruby. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	make_ruby
fi

read -p "$0: Setup Open-usp-Tukubai. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	make_tukubai
fi
