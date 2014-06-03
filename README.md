# b4b4r07's dotfiles

## Description

This repository is b4b4r07's config files.

Only the files that have execute permissions(755) on the directory MASTERD, load at startup.

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

## Installation

You can clone the repository wherever you want. I like to keep it in ~/dotfiles.

	git clone https://github.com/b4b4r07/dotfiles.git && cd dotfiles && make install

To update, cd into your local dotfiles repository and then:

	git pull origin master

### Git-free install

To install these dotfiles without Git:

	cd; wget -O - https://github.com/b4b4r07/dotfiles/tarball/master | tar xvf -

To update later on, just run that command again.

## Author

| [![twitter/b4b4r07]()](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |
