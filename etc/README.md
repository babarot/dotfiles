etc Documentation
===

[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][License]

[License]: ../doc/LICENSE-MIT.txt

`etc` is a warehouse of configuration files about environment construction in dotfiles. Mainly, there are init files for `make init`.

> **Table of contents**
> 
> - [Directory map](#directory-map)
> - [Makefile](#makefile)
> 	- [What the role of a target in a Makefile?](#what-the-role-of-a-target-in-a-makefile)
> - [DOTPATH: location of dotfiles](#dotpath-location-of-dotfiles)
> - [Install: a.k.a. vital.sh](#install-aka-vitalsh)
> 	- [Mechanism](#mechanism)
> 	- [Quick installation](#quick-installation)
> - [Library](#library)
> 	- [vital.sh](#vitalsh)
> - [Init scripts](#initscripts)
> 	- [init.sh: deal with all init scripts](#url)
> - [Testing in dotfiles](#testing-in-dotfiles)
> 	- [Travis CI](#travis-ci)
> 	- [How to write an unit testing](#how-to-write-an-unit-testing)
> 	- [test.sh: deal with all tests](#testsh-deal-with-all-tests)
> - [A script: neither bin nor lib](#a script neither bin nor lib)
> 

# Directory map

Here is my example **basic** `dotfiles/`:

    /
    |-- bin
    |-- doc
    `-- etc
        |-- init
        |-- lib
        |-- scripts
        `-- test

It does not show only the basic directory structure. In the future, there's a possibility that the new directories will be add to `etc/` directory. Even in that case the above directory map would not be rewritten.


# Makefile

Makefile in dotfiles become the starting point of all operations. Operation is a Target in Makefile. For example, `deploy`, `init`, `update`, and so on in [`Makefile`](../Makefile). Each targets plays an important role in the operation of dotfiles.

## What the role of a target in a Makefile?

- `deploy`

	**deploy** is possible to create symbolic links of the files starting with a dot in the dotfiles directory to your home directory.

	```console
	$ make deploy
	Copyright (c) 2013-2015 BABAROT All Rights Reserved.
	==> Start to deploy dotfiles to home directory.
	
	/Users/b4b4r07/.bashrc -> /Users/b4b4r07/.dotfiles/.bashrc
	/Users/b4b4r07/.tmux.conf -> /Users/b4b4r07/.dotfiles/.tmux.conf
	/Users/b4b4r07/.vimrc -> /Users/b4b4r07/.dotfiles/.vimrc
	/Users/b4b4r07/.vimrc_bakup -> /Users/b4b4r07/.dotfiles/.vimrc_bakup
	/Users/b4b4r07/.vimrc~ -> /Users/b4b4r07/.dotfiles/.vimrc~
	/Users/b4b4r07/.zsh -> /Users/b4b4r07/.dotfiles/.zsh
	/Users/b4b4r07/.zshenv -> /Users/b4b4r07/.dotfiles/.zshenv
	/Users/b4b4r07/.zshrc -> /Users/b4b4r07/.dotfiles/.zshrc
	/Users/b4b4r07/bin -> /Users/b4b4r07/.dotfiles/bin
	```

- `init`

	**init** is a step to speed up the procedures which the environment construction will be run every time.

	```console
	$ make init
	Password:
	 ➜ brew.sh
	 ➜ bundle.sh
	Succeeded in tapping homebrew/bundle
	Succeeded in tapping b4b4r07/goal
	Succeeded in installing goal
	Succeeded in installing ack
	Succeeded in installing auto
	...
	...
	Success: 39 Fail: 5
	 ➜ go.sh
	➡️  github.com/b4b4r07/goal
	➡️  github.com/kyokomi/emoji
	➡️  github.com/BurntSushi/toml
	➡️  github.com/k0kubun/pp
	...
	...
	 ➜ unlocalize.sh
	 ✔ $DOTPATH/etc/init/init.sh: Finish!!...OK
	```

[`Makefile`](../Makefile) also has a lot of targets to another. For more information, see `make help`.

```console
$ make help
make list           #=> Show file list for deployment
make update         #=> Fetch changes for this repo
make deploy         #=> Create symlink to home directory
make init           #=> Setup environment settings
make install        #=> Run make update, deploy, init
make clean          #=> Remove the dotfiles and this repo
```

# DOTPATH: location of dotfiles

DOTPATH environment variable specifies the location of dotfiles. On Unix, the value is a colon-separated string. On Windows, it is not yet supported.

DOTPATH must be set to run `make init`, `make test` and shell script library outside the standard dotfiles tree.

Fortunately, a mechanism for detecting the DOTPATH automatically are prepared.

It is [`.path`](../.path)!! Thanks to this script, when the dotfiles was installed and your shell was restarted, DOTPATH is set automatically.

```bash
# .path
readlink() {
    file="$1"
    cd "$(dirname "$1")"
    file="$(basename "$file")"
    while [ -L "$file" ]; do
        file="$(command readlink "$file")"
        cd "$(dirname "$file")"
        file="$(basename "$file")"
    done
    phys="$(pwd -P)"
    result="$phys/$file"
    echo "$result"
}

dotpath="$(dirname "$(readlink "$0")")"

if echo "$-" | grep -q "i"; then
    # -> source a.sh
    DOTPATH="$dotpath"
    export DOTPATH
else
    if [ "$0" = "${BASH_SOURCE:-}" ]; then
        # -> bash a.sh
        echo "$dotpath"
    fi
fi
```

`.path` is a file starting with a dot. Thus, it will be deployed to the home directory by `make deploy`. The installation of dotfiles (`bash -c "$(curl -L dot.b4b4r07.com)"`) contains `make deploy`. Because it is directed to read the `.path` in `.zshrc`, DOTPATH is set  automaticallyat starting Zsh.

```bash
# Put something this in your .bashrc or .zshrc
[ -f ~/.path ] && . ~/.path
```

By the way, `.path` is cloned as `dotpath` in `/bin`. To get DOTPATH from command-line:

```console
$ dotpath
/Users/b4b4r07/.dotfiles
```

# Install: a.k.a. vital.sh

`install` script is most important file in this dotfiles. This is because it is used as installation of dotfiles (`bash -c "$(curl -L dot.b4b4r07.com)"`) chiefly and as shell script library `vital.sh` that provides most basic and important functions.

As a matter of fact, [`vital.sh`](lib/vital.sh) is a symbolic link to [`install`](install), and this script (vital.sh/install) change its behavior depending on the way to have been called.

```console
$ source install           # call as vital.sh
$ cat install | bash       # call as install
$ bash -c "$(cat install)" # call as install
$ bash install             # not executed
```

If your want to install dotfiles, repalace above `cat` with `curl -L` and run command.

## Mechanism

```bash
if echo "$-" | grep -q "i"; then
    # -> source a.sh
    do_as_vital
    # if you want to exit, use `return' not `exit'
    # in this if section
    : return
else
    # three patterns
    # -> cat a.sh | bash
    # -> bash -c "$(cat a.sh)"
    # -> bash a.sh
    if [ "$0" = "${BASH_SOURCE:-}" ]; then
        # -> bash a.sh
        # do_nothing
        exit
    fi

    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
        # -> cat a.sh | bash
        # -> bash -c "$(cat a.sh)"
        do_as_install
    fi
fi
```

Thanks to above mechanism, this file can be used for both `install` (installation command for dotfiles) and `vital.sh` (shell script library).

## Quick installation

By making full use of these mechanisms, you can easily (only two-step) install dotfiles, and immediately reproduce the same environment that you always use. Probably it will not take 5 minutes.

1. Go to [gh-pages](http://b4b4r07.com/dotfiles), and click CURL or WGET button.
2. Paste that to your terminal.

	***DEMO:***

	[![demo](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/doc/img/dotfiles.gif)](https://github.com/b4b4r07/dotfiles "b4b4r07/dotfiles")

When the installation command is executed, it will download the dotfiles repository, deploy files with a name starting with dot (`.`) (aka dot files) to your home directory, and restart your current shell.

If you pass the installation command `-s init`, also it will initialize dotfiles. For more information, please see [README.md](../README.md).

	$ bash -c "$(curl -L dot.b4b4r07.com)" -s init

# Library

## vital.sh

`vital.sh` is a simple and powerful shell script library. Besides that, it is provided with a convenient functions `e_anything` (e.g., `e_success`, `e_failure`) that summarize echo command wrappers, and provided with `is_anything` (e.g., `is_osx`) that is used for conditional execution.

The quick way to test is to run this command:

	$ . $DOTPATH/etc/lib/vital.sh

For even more detail, there is [`vita.sh`](lib/vital.sh) and documentation in [lib](lib/README.md).

# Init scripts

Files called init script that are required to set up your development environment are saved within `/etc/init` directory.

## init.sh: deal with all init scripts

All init scripts are carried out by the Makefile, but Makefile run only `init.sh` in it.

```make
init:
	@DOTPATH=$(PWD) bash $(PWD)/etc/init/init.sh
```

`init.sh` defined with the basic program takes over the all init scripts execution, adjust the `sudo` time-out behavior until the process is completed and shape the output.

```bash
#...

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

# Keep-alive: update existing `sudo` time stamp
#             until this script has finished
while true
do
    sudo -n true
    sleep 60;
    kill -0 "$$" || exit
done 2>/dev/null &

for i in "$DOTPATH"/etc/init/"$(get_os)"/*[^init].sh
do
    #...
    e_arrow "$(basename "$i")"
    bash "$i"
    #...
done

#...
```

Thanks to `init.sh`, we don't have to worry about rewriting Makefile when we add or delete init file.

# Testing in dotfiles

It is possible to confirms whether or not init script is a legitimate shell script.

A script in `/etc/test/` runs a unit test. Items to be checked are the following.

- Whether it is possible to deploy dot files to home directory
- Whether it is possible to redirect [dot.b4b4r07.com](http://dot.b4b4r07.com) to [github.com](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install)
- Whether init scripts match POSIX
- ...

The following example is the case in which the error occurred.

```console
$ make test
 ✔ deploying dot files...OK
 ✔ linking valid paths...OK
 ✖ /Users/b4b4r07/.dotfiles/etc/test/redirect_test.sh: 17: unit1
 ➜ check shellcheck...
     ✔ /Users/b4b4r07/.dotfiles/etc/init/init.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/common/pygments.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/osx/brew.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/osx/bundle.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/osx/go.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/osx/pygments.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/osx/unlocalize.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/linux/chsh.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/linux/goal.sh...OK
     ✔ /Users/b4b4r07/.dotfiles/etc/init/linux/pygments.sh...OK
 ➜ test brew.sh...
     ✔ check if init script exists...OK
     ✔ check running...OK
 ➜ test bundle.sh...
     ✔ check if init script exists...OK
     ✔ check if Brewfile exists...OK
Files=5, Tests=6
make: *** [test] Error 1
```

## Travis CI

[Travis CI](https://travis-ci.org) is an open-source hosted, distributed continuous integration service used to build and test projects hosted at GitHub.

Travis CI is configured by adding a file named .travis.yml, which is a YAML format text file, to the root directory of the GitHub repository.

By setting the `language:` to objective-c, and it is possible to use a test environment in OS X and Homebrew. Otherwise Ubuntu 12.04 is used as it.

```yaml
language: objective-c
os:
    - osx
before_install:
    - brew update
    - brew install shellcheck
before_script:
    - make deploy
script:
    - make --silent test
```

Travis CI automatically detects when a commit has been made and pushed to a GitHub repository that is using Travis CI, and each time this happens, it will try to build the project and run tests.

| Build Status |
|:---:|
|[![Build Status](https://travis-ci.org/b4b4r07/dotfiles.svg?branch=master)](https://travis-ci.org/b4b4r07/dotfiles)|

## How to write an unit testing

The testing in dotfiles is unit testing of each function. See sample testing below:

```bash
#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR

unit1() {
    cd "$DOTPATH" && make deploy >/dev/null
    if [ $? -eq 0 ]; then
        # Use e_done, not e_success
        # if testing is done
        e_done "deploying dot files"
    else
        # e_failure echo back string and
        # return 1 (error)
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1
```

The general shell script library `vital.sh` has many `e_anything` functions such as `e_success` and `e_failure` for testing. Also, because DOTPATH shows location of dotfiles, it ​​can use to read in the shell library.

```bash
unite2() {
    #...
    
    ERR=0
    e_arrow "check POSIX..."
    for i in "${f[@]}"
    do
        shellcheck "$i">/dev/null
        if [ $? -eq 0 ]; then
            e_success "$i" | e_indent
        else
            ERR=1
            e_failure "$i" | e_indent
        fi
    done

    if [ "$ERR" -eq 1 ]; then
        return 1
    fi
}

unit2
```

ERR is the environment variable of error only. The best practice that determine whether the test has fallen is to check ERR or status code `$?`. Also, the readability is enhanced when you make `e_success` and `e_failure` pairs with `if` statement.

## test.sh: deal with all tests

Unit testing is carried out by the Makefile, but it is only running `test.sh` in Makefile.

```make
test:
	@DOTPATH=$(PWD) bash $(PWD)/etc/test/test.sh
```

`test.sh` is a shell script that summarize all test. For details, go to `/etc/test/` directory.

```
etc/test
├── deploy_test.sh
├── common/
│   └── init_go_test.sh
├── linux/
│   ├── init_chsh_test.sh
│   └── init_go_test.sh@
├── osx/
│   ├── init_brew_test.sh
│   ├── init_bundle_test.sh
│   └── init_go_test.sh@
├── redirect_test.sh
├── shellcheck_test.sh
└── test.sh*
```

There is a directory for each platform such as osx and linux, and put the unit tests in those directories. The common file should be placed on the common directory and create a symbolic link to the directory for each platform. For example, `init_go_test.sh` symbolic link exists in the directory of osx and linux.

An example of `test.sh` is the following:

```bash
#...

for i in "$DOTPATH"/etc/test/*_test.sh
do
    bash "$i" || ERR=1
done

if [ -n "$(get_os)" ]; then
    for i in "$DOTPATH"/etc/test/"$(get_os)"/*_test.sh
    do
        if [ -f "$i" ]; then
            bash "$i" || ERR=1
        else
            continue
        fi
    done
fi

#...
```

It is running all of files ending in `.sh` for the unit testing dutifully. In addition, it will check the exit code of the shell (each testing files) and determine the its exit code to pass to the Makefile based on it.

# A script: neither `bin` nor `lib`

`script` deal with a script file neither a command nor a library.

