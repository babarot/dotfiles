# b4b4r07's dotfiles

This repository is b4b4r07's config files. By the clone this repository, you can build the same environment everywhere.

## Downlands

To downland it, just execute the following command:

	# If you have curl installed
	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh

	# If you have wget installed
	wget -q -O - https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh

## Much still remains to be done

	cd ~/.dotfiles
	make install

## Hierarchical description

### ABOUT dotfiles/

* .bash_profile
* .bashrc
* .bashrc.mac

	*bashrc for mac*

* .bashrc.unix

	*bashrc for unix such as linux ( Ubuntu, Fedora, and SUSE, etc )*

* .dir_colors

	*The file and dir color which displayed by ls command is described in the file.* 
	
	*Program `ls (1)`, by using the environment variable `LS_COLORS`, will be determined by what color you want to display the file name. This environment variable is set by using a command like this usually.*

	 
```
	eval `dircolors some_path/dir_colors`
```

*The file used here is usually `/etc/DIR_COLORS`, but will be overridden by `.dir_colors` in your home directory.*

* .gitconfig
* .gitignore
* .gvimrc
* .inputrc

	*Life on the command line will enrich if you set `~/.inputrc` that is the configuration file about `readline`.*

* .vimrc
* .vimrc.bundle

	*Initialization setting of NeoBundle is described in this file.*

* .vimrc.plugin

	*Detailed settings for vim-plugin is described in this file.*

* Makefile

	*Make a symbolic link of the configuration file to your home directory.*

* README.md

### ABOUT dotfiles/.bash.d/
Only the files that have unexecute permissions(644) on the directory `${MASTERD:=~/.bash.d}`, load at startup.

**This is part of the bashrc:**

```
...

if [ -d $MASTERD ] ; then
	echo -en "\n"
	for f in $MASTERD/*.sh ; do
		[ ! -x "$f" ] && . "$f" && echo load "$f"
	done
	echo -en "\n"
	unset f
fi
...

```

The directory `~/.bash.d` called `$MASTERD` in **dotfiles** has some unexecutable files such as the following:

* ./alias.sh
* ./autofetch.sh

	*For more information about this script, access [b4b4r07/autofetch](https://github.com/b4b4r07/autofetch).*

* ./bashmark.sh

	*For more information about this script, access [b4b4r07/bashmark](https://github.com/b4b4r07/bashmark).*

* ./cdhist.sh

	*For more information about this script, access [b4b4r07/cdhist](https://github.com/b4b4r07/cdhist).*

* ./function.sh
* ./myhistory.sh

	*Apart from the `~ /. bash_history`, this is a self-made script that provides a rich history.*

* ./prompt.sh

	*About PS1 and so on...*

* ./queue.sh
* ./stack.sh

## Installation

===

### Git install

You can clone the repository wherever you want. I like to keep it in `~/dotfiles`.

	git clone https://github.com/b4b4r07/dotfiles.git && cd dotfiles && make install

To update, cd into your local dotfiles repository and then:

	git pull origin master

### Git-free install

To install these dotfiles without Git:

	cd; wget -O - https://github.com/b4b4r07/dotfiles/tarball/master | tar xvf -

To update later on, just run that command again.

## Author

===

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07's Qiita](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |

## Licence

===

> The MIT License (MIT)
> 
> Copyright (c) 2014 b4b4r07
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
