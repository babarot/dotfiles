# The [B4B4R07](https://twitter.com/b4b4r07)'s dotfiles

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/b4b4r07/dotfiles/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

This is a repository with my [configuration files](http://en.wikipedia.org/wiki/Configuration_file), those that in Linux/OS X normally are these files under the `$HOME` directory that are hidden and preceded by a dot, AKA *dotfiles*.

## Overview

The primary goal is to increase CLI productivity on OS X, though many scripts run just fine on any POSIX implementation and it is easy to build environment again by running just [Installation](#installation) command of one liner .

My primary OS is OS X (10.10.x) and some of these configurations are tuned to work on that platform. The bash files are more generic and friendly toward other Unix-based operating systems.

## Features

- **OS X** Yosemite (Macbook Air)
- **Zsh** 5.0.5
- **Vim** 7.4
- **Tmux** 1.9a
- **Terminal.app** (Full-screen)
- **Solarized** ([base 16](https://github.com/chriskempson/base16))

Click this image to see a larger version.

![](http://cl.ly/image/1f2H0F3U0240/dev-env.png "b4b4r07's environment")

## Installation

Run the following commands in your terminal. 

	$ bash -c "$(curl -fsSL raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)"

**what's inside?**

1. Downloads this repository (**prerequisites**: `git` or `curl` must be installed).
2. Deploy (i.e. *copy* or *create symlink*) dot files to your home directory.
3. Run all programs for setup in `./etc/` directory (**Optional**: when running [Installation](#installation) command specify `-s install` as an argument).

## Updating

To update later on, just run this command.

	$ make update

In addition, there are several git submodules included in this configuration. On a new installation these submodules need to be initialized and updated.

## Setup

All configuration files for setup is stored within the `etc/` directory. By running this command, you can interactively setup all preferences.

	$ make install

### Vim

To install the Vim plugins, run this command.

	$ vim +NeoBundleInit +qall

Vim plugins are not installed from you just running the [Installation](#installation) command. To install the plugins, you must specify the `-c 'NeoBundleInit'` as an argument when starting Vim. By doing so, install immediately [neobundle.vim](https://github.com/Shougo/neobundle.vim) and other plugins (**requires**: `git` in `$PATH`, Vim 7.2+, a lot of time, Wi-Fi). 

To use these plugins effectively, features of Vim needs **normal or [more](http://www.drchip.org/astronaut/vim/vimfeat.html)**.

### Git

Make the configuration file for personal use. Copy and paste the following to personal configuration file, e.g. `~/.sh.local`

```bash
# Git credentials
# Not under version control to prevent people from
# accidentally committing with your details
GIT_AUTHOR_NAME="b4b4r07"
GIT_AUTHOR_EMAIL="b4b4r07@example.com"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# Set the credentials (modifies ~/.gitconfig)
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### OS X Hacks

- Change login shell

	There is configuration for zsh so switch your shell from the default bash to zsh on OS X:

	```	
$ chsh -s /bin/zsh
	```

- How to Install Command Line Tools in OS X Mavericks (Without Xcode)

	You need to have [Xcode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [Xcode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

	The easiest way to install the Xcode Command Line Tools in OSX 10.9+ is to open up a terminal, type

	```	
$ xcode-select --install
	```

	and [follow the prompts](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/). _Tested in OS X 10.10_

- Custom OS X defaults

	When setting up a new Mac, you may want to set some sensible OS X defaults:

	```
$ bash ./init/osx/defaults.sh
	```

- [Installing Homebrew](http://brew.sh)

	Paste that at a Terminal prompt.

	```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	```

### Homebrew

The `Brewfile` acts as a bundle for Homebrew. Use `brew bundle path/to/Brewfile` to set up brews.

When setting up a new Mac, you may want to install some common Homebrew formulae (after installing Homebrew, of course):

	$ brew bundle ./init/osx/Brewfile
	$ brew bundle ./init/osx/Caskfile

**NOTES:**

On those Mac OS machines where I install Homebrew I also edit `/etc/paths` to move the `/usr/local/bin` entry to the top of the list. This ensures that Homebrew-managed programs and libraries occur prior to `/usr/bin` and system-provided programs and libraries. 

The resulting `/etc/paths` files looks like this:

```
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
```

## Components

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere.
- **etc/init/**: Configuration file storage to be executed initially for setup.
- **etc/osx/**: Some configuration files for OS X storage.
- **doc/man/**: A self-written program's manuals.
- **.zsh/plugin/**: Any files ending in `.sh` get loaded into your environment.

## Credits

* Dotfiles' `README` layout based on [@Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
* File Hierarchy based on [@Pritzker's dotfiles](https://github.com/skwp/dotfiles)
* `Makefile` based on [@Tetsuji's dotfiles](https://github.com/xtetsuji/dotfiles)
* `bootstrap.sh` based on [@Rocha's dotfiles](https://github.com/zenorocha/old-dotfiles)

## Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07's Qiita](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |

## Licence

Copyright (c) 2014 "BABAROT" b4b4r07

Licensed under the [MIT license](./doc/LICENSE-MIT.txt).

