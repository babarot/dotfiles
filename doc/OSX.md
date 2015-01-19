# OS X's manual in dotfiles

![](http://cl.ly/image/0k1V1s1d0e3k/OSX_logo.png)

All of the stuff in this repository have been optimized to the latest **OS X 10.10.x** (As of 12/25/2014). If the user is on any other operating system, whether it works can not be guaranteed, and it has not been extensively tested.

## Setup

When setting up a new Mac, please perform the following tasks.

- Initialize

	By running this command, you can interactively setup all preferences for osx.

		$ make init

	- [Install Homebrew the missing package manager for OS X](./init/osx/install_homebrew.sh)
	- [Install the CLI tool that comes with Xcode](./init/osx/install_xcode.sh)
	- [Run 'brew install' based on the Brewfile](./init/osx/setup_brew.sh)
	- [Run 'brew cask install' based on the Caskfile](./init/osx/setup_cask.sh)
	- [Sensible OS X defaults](./init/osx/osx_defaults.sh)
	- [Setup Karabiner formerly KeyRemap4MacBook](./init/osx/setup_kanabiner.sh)

		(**as of January 20, 2015**)

- Change login shell

		$ chsh -s /bin/zsh

- Install homebrew

		$ make brew
		$ make cask