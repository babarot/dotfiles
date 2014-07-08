#!/bin/bash

if ! uname -s | grep -qi "linux"; then
	exit
fi

read -p "Change home directory names from Japanese to English (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	LANG=C xdg-user-dirs-gtk-update
fi
