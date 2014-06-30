#!/bin/bash

if type curl >/dev/null 2>&1
then
	crul https://db.tt/CTHoyLng >bttrc            # bttrc
	crul https://db.tt/V2hTAodO >popclip.tar.gz   # popclip
	crul https://db.tt/kozhDx3k >alfred.tar.gz    # alfred

elif type wget >/dev/null 2>&1
then
	wget -O bttrc https://db.tt/CTHoyLng          # bttrc
	wget -O popclip.tar.gz https://db.tt/V2hTAodO # popclip
	wget -O alfred.tar.gz https://db.tt/kozhDx3k  # alfred

else
	echo "You don't have downloader."
	exit
	
fi

