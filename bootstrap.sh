#!/bin/bash

set -e
set -u

echo '';
echo '     | |     | |  / _(_) |           ';
echo '   __| | ___ | |_| |_ _| | ___  ___  ';
echo '  / _` |/ _ \| __|  _| | |/ _ \/ __| ';
echo ' | (_| | (_) | |_| | | | |  __/\__ \ ';
echo '  \__,_|\___/ \__|_| |_|_|\___||___/ ';
echo '';

function make_b4b4r07()
{
    local dotfiles=~/.dotfiles;

    if [ -d "$dotfiles" ]; then
        #mv  -f ~/.dotfiles ~/.dotfiles.old;
        ( cd "$dotfiles" && git pull --rebase )
    else
        git clone https://github.com/b4b4r07/dotfiles.git "$dotfiles";
    fi;
    git submodule init
    git submodule update
    
    if [ $? -eq 0 ]; then
        cd "$dotfiles";
        make deploy;
        echo ""; make help;
        echo "";
        exec ${SHELL:-/bin/bash};
    fi;
}

msg=$(
cat <<-EOF
By executing ./bootstrap.sh, the following commands are run
  1. git clone b4b4r07/dotfiles.git
  2. make deploy
  3. (restart your current shell)
Otherwise, any other changes

For more information, contact me
  Author; B4B4R07 <b4b4r07@gmail.com>
  GitHub; https://github.com/b4b4r07/dotfiles.git

EOF
);

echo "$msg";
if [[ "$0" =~ "bootstrap.sh" ]]; then
    echo "That this file is started directly is not recommended";
    echo "Please run:";
    echo "  curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh";
else
    make_b4b4r07;
fi
