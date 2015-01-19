# About [./install](./install)

[Shell script](./install) that is used to install command[*1](#note) has been written in `/bin/sh` in accordance with POSIX standard. In compliance with the POSIX it is possible to write a shell script, the [./install](./install) becomes high portability script and it can be run in any environment.

## [Unix philosophy](http://en.wikipedia.org/wiki/Unix_philosophy)

1. *Small is beautiful.*
2. *Make each program do one thing well.*
3. *Build a prototype as soon as possible.*
4. *Choose portability over efficiency.*
5. *Store data in flat text files.*
6. *Use software leverage to your advantage.*
7. *Use shell scripts to increase leverage and portability*.
8. *Avoid captive user interfaces.*
9. *Make every program a Filter.*

# Directory map

Here is my example **basic** `dotfiles/`:

    /
    |-- bin
    |-- doc
    `-- etc
        |-- init
        |   `-- osx
        |-- lib
        `-- scripts

It does not show only the basic directory structure. In the future, there's a possibility that the new directories will be add to `etc/` directory. Even in that case the above directory map would not be rewritten.

## etc/init/

This `init` directory has configuration files that is executed by the [`Makefile`](../Makefile).

	$ make init

**As of January 20, 2015**

- [Build and install the original cutsom Vim](./init/build_vim.sh)
- [Translate the home directory into English](./init/english_home_directory.sh)
- [Install antigen zsh plugin manager](./init/install_antigen.sh)
- [Install pygments generic syntax highlighter written in python](./init/install_pygments.sh)

### etc/init/osx/

This directory is `etc/init/` OS X only version. Because the `make init` includes this directory, there is no need to run the command again for `osx`.

**As of January 20, 2015**

- [Install Homebrew the missing package manager for OS X](./init/osx/install_homebrew.sh)
- [Install the CLI tool that comes with Xcode](./init/osx/install_xcode.sh)
- [Run 'brew install' based on the Brewfile](./init/osx/setup_brew.sh)
- [Run 'brew cask install' based on the Caskfile](./init/osx/setup_cask.sh)
- [Sensible OS X defaults](./init/osx/osx_defaults.sh)
- [Setup Karabiner formerly KeyRemap4MacBook](./init/osx/setup_kanabiner.sh)

## etc/lib/

Library files of shell script has been saved. When the `shlib` is sourced, the `shlib` will source all of the shell script library within `etc/lib/` directory.


	$ . shlib

**As of January 20, 2015**

- [Most important basically sh library](./lib/vital.sh)
- [Standard sh library](./lib/standard.sh)
- [Bash data structure "queue"](./lib/queue.bash)
- [Bash data structure "stack"](./lib/stack.bash)

## etc/scripts/

Shell script that did not become a command has been saved.
(The commands has been stored in the `/bin` directory, btw)

----

<a name="note">*1</a>: `bash -c "$(curl -fsSL dot.b4b4r07.com)"`
