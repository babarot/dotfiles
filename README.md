# The [B4B4R07](https://twitter.com/b4b4r07)'s dotfiles

This is a repository with my configuration files, those that in Linux/OS X normally are these files under the `$HOME` directory that are hidden and preceded by a dot, AKA **dotfiles**.

The primary goal is to increase CLI productivity on OS X, though many scripts run just fine on any POSIX implementation and to it easy to build environment again.

My primary OS is OS X (10.10.x) and some of these configurations are tuned to work on that platform. The bash files are more generic and friendly toward other Unix-based operating systems.

## Features

- OS X 10.10.x (Mac mini / Macbook Air)
- Zsh 5.0.5
- Vim 7.4 (Solarized)
- Tmux 1.9a
- Terminal.app (Full-screen)

![](http://cl.ly/image/1f2H0F3U0240/dev-env.png "vim-on-tmux")

## Installation

**Requires**: git

Run the following commands in your terminal. 

	$ bash -c "$(curl -fsSL raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)"

**Git-free install**

To install these dotfiles without Git:

	$ curl -L http://github.com/b4b4r07/dotfiles/tarball/master | tar xz
	$ make deploy

## Updating

To update later on, just run this command.

	$ make update

In addition, there are several git submodules included in this configuration. On a new installation these submodules need to be initialized and updated.

## Setup

### Vim

	$ vim +NeoBundleInit +qall

Many plugins are not installed yet. When you start Vim for the first time, it is recommended that it is of specifying the `-c 'NeoBundleInit'` as the argument. By doing so, many plugins will be installed quickly. To effectively use the plugin, that the type of vim is **normal or [more](http://www.drchip.org/astronaut/vim/vimfeat.html)** is desired. Of course, `git` is required.

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

- Login shell

	There is configuration for zsh so switch your shell from the default bash to zsh on OS X:

	```	
chsh -s /bin/zsh
	```


- How to Install Command Line Tools in OS X Mavericks (Without Xcode)

	You need to have [Xcode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [Xcode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

	The easiest way to install the Xcode Command Line Tools in OSX 10.9+ is to open up a terminal, type `xcode-select --install` and [follow the prompts](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/). _Tested in OS X 10.10_

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
- **etc/init/**: Some utilities and files to be executed initially.
- **etc/osx/**: Some configuration files for OS X are stored.
- **doc/man/**: Self-made script manuals are stored here.
- **.zsh/plugin/\***: Any files ending in `.sh` get loaded into your environment.

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

<http://opensource.org/licenses/MIT>
