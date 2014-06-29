#/bin/bash

function bash_completion_install() {
	cd /usr/local/src
	wget http://bash-completion.alioth.debian.org/files/bash-completion-1.2.tar.gz
	./configure --prefix=''
	sudo -v
	sudo make
	sudo make install
	sudo cp -a bash_completion.sh /etc/profile.d/
	sudo chmod +x /etc/profile.d/bash_completion.sh
}

read -p "Install bash_completion.sh from source. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	bash_completion_install && echo -e "\033[31mComplete!\033[m"
fi

function git_setting()
{
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
		exit 1
	
	fi
}

read -p "Install git-[completion|prompt].[bash|sh] from source. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git_setting
fi
