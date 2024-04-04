Setup Mac
=========

This page guides you to set up the new machine to usual state.

## 1. UI Settings

### Finder

<!--
Finder Settings | Guides
---|---
General | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/55dabfcd-eed8-4ea9-a66a-3af3f509d773">
Sidebar | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/7309a814-3c5f-4a88-8146-ed4f91dbac95">
Advanced | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d1e70e17-b4cb-4cb5-8e9f-b422868c76e8">
-->

Area | Guides
---|---
Finder Settings | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/55dabfcd-eed8-4ea9-a66a-3af3f509d773"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/7309a814-3c5f-4a88-8146-ed4f91dbac95"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d1e70e17-b4cb-4cb5-8e9f-b422868c76e8">

### System Settings

Area | Guides
---|---
Appearance | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/fc7aabba-ab4f-4c52-89c5-be3679b48822">
Accessibility | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2aa24213-e601-40e4-b82c-4f4c73c5380f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/dfa10f37-6c88-483d-b26c-2a51bfac3031">
Control Center | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/3dce23a7-5ed6-4352-854c-235687328676">
Desktop & Dock | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/20bebaf4-b5c1-4635-a124-390e57ef0534"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bacaef47-87c8-447b-a572-02efd6db5113">
Displays | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/1ff3f3a1-a052-478b-b9da-8c317a6d6030">
Touch ID & Password | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c61af4f6-4673-48ef-afb8-2c1876e27439">
Keyboad | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8f3f919e-700e-4d1a-bb8a-dea3eed53822"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/747ef146-b573-4d15-94b8-353499f933aa">
Trackpad | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/34c925a0-a438-43c4-9525-e5dedfb24127">

## 2. Developments

Let's configure a development environment through a console. At this time, the console app which is pre-installed is only `Terminal.app` by default. So you need to use it to set up these configurations.

<!--
<img width="400" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2b7d358c-f68a-472f-ad3d-a2f9e3d5a6e2">
-->
<img width="400" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/216d22e3-0fb5-4e62-b8f6-b56361eae810">

### Prerequisites

Install Git.

```bash
xcode-select --install
```

Install Rosetta 2.

```bash
sudo softwareupdate --install-rosetta
```

### Connections for GitHub
j
Check your keys in `.ssh` folder.

```console
$ ls ~/.ssh
id_rsa id_rsa.pub
```

If you don't have them, create key pairs with the command. (all questions are compulsory but it's OK to leave it blank these)

```bash
cd ~/.ssh && ssh-keygen -t rsa -C "babarot@gmail.com"
```

Copy a public key.

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

Next,

1. Go to https://github.com/settings/ssh/new
2. Paste the public key to the text area
3. Confirm to OK or not: `ssh -T git@github.com`

<img width="400" alt="" src="https://user-images.githubusercontent.com/4442708/222950511-ec47abf9-f307-497d-83eb-7907524d9868.png">

Let's check the connectivity for your GitHub account is working. It goes well if your account name is just displayed.

```console
$ ssh -T git@github.com
Hi babarot! You've successfully authenticated, but GitHub does not provide shell access.
```

### Dotfiles

The first thing you need to do is to clone this repo into a location of your choosing. For example, if you have a `~/Developer` directory where you clone all of your git repos, that's a good choice for this one, too. This repo is setup to not rely on the location of the dotfiles, so you can place it anywhere.

```bash
git clone git@github.com:babarot/dotfiles.git ~/src/github.com/babarot/dotfiles
```

```bash
cd ~/src/github.com/babarot/dotfiles && make install
```

The `make install` will create symbolic links from the dotfiles directory into the `$HOME` directory, allowing for all of the configuration to *act* as if it were there without being there, making it easier to maintain the dotfiles in isolation.

### AFX/Zsh

[afx](https://github.com/babarot/afx/) is a CLI packages (tools, shell plugins, etc) manager. Almost all ZSH configurations are also related to the afx settings, so once you run `afx install` and then relaunch your shell, you can enter the CLI world in the usual state of your shell.

```bash
curl -sL https://raw.githubusercontent.com/babarot/afx/HEAD/hack/install | bash
```

```bash
afx install
```


References:

- My plugins list: [.config/afx](https://github.com/babarot/dotfiles/tree/HEAD/.config/afx)
- Guide & Usage: https://babarot.me/afx

### Homebrew

Almost all apps except for CLI tools (commands/plugins, etc...) are managed by Homebrew (package manager for macOS).

Install `brew` command.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Install apps based on this list: [Brewfile](https://github.com/babarot/dotfiles/tree/HEAD/Brewfile).

```bash
brew bundle
```

References:

- https://brew.sh/
- https://formulae.brew.sh/

> [!TIP]
> Some apps are managed via [mas-cli/mas](https://github.com/mas-cli/mas) (Mac App Store command line interface). Sometimes, the installation by `brew bundle` is failed by various reasons. The most mainly reason for the installation failing is the app is already installed by the organization of Mac owner or the app listed on Mac App Store has been already deleted. In such a case, it is recommended that you install them individually through `mas` command manually as follows.
>
> <img width="600" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9e2ff51c-4927-4c6f-965b-a2cf011eb462">
>
> (List installed apps via `mas`)
> ```
> mas list
> ```
> (Install an app via `mas`)
> ```bash
> mas install <appid>
> ```

### Tmux

[tmux](https://github.com/tmux/tmux) will be installed via Brew. After installed, run `tmux` and press `prefix` + <kbd>I</kbd> on tmux to install plugins.

### Go

> [!NOTE]
> This step may become done by `brew` (Brewfile). If so, no longer needed to run this step.

1. Go to https://go.dev/dl/
2. Install via the installer

References:

- https://www.sambaiz.net/article/261/

## 3. Configure Apps

### PopClip

Install extensions: https://pilotmoon.com/popclip/extensions/

### Colorschemes for the terminal app

I usually use iTerm2 for developing something but it's not installed at this time, so at first let's use Terminal.app for this set up.

- https://ethanschoonover.com/solarized/
- https://github.com/todylu/monaco.ttf
