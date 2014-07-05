# [B4B4R07](https://twitter.com/b4b4r07)'s dotfiles

This repository makes installation easier on us in all environment. By the cloning it, you can build the same environment everywhere. All you have to do is in accordance with the following. **So I'll start.**

![dotfiles](http://cl.ly/image/101i2a0O093e/dotfiles_%E2%80%94_bash_%E2%80%94_80%C3%9726.png)

## Implementation

To downland it, just execute the following command:

	sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)
or

	sh <(wget -q -O - https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)

**Alternate spellings**:

	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh
	wget -q -O - https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh
	
is not recommended.

**IF YOU DO THIS:**

1. git clone b4b4r07/dotfiles.git
2. make deploy
3. source ~/.bash_profile

By executing `sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)`, automatically clone git-repo by git and `make deploy`. Lastly, reload `~/.bash_profile`.


`make deploy` is
	
	deploy:
		@echo "Start deploy dotfiles current directory."
		@echo "If this is \"dotdir\", curretly it is ignored and copy your hand."
		@echo ""
		@for f in .??* ; do \
			test "$${f}" = .git -o "$${f}" = .git/ && continue ; \
			test "$${f}" = .DS_Store  && continue ; \
			echo "$${f}" | grep -q 'minimal' && continue ; \
			ln -sfnv "$(PWD)/$${f}" "$(HOME)/$${f}" ; \
		done ; true

that create symbolic links to your home directory.

To update later on, just run that command again:

	make update

## Things to do next

The processing of `sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)` is completed, it is necessary to execute following as soon as possible you.

1. cd ~/.dotfiles
2. make install

	`make install` is
	
		install:
			@for x in init/*.sh; do sh $$x; done
		ifeq ($(shell uname),Darwin)
			@for x in osx/*.sh; do sh $$x; done
		endif
	
	Execute all of the files within `init/`. In addition, in the case of OS X, execute all of the files within `osx/`. 
	
	Events are mainly executed are follows.
	
	* Install some commands by Package Management System (*nix only)
	* Set language of `$HOME` Japanese to English and vice versa
	* Execute vim with  `-c "NeoBundleInit"`. **Only type of vim is 'normal' or [more](http://www.drchip.org/astronaut/vim/vimfeat.html).**
	
	**ONLY OS X**
	
	* Install some commands from Brewfile
	* Setting up OS X defaults
	
	Also, you should do this:
	
		brew bundle osx/Brewfile
	
	You can install native applications via Homebrew without browsing each websites.

3. Create `~/.vital` (like `~/.local`) file.

	If ~/.vital exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.
	
	My `~/.vital` looks something like this:

		GIT_AUTHOR_NAME="B4B4R07"
		GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
		git config --global user.name "$GIT_AUTHOR_NAME"
		GIT_AUTHOR_EMAIL="b4b4r07@gmail.com"
		GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
		git config --global user.email "$GIT_AUTHOR_EMAIL"

## Description

Many in accordance with the convention, but show the definition about my original configuration files.

### dotfiles/.??* and *

* .bash.d/
> See the [following clause](#bashd).

* .bash_profile
* .bashrc
* .bashrc.mac
> Bashrc for mac. For example, op() function is `open` command of OS X Limited. Also, some aliases such as `alias ls='ls -GF'` are written here.

* .bashrc.unix
> Bashrc for unix. Mainly, write here the settings that you do not do in mac. For example, `'ls -F --color=auto --show-control-chars'`, `eval $(dircolors -b ~/.dir_colors)` and all are written here.

* .dir_colors
> The file and dir color which displayed by ls command is described in the file. Program `ls (1)`, by using the environment variable `LS_COLORS`, will be determined by what color you want to display the file name. This environment variable is set by using a command like this usually.
>
>		eval `dircolors some_path/dir_colors`
>
> The file used here is usually `/etc/DIR_COLORS`, but will be overridden by `.dir_colors` in your home directory.
> 

* .gitconfig
* .gitignore
* .gvimrc
* .inputrc
> Life on the command line will enrich if you set `~/.inputrc` that is the configuration file about `readline`.

* .vimrc
* .vimrc.bundle
> Initialization setting of NeoBundle is described in this file.

* .vimrc.plugin
> Detailed settings for vim-plugin is described in this file.

* Makefile
* README.md

### <a name="bashd"> dotfiles/.bash.d/.??* and * </a>

Only the files that have unexecute permissions(644) on the directory `${MASTERD:=~/.bash.d}`, load at startup and reload `~/.bashrc`.

**Part of the bashrc:**

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

The directory `~/.bash.d` called `$MASTERD` in **dotfiles** has some unexecutable files such as the following:

* ./alias.sh
* ./autofetch.sh
> For more information about this script, access [b4b4r07/autofetch](https://github.com/b4b4r07/autofetch).

* ./bashmark.sh
> For more information about this script, access [b4b4r07/bashmark](https://github.com/b4b4r07/bashmark).

* ./cdhist.sh
> For more information about this script, access [b4b4r07/cdhist](https://github.com/b4b4r07/cdhist).

* ./favdir.sh
> For more information about this script, access [b4b4r07/favdir](https://github.com/b4b4r07/favdir).

* ./function.sh
* ./myhistory.sh
> Apart from the `~/.bash_history`, this is a self-made script that provides a rich history.

* ./prompt.sh
* ./queue.sh
* ./stack.sh

## Temporary use

**ALL FILES COPY**:

	make sync

Use the `rsync` command to create simple copy files instead of the symbolic links.

**A particular file**:

	make mini

Build an environment with minimum configuration. To be specific, `.bashrc.minimal` and `.vimrc.minimal` are copied. It is written that only the minimum necessary.

## Deal with the aftermath

Delete all rcfiles despite link in your home directory.

	make clean

`make clean` is

	clean:
		@echo "rm -rf files..."
		@for f in .??* ; do \
			rm -v -rf ~/"$${f}" ; \
		done ; true
		rm -rf $(DOTFILES)

Finally, remove `~/.dotfiles` directory that contains all rcfiles.

## Credits

* Iterative installation based on [@Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
* README layout based on [@skwp's dotfiles](https://github.com/skwp/dotfiles)

## Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07's Qiita](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |

## Licence

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
