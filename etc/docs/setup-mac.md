Setup Mac
=========

This page guides you to set up the new machine to usual state.

# 1. UI Settings

## Finder

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/55dabfcd-eed8-4ea9-a66a-3af3f509d773"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/7309a814-3c5f-4a88-8146-ed4f91dbac95"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d1e70e17-b4cb-4cb5-8e9f-b422868c76e8">

## System Settings

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

# 2. Developments

Let's configure a development environment through a console. At this time, the console app which is pre-installed is only `Terminal.app` by default. So you need to use it to set up these configurations.

<!--
<img width="400" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2b7d358c-f68a-472f-ad3d-a2f9e3d5a6e2">
-->
<img width="400" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/216d22e3-0fb5-4e62-b8f6-b56361eae810">

## Prerequisites

Install Git.

```bash
xcode-select --install
```

Install Rosetta 2.

```bash
sudo softwareupdate --install-rosetta
```

## Connections for GitHub

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

## Dotfiles

The first thing you need to do is to clone this repo into a location of your choosing. For example, if you have a `~/Developer` directory where you clone all of your git repos, that's a good choice for this one, too. This repo is setup to not rely on the location of the dotfiles, so you can place it anywhere.

```bash
git clone git@github.com:babarot/dotfiles.git ~/src/github.com/babarot/dotfiles
```

```bash
cd ~/src/github.com/babarot/dotfiles && make install
```

The `make install` will create symbolic links from the dotfiles directory into the `$HOME` directory, allowing for all of the configuration to *act* as if it were there without being there, making it easier to maintain the dotfiles in isolation.

## AFX/Zsh

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

## Homebrew

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

## Tmux

[tmux](https://github.com/tmux/tmux) will be installed via Brew. After installed, run `tmux` and press `prefix` + <kbd>I</kbd> on tmux to install plugins.

## Go

> [!NOTE]
> This step may become done by `brew` (Brewfile). If so, no longer needed to run this step.

1. Go to https://go.dev/dl/
2. Install via the installer

References:

- https://www.sambaiz.net/article/261/

# 3. Configure Apps

## 1Password

Log in with Setup Code (this is most easier among these methods).

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b2ef6f71-d7a4-4add-8926-3ea838f45cab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5472aeeb-2742-40b0-8049-3d1eee1a81bb">

Configure the appearance.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/17dd37b2-2af5-47d2-a252-daecc82ff598">

## Google Japanese IME

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e208b204-1f0b-4bfc-8020-23a9d6bb1761"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c8b7ae19-744d-462a-8acd-92cb72472e3d"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f57a6418-8265-4e33-ade5-c68998ce40e1"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f3fe14cf-6d5b-4d13-a7dc-933740ba49c3"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/86d09068-5b07-4a25-be97-ea912df2901e">

## iTerm2

### Install a colorscheme

https://ethanschoonover.com/solarized/

### Configure

Area | Guides
---|---
General | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2e708423-462b-499c-8be4-8483dbd41c2e"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/56ab5bd1-5118-4d47-9410-4a841344e546">
Appearance | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9a46b49d-c310-41ad-ab54-c3758ebae678">
Profile | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/382a5509-755b-4252-8eca-91e5a5bc22cd"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/38cacf00-5558-4831-9c79-1e9b721f1328"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/22b335f5-b439-4a8b-bc1d-b3ad5595bc4b"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b1e6c400-4ab9-42b5-8124-cb19b735140a">

## Obsidian

Setup Obsidian account and Vault.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd26762b-ccde-49d6-8b54-ec29f9af39b4"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d5b95ea7-dee9-4995-8704-96c02e6fb77f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd5b1ed9-500c-421a-8669-88f9f0dcb9ff"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e6972e20-8701-41a6-bb95-fb04bdbb5cc4">

Enter encryption password.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/38c94f78-668d-4c6c-b226-fece9583f3ab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9172929a-46ee-4d12-b2eb-7a0a6f421b95">

Run sync.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5f22ab4c-d7cf-4705-82ae-3cabd32764fb">

## Things 3

Turn on Things Cloud.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/51c58f87-d332-4185-ba4e-1a7db0c61901">

## PopClip

Install extensions from https://www.popclip.app/extensions/

- [Base64](https://www.popclip.app/extensions/x/19SiD)
- [Translate Tab](https://www.popclip.app/extensions/x/14UeG)

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9fca0072-9fee-439c-9185-52aff8d77653"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b5f685fc-188e-4de9-a06a-1ccc20ab1393">

## Spark

Log in.

## Spotify

Log in.

## Hidden Bar

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/16f7a3db-7dbc-45c3-a335-805b59363cc0">

## Magnet

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2d5c6c14-a429-4ee5-8b4e-8948a4ca3bab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/605e0be0-6c2a-4876-aa38-9c21209cb6d4">

## Meeting Bar

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c85a5528-70ce-4df1-8193-129102ab0f32"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/85daebaa-d77c-43bc-b2d1-b956f2f2ecf2"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5a349124-dbff-40ff-9b8e-7396c0d37ebf">

## Paste

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8e3bb2fe-697d-4e59-a88e-a495ff016355"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/95eead1f-6ff9-415d-a1b1-384791df78ca">

## Yoink

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b8a6512f-87b3-421b-9d46-20bdbf3305f2">

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/54620cec-6b87-41d6-a684-e58428318a2f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/ddeeabdb-5fe6-4b73-b06a-8227c50d04e9">
