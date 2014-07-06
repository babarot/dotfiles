#!/bin/sh

read -p "$0: Install some commands under brew. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

echo "brew updating..."

brew update
outdated=`brew outdated`
 
if [ -n "$outdated" ]; then
	cat << EOF

The following package(s) will upgrade.

$outdated

Are you sure?
If you do not want to upgrade, please type Ctrl-c now.
EOF

	read dummy

	brew upgrade
fi

brew bundle
