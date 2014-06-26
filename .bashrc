#============================================================#
#       _               _                                    #
#      | |__   __ _ ___| |__  _ __ ___                       #
#      | '_ \ / _` / __| '_ \| '__/ __|                      #
#     _| |_) | (_| \__ \ | | | | | (__                       #
#    (_)_.__/ \__,_|___/_| |_|_|  \___|                      #
#                                                            #
#************************************************************#
#                                                            #
#  bash - GNU Bourne-Again SHell                             #
#  Bash is Copyright (C) 1989-2011 by the Free Software      #
#  Foundation, Inc.                                          #
#  Multiplatform bashrc (.bashrc) file of b4b4r07            #
#                                                            #
#  The majority of the code here assumes you are on a GNU    #
#  system (most likely a Linux box) and is based on code     #
#  found on Usenet or internet.                              #
#                                                            #
#  Report bugs to b4b4r07 at gmail dot com.                  #
#                                                            #
#============================================================#

# Create new file with 644 perms
umask 022

# Variable declaration part
export OS=$(uname | awk '{print tolower($1)}')
export MASTERD="$HOME/.bash.d"
export PATH="$MASTERD/bin:$HOME/bin:$PATH"
export EDITOR=vi
export LANG=ja_JP.UTF-8
export LC_ALL=en_US.UTF-8
type less >/dev/null 2>&1 && {
	export PAGER=less
	export LESS='-f -N -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
	export LESS='-f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
	export LESSCHARSET=utf-8
}
export enable_auto_cdls=1

# Conditional branch by operating system
if [ "$OS" = "linux" ]; then
	#Linux
	[ -f ~/.bashrc.unix ] && source ~/.bashrc.unix
elif [ "$OS" = "darwin" ]; then
	#Mac OS X
	[ -f ~/.bashrc.mac ] && source ~/.bashrc.mac
fi

# If local config file exist, load it.
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

# If completion files exist, load it.
[ -f /etc/bash_completion ]     && . /etc/bash_completion
[ -f /etc/git-completion.bash ] && . /etc/git-completion.bash
[ -f /etc/git-prompt.bash ]     && . /etc/git-prompt.bash

# Loads the file except executable one.
test -d $MASTERD || mkdir $MASTERD
if [ -d $MASTERD ] ; then
	echo -en "\n"
	for f in $MASTERD/*.sh ; do
		[ ! -x "$f" ] && . "$f" && echo load "$f"
	done
	echo -en "\n"
	unset f
fi

# If function 'nowon' exist, call and unset it.
if type nowon >/dev/null 2>&1; then
	nowon && unset nowon
fi
