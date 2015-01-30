# Dotfiles OS X Documentation

![](./img/OSX_logo.png)

All of the stuff in this repository have been optimized to the latest OS X 10.10.x. If the user is on any other operating system, whether it works can not be guaranteed, and it has not been extensively tested.

## Setup

When setting up a new Mac, please perform the following tasks.

### Initialize

By running this command, you can interactively setup all preferences for osx.

```bash
$ make init
```

- [Install Homebrew the missing package manager for OS X](./init/osx/install_homebrew.sh)
- [Install the CLI tool that comes with Xcode](./init/osx/install_xcode.sh)
- [Run 'brew install' based on the Brewfile](./init/osx/setup_brew.sh)
- [Run 'brew cask install' based on the Caskfile](./init/osx/setup_cask.sh)
- [Sensible OS X defaults](./init/osx/osx_defaults.sh)
- [Setup Karabiner (or formerly KeyRemap4MacBook)](./init/osx/setup_kanabiner.sh)

### Homebrew

This is a quick description of one of the most important apps that I use, [Brew](http://brew.sh). Since OS X does not have a native package manager that you can use from the command line, Brew (also known as HomeBrew), has filled in. A number of the applications that I use, from day to day, use Brew for installation.

For example, a simple `brew install coreutils` will install a [whole bunch of stuff](http://en.wikipedia.org/wiki/GNU_Core_Utilities), which is essential if you're used to working on Linux.

Brew is simple to install, and only has one requirement, Xcode Command Line tools:

```bash
$ xcode-select --install
```

Now that you have the command line tools installed, you can run a single command to install Brew:

```bash
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

After Brew is installed, it's considered best practice to run the following commands:

```bash
brew doctor
brew update
brew upgrade
```

When setting up a new Mac, you may want to install some common Homebrew formulae (after installing Homebrew, of course):

```bash
make brew
make cask
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

### defaults

**defaults** is a [command line](http://en.wikipedia.org/wiki/Command-line_interface) utility that manipulates [plist](http://en.wikipedia.org/wiki/Property_list) files. It can set many hidden settings and preferences in Mac OS X, and in individual applications. 

[](```bash
$ make osx
```)

- [OS X Daily](http://osxdaily.com/tag/defaults-write/)
- [defaults-write](http://www.defaults-write.com)

### Karabiner

[Karabiner](https://github.com/tekezo/Karabiner) (or formerly KeyRemap4MacBook) is a great tool that allows you to remap keyboard in OS X. I'm using it to remap left command as option key except a few Mac key combinations in Terminal.app, and Esc to switch back to English IM in Vim to make life easier.