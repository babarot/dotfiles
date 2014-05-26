#-------------------------------------------------------------
# SOME ALIASES
#-------------------------------------------------------------

if [ "$OS" = 'darwin' ]; then
	alias ls="`which ls` -GF"
else
	alias ls="`which ls` --color=auto -F"
fi

if which gls >/dev/null; then
	alias ls="`which gls` --color=auto -F"
fi

if $VIMC --version | grep "+clipboard" >/dev/null; then
	alias vi=$VIMC
else
	VIMC=/usr/local/bin/vim
	if $VIMC --version | grep "+clipboard" >/dev/null; then
		alias vi=$VIMC
	fi
fi

if [ "$OS" = "darwin" ]; then
	alias ds_clear='find . -name ".DS_Store" -print -exec rm -r {} ";" ; find . -name ._* -exec rm -r {} ";"'
elif [ "$OS" = "linux" ]; then
	alias barc="vi ~/.bashrc; source ~/.bashrc"
	alias virc="vi ~/.vimrc"
	alias reload="clear; source ~/.bashrc"
fi

if which git >/dev/null 2>&1; then
	alias gst='git status'
	gdi() { git diff | awk '/^diff/{print $3}' | sed 's%^a/%%'; }
	gvi()
	{
		git status >/dev/null
		if [ $? -eq 0 ]; then
			if ! git status | grep "^nothing" >/dev/null; then
				vi `git status | awk '/modified/{print $3}'`
			fi
		fi
	}
fi

alias cl="$MASTERD/catless.sh"

# common aliases
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias ld="ls -ld"          # show info about the directory
alias lla="ls -lAF"        # show hidden all files
alias ll="ls -lF"          # show long file information
alias la="ls -AF"          # show hidden files
alias lx="ls -lXB"         # sort by extension
alias lk="ls -lSr"         # sort by size, biggest last
alias lc="ls -ltcr"        # sort by and show change time, most recent last
alias lu="ls -ltur"        # sort by and show access time, most recent last
alias lt="ls -ltr"         # sort by date, most recent last
alias lm="ls -al | more"   # pipe through 'more'
alias lr="ls -lR"          # recursive ls
alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"
alias jobs="jobs -l"
alias less="less -rf --tabs=4 -R"
alias Less="less -rfN --tabs=4 -R"
alias C="LANG=C"
alias J="LANG=ja_JP.UTF-8"
alias temp="test -e ~/temporary && command cd ~/temporary || mkdir ~/temporary && cd ~/temporary"
alias untemp="command cd $HOME && rm ~/temporary && ls"
alias ssle="openssl enc -e -aes-128-cbc -in"
alias ssld="openssl enc -d -aes-128-cbc -in"
alias cdx="builtin cd $@ && ls"
