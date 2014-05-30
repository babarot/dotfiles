# Description

This repository is b4b4r07's config files.


```
.
├── .bash.d
│   ├── alias.sh
│   ├── autofetch.sh
│   ├── bashmark.sh
│   ├── catless.pl
│   ├── catless.sh
│   ├── cdhist.sh
│   ├── debris.sh
│   ├── function.sh
│   ├── melt.rb
│   ├── myhistory.sh
│   ├── noc.sh
│   ├── pfsort.sh
│   ├── prompt.sh
│   ├── queue.sh
│   ├── stack.sh
│   ├── temp.func
│   └── trash.sh
├── .bash_profile
├── .bashrc
├── .bashrc.mac
├── .bashrc.unix
├── .dir_colors
├── .gitconfig
├── .gitignore
├── .gvimrc
├── .inputrc
├── .vimrc
├── .vimrc.bundle
├── .vimrc.plugin
├── Makefile
└── README.md

```

Only the files that have execute permissions(755) on the directory MASTERD, read at startup.

```
if [ -d $MASTERD ] ; then
	echo -en "\n"
	for f in $MASTERD/*.sh ; do
		[ ! -x "$f" ] && . "$f" && echo load "$f"
	done
	echo -en "\n"
	unset f
fi
```