#!/bin/bash

if ! uname -s | grep -qi "linux"; then
	exit
fi

read -p "$0: Change from Japanese to English display of directory name. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	LANG=C xdg-user-dirs-gtk-update
fi
