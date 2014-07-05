#-------------------------------------------------------------
# SOME ALIASES
#-------------------------------------------------------------
# May be performed as follows: If you want to cancel this setting temporarily.
#
# prompt:~$ alias >/tmp/alias.tmp
# prompt:~$ unalias -a
# prompt:~$ (some actions)
# prompt:~$ source /tmp/alias.tmp
#

#unalias -a

# LS
if type gls >/dev/null 2>&1; then
	alias ls="gls --color=auto -F -b"
fi
declare -a paths=( `. $MASTERD/function.sh; search ls` )
declare -i I=0
for (( I = 0; I < ${#paths[@]}; ++I  ))
do
	if ${paths[$I]} --version 2>/dev/null | grep -qi "gnu"
	then
		export LSPATH="${paths[$I]}"
		alias ls="$LSPATH --color=auto -F -b"
	fi
done

# Vim
declare -a paths=( `. $MASTERD/function.sh; search vim` )
declare -i I=0
for (( I = 0; I < ${#paths[@]}; ++I  ))
do
	if ${paths[$I]} --version | grep "+clipboard" >/dev/null
	then
		export EDITOR="${paths[$I]}"
		alias vi="$EDITOR"
		alias vim="$EDITOR"
	fi
done

# Git
if type git >/dev/null 2>&1; then
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

# MASTERD aliases
alias cl="$MASTERD/catless.sh"
alias melt="$MASTERD/melt.rb"
alias rm="$MASTERD/safe.sh"

# Common aliases
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
alias cdx="builtin cd $@ && ls"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff -u'

if type colordiff >/dev/null 2>&1 ; then
	alias diff='colordiff -u'
fi

# The first word of each simple command, if unquoted, is checked to see 
# if it has an alias. [...] If the last character of the alias value is 
# a space or tab character, then the next command word following the 
# alias is also checked for alias expansion
alias sudo='sudo '
