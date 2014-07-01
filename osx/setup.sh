#!/bin/bash

read -p "Download some config files from b4b4r07's Dropbox. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

if type curl >/dev/null 2>&1
then
	curl https://db.tt/CTHoyLng >bttrc            # bttrc
	curl https://db.tt/V2hTAodO >popclip.tar.gz   # popclip
	curl https://db.tt/kozhDx3k >alfred.tar.gz    # alfred

elif type wget >/dev/null 2>&1
then
	wget -O bttrc https://db.tt/CTHoyLng          # bttrc
	wget -O popclip.tar.gz https://db.tt/V2hTAodO # popclip
	wget -O alfred.tar.gz https://db.tt/kozhDx3k  # alfred

else
	echo "You don't have downloader."
	exit
	
fi
