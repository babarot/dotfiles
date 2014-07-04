#/bin/bash

read -p "$0: Install git-[completion|prompt].sh from source. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

if type curl >/dev/null 2>&1
then
	curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash >git-completion.bash
	curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh       >git-prompt.sh

elif type wget >/dev/null 2>&1
then
	wget -O git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
	wget -O git-prompt.sh       https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh

else
	echo "You don't have downloader."
	exit
fi
