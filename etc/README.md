# About [./install](./install)

[Shell script](http://dot.b4b4r07.com) that is used to install command[*1](#note) has been written in `/bin/sh` in accordance with POSIX standard. In compliance with the POSIX it is possible to write a shell script, the [./install](./install) becomes high portability script and it can be run in any environment.

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

	$ make init

**As of January 20, 2015**

- [Build and install the original cutsom Vim](./init/build_vim_by_myself.sh)
- [Translate the home directory into English](./init/globalize_your_home_directory.sh)
- [Install antigen zsh plugin manager](./init/install_zsh_plugin_manager_antigen.sh)
- [Install pygments generic syntax highlighter written in python](./init/install_pygments.sh)

### etc/init/osx/

This directory is `etc/init/` OS X only version. Because the `make init` includes this directory, there is no need to run the command again for `osx`.

**As of January 25, 2015**

- [Install Homebrew the missing package manager for OS X](./init/osx/install_homebrew.sh)
- [Install the CLI tool that comes with Xcode](./init/osx/install_xcode_cli_tools.sh)
- [Run 'brew install' based on the Brewfile](./init/osx/install_brew_packages.sh)
- [Run 'brew cask install' based on the Caskfile](./init/osx/install_cask_packages.sh)
- [Sensible OS X defaults](./init/osx/execute_osx_defaults.sh)
- [Setup Karabiner formerly KeyRemap4MacBook](./init/osx/setup_kanabiner.sh)

## etc/lib/

Library files of shell script has been saved. When the [`shlib`](./lib/shlib) is sourced, the `shlib` will source all of the shell script library within `etc/lib/` directory.


	$ . shlib

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

	$ make test

Whether you go successfully through a test depends on the following items:

- [Whether the installation command URL redirects to the github.com](./test/install_init_test.pl)
- [Whether dot file is deployed to the home directory](./test/install_deploy_test.pl)
- [Whether the configuration file for the initialization to work properly](./test/install_redirect_test.pl)

| Build Status |
|:---:|
|[![Build Status](https://travis-ci.org/b4b4r07/dotfiles.svg?branch=master)](https://travis-ci.org/b4b4r07/dotfiles)|

----

<a name="note">*1</a>: `bash -c "$(curl -fsSL dot.b4b4r07.com)"`
