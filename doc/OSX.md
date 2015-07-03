OS X Documentation
===

This is a recipe that building method was written on OS X.

# Initialization

## Automatically (make init)

`make init` perform init scripts that are in `/etc/init`.

It may perform the following:

1. Install Homebrew the missing package manager for OS X
2. Install some Formulas from `Brewfile` (`brew bundle`; of course, you need to `tap` this)
3. Install Go packages via `goal` command in `config.toml` that has been installed by the Homebrew
4. Some important settings:
	- Install `xcode-select`
	- Unlocalize directory name in `$HOME`
	- Install other software packages (e.g., Pygments)

## Manually

### Homebrew

This is a quick description of one of the most important apps that I use, [Brew](http://brew.sh). Since OS X does not have a native package manager that you can use from the command line, Brew (also known as HomeBrew), has filled in. A number of the applications that I use, from day to day, use Brew for installation.

For example, a simple `brew install coreutils` will install a [whole bunch of stuff](http://en.wikipedia.org/wiki/GNU_Core_Utilities), which is essential if you're used to working on Linux.

Brew is simple to install, and only has one requirement, Xcode Command Line tools:

```console
$ xcode-select --install
```

Now that you have the command line tools installed, you can run a single command to install Brew:

```console
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

After Brew is installed, it's considered best practice to run the following commands:

```console
$ brew doctor
$ brew update
$ brew upgrade
```

When setting up a new Mac, you may want to install some common Homebrew formulae (after installing Homebrew, of course):

```console
$ brew tap Homebrew/bundle
$ brew bundle
```

**Note:**

- The order in `/etc/paths` file

	On those Mac OS machines where I install Homebrew I also edit `/etc/paths` to move the `/usr/local/bin` entry to the top of the list. This ensures that Homebrew-managed programs and libraries occur prior to `/usr/bin` and system-provided programs and libraries. 

	The resulting `/etc/paths` files looks like this:

	```
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	```

	The contents for the `$PATH` and their execute order are specified in the `/etc/paths` file.

- `brew bundle` is dead

	Therefore, cannot use `brew bundle path/to/Brewfile` to set up brews.
	
	> [What? "Warning: brew bundle is unsupported ..." #30815](https://github.com/Homebrew/homebrew/issues/30815)

	**Solution**: replace Brewfile with shell script.

Example: [Brewfile](../etc/init/assets/brew/Brewfile)

### Golang

Go can be installed by Brew, and the Go packages you use everyday can be installed by `goal` command.

```console
$ brew install go --cross-compile-common
$ brew tap b4b4r07/goal
$ brew install goal
```

`goal` command will install based on the package list written in TOML format such as the following:

```toml
repos = [
	"github.com/b4b4r07/gch",
	"github.com/b4b4r07/go-pipe",
	"github.com/b4b4r07/gomi/...",
]
```

Incidentally, `goal` is cross platform CLI application, this means that it can work even Linux and Windows.

***`goal` DEMO:***

[![](https://raw.githubusercontent.com/b4b4r07/goal/master/goal.gif)](https://github.com/b4b4r07/goal "b4b4r07/goal")

Example: [config.toml](../etc/init/assets/go/config.toml)

### defaults

**defaults** is a [command line](http://en.wikipedia.org/wiki/Command-line_interface) utility that manipulates [plist](http://en.wikipedia.org/wiki/Property_list) files. It can set many hidden settings and preferences in Mac OS X, and in individual applications.

```bash
$ make osx
```

- [OS X Daily](http://osxdaily.com/tag/defaults-write/)
- [defaults-write](http://www.defaults-write.com)

### Unlocalize

### Solarized (Terminal.app)

### Install other software