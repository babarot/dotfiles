#!/bin/bash

echo '';
echo '     | |     | |  / _(_) |           ';
echo '   __| | ___ | |_| |_ _| | ___  ___  ';
echo '  / _` |/ _ \| __|  _| | |/ _ \/ __| ';
echo ' | (_| | (_) | |_| | | | |  __/\__ \ ';
echo '  \__,_|\___/ \__|_| |_|_|\___||___/ ';
echo '';

function doIt() {
	if [ -d ~/.dotfiles ]; then
		mv  -f ~/.dotfiles ~/.dotfiles.old;
	fi;

	git clone https://github.com/b4b4r07/dotfiles.git ~/.dotfiles;
	if [ $? -eq 0 ]; then
		cd ~/.dotfiles;
		make deploy;
		echo ""; make help;
		echo "";
		exec /bin/bash;
	fi;
}

msg=$(
cat <<-EOF
By executing ./bootstrap.sh, the following commands are run
  1. git clone b4b4r07/dotfiles.git
  2. make deploy
  3. restart bash without running rcfiles
Otherwise, any other changes

For more information, contact me
  Author; B4B4R07 <b4b4r07@gmail.com>
  GitHub; https://github.com/b4b4r07/dotfiles.git
  
EOF
);

echo "$msg";
if [[ ! "$0" =~ "bootstrap.sh" ]]; then
	doIt;
	if [ "$1" == 'all' ]; then
		sudo -v
		yes | make install
	fi
else
	echo "Started by a method that is not recommended"
fi

unset doIt;
