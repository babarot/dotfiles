# Dotfiles ETC Docmentation

## Contents

- [About ./install](#about-./install)
- [Makefile](#makefile)
	- [make install](#make-install)
- [Directory Map](#directory-map)
	- [etc/init/](#etc/init/)
		- [How to write the init scripts](#how-to-write-the-init-scripts)
	- [etc/init/OSX/](#etc/init/osx/)
	- [etc/lib/](#etc/lib/)
	- [etc/scripts/](#etc/scripts/)
	- [etc/test/](#etc/test/)
	- [Unix philosophy](#unix-philosophy)

# About [./install](./install)

[Shell script](http://dot.b4b4r07.com) that is used to *the installation command*[^1] has been written in `/bin/sh` in accordance with POSIX standard. In compliance with the POSIX it is possible to write a shell script, the [./install](./install) becomes high portability script and it can be run in any environment.

# Makefile

## make install

On dotfiles, the commands that `make install` run (in the order they are processed) are:

- `make update`
- `make deploy`
- `make init`
- `exec $SHELL`

# Directory map

Here is my example **basic** `dotfiles/`:

    /
    |-- bin
    |-- doc
    `-- etc
        |-- init
        |   `-- osx
        |-- lib
        |-- scripts
        `-- test

It does not show only the basic directory structure. In the future, there's a possibility that the new directories will be add to `etc/` directory. Even in that case the above directory map would not be rewritten.

## etc/init/

This `init` directory has configuration files that is executed by the [`Makefile`](../Makefile).

```bash	
$ make init
```

### How to write the init scripts

- Aim the script to help the user's preferences
	1. Shebang
	2. `trap 'exit 1' ERR` command to capture the unexpected error and suspend
	3. `set -eu`
	4. To determine whether the script should be executed (*the sieve system*)
		- **SAMPLE:** The init script installing homebrew
		- Not a Mac user ==> `exit 0` (not an error)
		- Already Installed ==> `exit 0` (not an error)
		- Not installed ==> Main processing
		- Cannot read the library "vital.sh" ==> `exit 1` (an error)
		- Btw, library "vital.sh" provides the basic boolean functions
	5. Breakpoint for debugging
	6. Main processing
- (Template init script)
	
	```bash
	#!/bin/bash
	trap 'echo Error: $0: stopped; exit 1' ERR
	set -e
	set -u

	# A system that judge if this script is necessary
	if [[ ! -f ../lib/vital.sh ]]; then
		exit 1
	fi
	# Note: vital.sh has is_osx function
	#is_osx() { [[ $OSTYPE =~ ^darwin ]] || return 1; }
	if ! is_osx; then
    	exit 0
	fi

	# Testing the judgement system
	if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi

	echo -n "Do something? (y/N) "
	read
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		: Main processing
	fi
	```

- Exit at the breakpoint when the init script is executed when the environment variable `DEBUG` is defined
- It is in order to test the validity of the system that judge if this script is necessary and the syntax error in debug mode
- The main process is executed after passing through the sieve system

**Init scripts (as of January 20, 2015)**

- [Build and install the original cutsom Vim](./init/build_vim_by_myself.sh)
- [Translate the home directory into English](./init/globalize_your_home_directory.sh)
- [Install antigen zsh plugin manager](./init/install_zsh_plugin_manager_antigen.sh)
- [Install pygments generic syntax highlighter written in python](./init/install_pygments.sh)

## etc/init/osx/

This directory is `etc/init/` OS X only version. Because the `make init` includes this directory, there is no need to run the command again for `osx`.

**Init scripts for OS X (as of January 25, 2015)**

- [Install Homebrew the missing package manager for OS X](./init/osx/install_homebrew.sh)
- [Install the CLI tool that comes with Xcode](./init/osx/install_xcode_cli_tools.sh)
- [Run 'brew install' based on the Brewfile](./init/osx/install_brew_packages.sh)
- [Run 'brew cask install' based on the Caskfile](./init/osx/install_cask_packages.sh)
- [Sensible OS X defaults](./init/osx/execute_osx_defaults.sh)
- [Setup Karabiner formerly KeyRemap4MacBook](./init/osx/setup_kanabiner.sh)

## etc/lib/

Library files of shell script has been saved. When the [`shlib`](./lib/shlib) is sourced, the `shlib` will source all of the shell script library within `etc/lib/` directory.

```bash
$ . shlib
```

**As of January 25, 2015**

- [Most important basically sh library](./lib/vital.sh)
- [Standard sh library](./lib/standard.sh)
- [Bash data structure "queue"](./lib/queue.bash)
- [Bash data structure "stack"](./lib/stack.bash)

## etc/scripts/

Shell script that did not become a command has been saved.
(The commands have been stored in the `/bin` directory, btw)

## etc/test/

Testing codes that used by [`Makefile`](../Makefile) are stored with in `etc/test/`. The test-run feature by means of [Travis CI](https://travis-ci.org/b4b4r07/dotfiles) enables this dotfiles repository developers to perform test runs of their processes automatically. This allows the user to know which test is executing in case the test hangs for some reasons.

To use it you need to set up a [.travis.yml](../.travis.yml) file in your home directory like this example:

```yaml
language: perl
perl:
    - 5.14
install:
    - sudo apt-get install libwww-perl
before_script:
    - "make deploy"
script:
    - "make --silent test"
```

To test the setup about this repository:

```bash
$ make test
```

Whether you go successfully through a test depends on the following items:

- [Whether the installation command URL redirects to the github.com](./test/install_init_test.pl)
- [Whether dot file is deployed to the home directory](./test/install_deploy_test.pl)
- [Whether the configuration file for the initialization to work properly](./test/install_redirect_test.pl)

| Build Status |
|:---:|
|[![Build Status](https://travis-ci.org/b4b4r07/dotfiles.svg?branch=master)](https://travis-ci.org/b4b4r07/dotfiles)|


# [Unix philosophy](http://en.wikipedia.org/wiki/Unix_philosophy)

1. *Small is beautiful.*
2. *Make each program do one thing well.*
3. *Build a prototype as soon as possible.*
4. *Choose portability over efficiency.*
5. *Store data in flat text files.*
6. *Use software leverage to your advantage.*
7. *Use shell scripts to increase leverage and portability*.
8. *Avoid captive user interfaces.*
9. *Make every program a Filter.*

[^1]: `bash -c "$(curl -fsSL dot.b4b4r07.com)"`
