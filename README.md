dotfiles

<!--
<p align="center">
<a name="top" href="http://b4b4r07.com/dotfiles"><img src="https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/logo.png"></a>
</p>

<p align="center">
<b><a href="#overview">Overview</a></b>
|
<b><a href="#features">Features</a></b>
|
<b><a href="#installation">Installation</a></b>
|
<b><a href="#updating">Updating</a></b>
|
<b><a href="#setup">Setup</a></b>
|
<b><a href="#structure">Structure</a></b>
|
<b><a href="#credits">Credits</a></b>
|
<b><a href="#license">License</a></b>
</p>

<br>

[![](https://img.shields.io/travis/b4b4r07/dotfiles.svg?style=flat-square)][travis]
[![](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]
[![](https://img.shields.io/badge/platform-OS%20X%20%7C%20Linux-808080.svg?style=flat-square)][platform]
[![](https://voting-badge.herokuapp.com/img?url=https://github.com/b4b4r07/dotfiles)][vote]
[![](https://img.shields.io/badge/documentation-etc-red.svg?style=flat-square)][doc]

This is a repository with my [configuration files](http://en.wikipedia.org/wiki/Configuration_file), those that in Linux/OS X normally are these files under the `$HOME` directory that are hidden and preceded by a dot, AKA **dotfiles**.

## Overview

The primary goal is to increase CLI productivity on OS X, though many scripts run just fine on any POSIX implementation and it is easy to build environment again by running just the [installation command](#oneliner) of one-liner.

My primary OS is OS X (10.10.x) and some of these configurations are tuned to work on that platform. The bash files are more generic and friendly toward other Unix-based operating systems.

<p align="right"><a href="#top">:arrow_up:</a></p>

## Features

- **OS X** Yosemite (MacBook, Retina 12-inch, Early 2015)
- **Terminal.app** (Full-screen)
- **Solarized** ([base 16](https://github.com/chriskempson/base16))
- **Tmux** 1.9a
- **Zsh** 5.0.5
- **Vim** (7.4 Huge +clipboard +lua)

***DEMO:***

[![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/demo_retina.png)][dotfiles]

**Note:** You can clone or fork them freely, but I don't guarantee that they fit you.

<p align="right"><a href="#top">:arrow_up:</a></p>

## Installation

The easiest way to install this dotfiles is to open up a terminal, type the installation command below:
Run the following command to set up a new machine:

<table>
    <thead>
        <tr>
            <th></th>
            <th><a name="oneliner">Installation command</a></th>
            <th>Copy</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>cURL</strong></td>
            <td>bash -c "$(curl -fsSL <a href="https://raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install">dot.b4b4r07.com</a>)"</td>
            <td align="center"><a href="http://b4b4r07.com/dotfiles">:clipboard:</a></td>
        </tr>
        <tr>
            <td><strong>Wget</strong></td>
            <td>bash -c "$(wget -qO - <a href="https://raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install">dot.b4b4r07.com</a>)"</td>
            <td align="center"><a href="http://b4b4r07.com/dotfiles">:clipboard:</a></td>
        </tr>
    </tbody>
</table>

- It is almost the same as the command below except for executing through a Web site directly.

	```console
	$ make install
	```

	It is not necessary to perform `make install` at all if this repository was installed by the [installation command](#oneliner).

- General download method using the `git` command:

	```console
	$ git clone https://github.com/b4b4r07/dotfiles.git ~/.dotfiles
	$ cd ~/.dotfiles && make install
	```
	
	Incidentally, `make install` will perform the following tasks.
	
	- `make update`; Updating dotfiles repository
	- `make deploy`; Deploying dot files
	- `make init`; Initializing some settings

**What's inside?**

1. Download this repository
2. Deploy (i.e. *copy* or *create symlink*) dot files to your home directory; `make deploy`
3. Run all programs for setup in `./etc/init/` directory; `make init` (**Optional**: when running the [installation command](#oneliner) specify `-s init` as an argument)

When the [installation command](#oneliner) format is not `curl -L URL | sh` but `sh -c "$(curl -L URL)"`, shell will be restart automatically. If this is not the case, it is necessary to restart your shell manually.

***DEMO:***

[![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/demo.gif)][dotfiles]

### Quick installation

[![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/curl.png)][dotfiles]

To quickly install:

```console
$ curl -sL dot.b4b4r07.com | sh
```

Difference of *Installation* and *Quick Installation* is that the latter one-liner is shorter than the former one (including typing the number of shift key). However, because when you install in the *Quick installation* shell is not re-boot, it is necessary to perform the `exec sh` yourself.

<table style="border:none;">
  <tr style="border:none;">
    <td style="border:none;"><strong>42 chars</strong></td>
    <td style="border:none;"><code>bash -c "$(curl -sL dot.b4b4r07.com)"</code></td>
  </tr>
  <tr style="border:none;">
    <td style="border:none;"><strong>30 chars</strong></td>
    <td style="border:none;"><code>curl -sL dot.b4b4r07.com | sh</code></td>
  </tr>
</table>

Actually notation of the shell may be `sh` instead of `bash`. Regardless of the `sh` realities, it is possible to do the same installation process because the [script file](etc/install) that is used to the [installation command](#oneliner) is a shell script that conforms to POSIX.

**Note:** If you want to use the [`curl`](http://curl.haxx.se), in order to follow the redirect `-L` flag is essential. On the other hand, it is possible to omit `-s` flag because it is meant that silent or quiet mode makes `curl` mute.

<p align="right"><a href="#top">:arrow_up:</a></p>

## Updating

To update later on, just run this command.

```console
$ make update
```

In addition, there are several git submodules included in this configuration. On a new installation these submodules need to be initialized and updated.

<p align="right"><a href="#top">:arrow_up:</a></p>

## Setup

### Initialize

All configuration files for setup is stored within the `etc/init/` directory. By running the command below, you can interactively setup all preferences.

```console
$ make init
```

To run `make init` immediately after running the [installation command](#oneliner):

```console
$ bash -c "$(curl -L dot.b4b4r07.com)" -s init
```

**Init scripts**

- Build and install customized Vim (+clipboard, +lua)
- Globalize your home directory name
- Install antigen the zsh plugin manager
- Install pygments the generic syntax highlighter written in python
- Install Homebrew the missing package manager for OS X
- Install the CLI tool that comes with Xcode
- Run 'brew install' based on the Brewfile
- Sensible OS X defaults
- Setup Karabiner (formerly KeyRemap4MacBook)
- ...

For more information about initializing, see also [./etc/README.md](./etc/README.md).

### Vim

To install the Vim plugins, run this command.

```console
$ vim +NeoBundleInit +qall
```

Vim plugins are not installed from you just running the [installation command](#oneliner). To install the plugins, you must specify the `-c 'NeoBundleInit'` as an argument when starting Vim. By doing so, install immediately [neobundle.vim](https://github.com/Shougo/neobundle.vim) and other plugins (**requires**: `git` in `$PATH`, Vim 7.2+, a lot of time, Wi-Fi). 

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

### Zsh

The easiest way to change your shell is to use the `chsh` command. You can also give `chsh` the `-s` option; this will set your shell for you, without requiring you to enter an editor.

```console
$ chsh -s /bin/zsh
```

**Note:** The shell that you wish to use must be present in the `/etc/shells` file.

### OS X

When setting up a new Mac, you may want to perform the following tasks mainly.

- Install the Xcode Command Line Tools

	You need to have Xcode or, at the very minimum, the Xcode Command Line Tools, which are available as a much smaller download.
	
	The easiest way to install the [Xcode Command Line Tools](https://developer.apple.com/downloads) in OS X 10.9+ is to open up a terminal, type `xcode-select --install` and follow the prompts.

- Install Homebrew and setup their formulae

	Since OS X does not have a native package manager that you can use from the command line, [Brew](http://brew.sh) (also known as Homebrew), has filled in. 
	
	After installing Homebrew, you may want to install some common Homebrew formulae:
	
	```console
	$ make init
	```
	
- Run some `defaults` commands

	It can set many hidden settings and preferences in Mac OS X, and in individual applications.

All of these are included in the `make init` for OS X. For more detail, see also [here][platform] of documentation of OS X operation.

<p align="right"><a href="#top">:arrow_up:</a></p>

## Trial

If you have [Vagrant](https://docs.vagrantup.com/v2/installation/) and [Virtualbox](https://www.virtualbox.org/wiki/Downloads) already installed, this is both faster and cleaner than downloading and compiling all the dependencies in OS X. To install, simply do the following:

```console
$ vagrant init http://files.dryga.com/boxes/osx-yosemite-0.2.1.box
$ vagrant up
```

If you want to try my dotfiles without polluting your development environment, it would be best to use a Vagrant. Have fun by setting and please remove it after finish.

```console
$ vagrant destroy -f   # when finished, destroy the VM
```


<p align="right"><a href="#top">:arrow_up:</a></p>

## Structure

[![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/components.png)](https://raw.githubusercontent.com/b4b4r07/screenshots/master/dotfiles/components.png)

<p align="right"><a href="#top">:arrow_up:</a></p>

## Credits

Acknowledgment; I established this dotfiles referring to the following user's repositories. Thus, I would appreciate it if you used my repository for reference. Thanks.

* These dotfiles are heavily based on [@cowboy's dotfiles](https://github.com/cowboy/dotfiles/blob/master/bin/dotfiles)
* Inspired by [@skwp's dotfiles](https://github.com/skwp/dotfiles)
* *Installation* section based on [@larsyencken's marelle](https://github.com/larsyencken/marelle)
* *Installation* section based on [@Cătălin's dotfiles](https://github.com/alrra/dotfiles)
* *Git* section based on [@necolas's dotfiles](https://github.com/necolas/dotfiles)
* *OS X* section based on [@cowboy's dotfiles](https://github.com/cowboy/dotfiles/blob/master/README.md)
* *Structure* section based on [@holman's dotfiles](https://github.com/holman/dotfiles)
* *Author* section and [*OS X defaults*](etc/init/osx/osx_defaults.sh) based on [@Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
* My `README.md` layout based on [@zanshin's README.md](https://github.com/zanshin/dotfiles)
* My `Makefile` based on [@Tetsuji's dotfiles](https://github.com/xtetsuji/dotfiles)
* My `bootstrap.sh` based on [@Rocha's dotfiles](https://github.com/zenorocha/old-dotfiles)

<p align="right"><a href="#top">:arrow_up:</a></p>

## Licence [![](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]

[![b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](https://twitter.com/intent/follow?screen_name=b4b4r07 "Follow @b4b4r07 on Twitter")

Copyright (c) 2014 "BABAROT" b4b4r07

Licensed under the [MIT license](./doc/LICENSE-MIT.txt).

Unless attributed otherwise, everything is under the MIT licence. Some stuff is not from me, and without attribution, and I no longer remember where I got it from. I apologize for that.

[![](https://d2weczhvl823v0.cloudfront.net/b4b4r07/dotfiles/trend.png)][bitdeli]

[travis]: https://travis-ci.org/b4b4r07/dotfiles
[license]: ./doc/LICENSE-MIT.txt
[platform]: ./doc/OS_X.md
[vote]: https://voting-badge.herokuapp.com/vote?url=https://github.com/b4b4r07/dotfiles
[doc]: ./etc/README.md
[bitdeli]: https://bitdeli.com/free
[dotfiles]: http://b4b4r07.com/dotfiles

<p align="right"><a href="#top">:arrow_up:</a></p>
-->
