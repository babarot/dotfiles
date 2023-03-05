# Setup Mac

This page guides you to set up the new machine to usual state.

## Developments

### Terminal.app

I usually use iTerm2 for developing something but it's not installed at this time, so at first let's use Terminal.app for this set up.

- https://ethanschoonover.com/solarized/
- https://github.com/todylu/monaco.ttf

### git/dotfiles

The first thing you need to do is to clone this repo into a location of your choosing. For example, if you have a `~/Developer` directory where you clone all of your git repos, that's a good choice for this one, too. This repo is setup to not rely on the location of the dotfiles, so you can place it anywhere.

> **Note**
> If you're on macOS, you'll also need to install the XCode CLI tools before continuing.

```bash
xcode-select --install
```

```bash
git clone git@github.com:b4b4r07/dotfiles.git ~/src/github.com/b4b4r07/dotfiles
```

```bash
cd ~/src/github.com/b4b4r07/dotfiles
make install
```

The `make install` will create symbolic links from the dotfiles directory into the `$HOME` directory, allowing for all of the configuration to *act* as if it were there without being there, making it easier to maintain the dotfiles in isolation.

### GitHub

```bash
ssh-keygen -t rsa -C "b4b4r07@gmail.com"
```

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

1. Go to https://github.com/settings/ssh/new
2. Paste the public key to the text area
3. Confirm to OK or not: `ssh -T git@github.com`

<img width="400" alt="" src="https://user-images.githubusercontent.com/4442708/222950511-ec47abf9-f307-497d-83eb-7907524d9868.png">

```console
$ ssh -T git@github.com
Hi b4b4r07! You've successfully authenticated, but GitHub does not provide shell access.
```

### AFX/Zsh

[afx](https://github.com/b4b4r07/afx/) is a CLI packages (tools, shell plugins, etc) manager. Almost all ZSH configurations are also related to the afx settings, so once you run `afx install` and then relaunch your shell, you can enter the CLI world in the usual state of your shell.

```bash
curl -sL https://raw.githubusercontent.com/b4b4r07/afx/HEAD/hack/install | bash
```

```bash
afx install
```

afx settings: [.config/afx](https://github.com/b4b4r07/dotfiles/tree/HEAD/.config/afx)

Refs:

- Usage https://babarot.me/afx

### Brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

```bash
brew bundle
```

Once homebrew is installed, it executes the `brew bundle` command which will install the packages listed in the [Brewfile](https://github.com/b4b4r07/dotfiles/blob/HEAD/Brewfile).

Refs:

- https://brew.sh/
- https://formulae.brew.sh/

### Tmux

[tmux](https://github.com/tmux/tmux) will be installed via Brew. After installed, run `tmux` and press `prefix` + <kbd>I</kbd> on tmux to install plugins.

### Go

> **Note**
> This step may become done by `brew` (Brewfile). If so, no longer needed to run this step.

1. Go to https://go.dev/dl/
2. Install via the installer

Refs:

- https://www.sambaiz.net/article/261/

### iTerm2

### PopClip

Install extensions: https://pilotmoon.com/popclip/extensions/



## System preferences

### Finder

Before | After
---|---
<img width="489" alt="" src="https://user-images.githubusercontent.com/4442708/222951896-61c9eb8f-fbf0-475d-a10a-912ab9af86fa.png"> | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222951917-0876e2ab-9257-41f7-be18-8abb1f1e6867.png">
<img width="489" alt="" src="https://user-images.githubusercontent.com/4442708/222951931-0c907c26-1a0d-4851-ad86-3d15eb16149c.png"> | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222951934-b87f3d70-22dd-42bf-8a99-6efee863eea3.png">

### System

Guide | What to do
---|---
Appurtenance | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952001-52c98d18-ae81-4292-a3fa-4a5b88be042c.png">
Desktop | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952030-5126f748-46b1-4c46-a7b2-39a6095a6f7b.png"> <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952032-48f614d2-c470-4607-adaa-d3140d58f353.png"> <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952035-97e23fad-a009-48ec-8728-7dd31fe4feab.png">
Keyboads | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952088-fc8a521a-26ae-4dd7-9933-f473ef132ea0.png"> <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952089-55d8a3fb-8883-4207-b0dc-12bc2f017306.png">
Trackpads | <img width="" alt="" src="https://user-images.githubusercontent.com/4442708/222952106-bdfbba95-8b26-4451-bc21-4f0f91c45095.png">



