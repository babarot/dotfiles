#/bin/bash

read -p "$0: Install bash_completion.sh from source. Are you sure? (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit
fi

cd /usr/local/src
if type curl >/dev/null 2>&1; then
	curl http://bash-completion.alioth.debian.org/files/bash-completion-1.2.tar.gz >bash-completion-1.2.tar.gz
elif type wget >/dev/null 2>&1; then
	wget http://bash-completion.alioth.debian.org/files/bash-completion-1.2.tar.gz
else
	echo "You don't have downloader."
	exit
fi

./configure --prefix=''
sudo -v
make
sudo make install
sudo cp -a bash_completion.sh /etc/profile.d/
sudo chmod +x /etc/profile.d/bash_completion.sh
