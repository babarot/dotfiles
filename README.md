# The [B4B4R07](https://twitter.com/b4b4r07)'s dotfiles

The purpose of this repository is to it easy to build environment again. When you clone the repository, (reference see photo below), you can easily reproduce the environment that I always use. According to this README file, you will succeed in building environment. However, the description of the construction environment has been written verbosely in this file. If you want to know how you can set in the shortest, then we recommend that you read the [following](#oneliner).

![dotfiles](http://cl.ly/image/3A3e0i1L0v0J/environment.png "vim-on-tmux")

## #1; Installations

Please execute the following command to complete the installation of the dot file. It means that you get(**git clone**) all configuration files from the GitHub repository and deploy them to the appropriate place in your home directory.

	sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)

or

	sh -c "`curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh`"

There are various descriptions, but either of the two described above is recommended.
	
Other method:

	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh

This is not recommended very much. In this way, this is because the third item "Restarting the bash" that the `bootstrap.sh` script should be executed does not executed. Conversely, this method is recommended if you do not want to restart it.

If you want to use `wget` instead of `curl` as a downloader, please replace `curl -L {URL}` with `wget -q -O - {URL}`.

When a clone of this repository is carried out in the old days, to update to fetch the changes,

	make update

### The identity of `bootstrap.sh`

1. `git clone b4b4r07/dotfiles.git`
2. `make deploy`
3. `source ~/.bash_profile`

When you run the script by using the method that has been recommended, **(1)***the repository is cloned*, **(2)***all configuration files is deployed*, and **(3)***the bash will be restarted*.

## #2; Things to do after the "bootstrap.sh"

Processing of `#1` is completed, If you use permanently this environment, this section would be meaningful to you.

	cd ~/.dotfiles && make install

Then, `make install` runs all shell scripts from `init/` directory. In addition, in the case of Mac, `osx/` directory is also the same. To be more specific, then run the following environment settings.

- Build the vim with "huge". In many cases, Vim, which is installed by default is "small(*tiny*) Vim".
- Anglify(translate into English) the home directory
- **If OS X**: Initialize Homebrew with `osx/Brewfile`
- **If OS X**: Runs `defaults` command that access the Mac OS X user defaults system
- Install packages (e.g. `wget`...)

## #3; Manually set

* Set the editor

	I use vim to the editor. At this stage, the plugins are not installed in Vim. When you start Vim for the first time, it is recommended that it is of specifying the `-c 'NeoBundleInit'` as the argument. By doing so, many plugins will be installed quickly. To effectively use the plugin, that the type of vim is normal or [more]((http://www.drchip.org/astronaut/vim/vimfeat.html) is desired. Of course, `git` is required.

* Set the Git

	Make the configuration file for personal use. Copy and paste the following to personal configuration file `~/.bashrc.local`.
	
		GIT_AUTHOR_NAME="B4B4R07"
		GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
		git config --global user.name "$GIT_AUTHOR_NAME"
		GIT_AUTHOR_EMAIL="b4b4r07@gmail.com"
		GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
		git config --global user.email "$GIT_AUTHOR_EMAIL"

=========================================================================================

<a name="oneliner">ONELINER:</a>

	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh && read -n 1 -p 'Install? ' && if [ "$REPLY" == "y" ]; then cd ~/.dotfiles && make install; fi; echo -e "\n\033[31mFINISH\033[m"; /bin/bash

You have reached the end of the preferences.


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

> The MIT License (MIT)
> 
> Copyright (c) 2014 B4B4R07
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
