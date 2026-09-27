Setup Mac
=========

This page guides you to set up the new machine to usual state.

# 1. Built-in Software / OS Preferences

## Finder

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/55dabfcd-eed8-4ea9-a66a-3af3f509d773"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/7309a814-3c5f-4a88-8146-ed4f91dbac95"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d1e70e17-b4cb-4cb5-8e9f-b422868c76e8">

## System Settings

/ | Guides
---|---
Appearance | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/fc7aabba-ab4f-4c52-89c5-be3679b48822">
Accessibility | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2aa24213-e601-40e4-b82c-4f4c73c5380f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/dfa10f37-6c88-483d-b26c-2a51bfac3031">
Control Center | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/3dce23a7-5ed6-4352-854c-235687328676">
Desktop & Dock | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/20bebaf4-b5c1-4635-a124-390e57ef0534"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bacaef47-87c8-447b-a572-02efd6db5113">
Displays | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/1ff3f3a1-a052-478b-b9da-8c317a6d6030">
Touch ID & Password | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c61af4f6-4673-48ef-afb8-2c1876e27439">
Keyboad | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8f3f919e-700e-4d1a-bb8a-dea3eed53822"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/747ef146-b573-4d15-94b8-353499f933aa">
Trackpad | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/34c925a0-a438-43c4-9525-e5dedfb24127">
Mouse | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/56f226f7-3cd0-4a13-a33a-6c835075db88">

# 2. Hardware

- Keyboards
  - https://happyhackingkb.com/jp/download/
  - https://origin.pfultd.com/downloads/hhkb/manual/P3PC-6641-05.pdf
- Mouse
  - https://www.logicool.co.jp/ja-jp/setup/ergosetup/mouse-setup/bluetooth.html

# 3. Developments

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

## Homebrew

Install Homebrew before applying the Nix configuration. It is only used to install vendor apps that update themselves or install system components (1Password, Google Chrome, Docker, ...), listed in [nix/homebrew.nix](https://github.com/babarot/dotfiles/tree/HEAD/nix/homebrew.nix). `darwin-rebuild switch` installs the missing ones and never upgrades or removes anything.

```bash
cd ~/src/github.com/babarot/dotfiles && make brew
```

> [!NOTE]
> Claude Code is installed the same way when missing, with its official installer, and then updates itself. Mac App Store apps are installed by `darwin-rebuild switch` too, with [mas](https://github.com/mas-cli/mas), from [app-store.nix](https://github.com/babarot/dotfiles/tree/HEAD/nix/home/tools/app-store.nix). Sign in to the App Store first; an app that fails to install only prints a warning, so switch again after signing in.

## Nix/Zsh

CLI tools and zsh plugins are managed by [Nix](https://nixos.org/) with [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager). Once the configuration is applied and the shell is relaunched, you can enter the CLI world in the usual state of your shell.

Install Nix with the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer).

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

The configuration is selected by hostname. Check it, and if this machine is new, add `nix/hosts/<hostname>.nix` and an entry in `darwinConfigurations` in `flake.nix` (copy an existing host).

```bash
scutil --get LocalHostName
```

Apply the configuration for the first time. `darwin-rebuild` is not installed yet, so run it through `nix run`. Quote the flake reference, since zsh treats `#` as a glob.

```bash
sudo /nix/var/nix/profiles/default/bin/nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake ~/src/github.com/babarot/dotfiles
```

From the next time, open a new shell and run:

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

> [!NOTE]
> nix-darwin moves the existing `/etc/zshrc`, `/etc/zshenv` and `/etc/bashrc` aside as `*.before-nix-darwin`. home-manager does not move existing symlinks, so remove any symlink it reports as "would be clobbered" and run it again.

### Migrating a Mac that already has these apps and tools

On a Mac set up by hand (or with the old afx/Brewfile setup), a few things get in the way of the first switch:

- Vendor apps installed without Homebrew: `brew bundle` refuses to overwrite them. Put them under Homebrew first with `brew install --cask --adopt <cask>`; when the installed version differs, use `brew install --cask --force <cask>` (settings stay in `~/Library`). If it fails with "Operation not permitted", give the terminal the App Management permission in System Settings > Privacy & Security.
- Symlinks left by afx (e.g. `~/.tmux/plugins/tpm`) and extensions installed with `gh extension install`: home-manager does not move them, so remove them before switching.
- An app that moves from `/Applications` to Nix: quit the old one before moving it to the Trash. A copy still running from the Trash keeps its profile locked (Spotify showed only a black window).
- Old Homebrew formulae: uninstall with `HOMEBREW_NO_AUTOREMOVE=1` and check `brew autoremove --dry-run` before removing dependencies. Formulae from untrusted taps do not show up in `brew leaves`, and `brew untap` fails for those taps; remove `$(brew --repository)/Library/Taps/<owner>/homebrew-<repo>` instead.
- mise installed by Homebrew: after mise comes from Nix, run `mise reshim --force` so the shims stop pointing at the removed binary.
- Restart Claude Code (and other agents) from a new terminal tab; they keep the PATH of the tab they were started from.

References:

- My tools list: [nix/home/tools](https://github.com/babarot/dotfiles/tree/HEAD/nix/home/tools)
- How the shell switches between humans and AI agents: [README](https://github.com/babarot/dotfiles#shell-for-humans-and-ai-agents)

## Tmux

[tmux](https://github.com/tmux/tmux) is not installed at the moment; `.tmux.conf` and [tpm](https://github.com/tmux-plugins/tpm) (placed at `~/.tmux/plugins/tpm` by Nix) are kept for reference. To use it again, add `pkgs.tmux` to `nix/home/tools/tmux.nix`, run `tmux` and press `prefix` + <kbd>I</kbd> to install plugins.

## Some migrations

### History (Z shell)

```
cat ~/.zsh_history | pbcopy
```

Open https://gist.github.com/ to paste.

Then,

```
pbpaste >| ~/.zsh_history
```

### History (directory changes)

I use [enhancd](https://github.com/babarot/enhancd) to jump a directory. A history of directory changes is `enhancd.log` file.

```
cat ~/.enhancd/enhancd.log | pbcopy
```
Open https://gist.github.com/ to paste.

Then,
```
pbpaste >| ~/.enhancd/enhancd.log
```

# 3. Configure Apps

## 1Password

https://1password.com/

Log in with Setup Code (this is most easier among these methods).

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b2ef6f71-d7a4-4add-8926-3ea838f45cab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5472aeeb-2742-40b0-8049-3d1eee1a81bb">

Configure the appearance.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/17dd37b2-2af5-47d2-a252-daecc82ff598">

## Google Japanese IME

https://www.google.co.jp/ime/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e208b204-1f0b-4bfc-8020-23a9d6bb1761"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c8b7ae19-744d-462a-8acd-92cb72472e3d"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f57a6418-8265-4e33-ade5-c68998ce40e1"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f3fe14cf-6d5b-4d13-a7dc-933740ba49c3"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/86d09068-5b07-4a25-be97-ea912df2901e">

## iTerm2

https://iterm2.com/

### Install a colorscheme

https://ethanschoonover.com/solarized/

### Configure

Area | Guides
---|---
General | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2e708423-462b-499c-8be4-8483dbd41c2e"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/56ab5bd1-5118-4d47-9410-4a841344e546">
Appearance | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9a46b49d-c310-41ad-ab54-c3758ebae678">
Profile | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/382a5509-755b-4252-8eca-91e5a5bc22cd"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/38cacf00-5558-4831-9c79-1e9b721f1328"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/22b335f5-b439-4a8b-bc1d-b3ad5595bc4b"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b1e6c400-4ab9-42b5-8124-cb19b735140a">

## Obsidian

https://obsidian.md/

Setup Obsidian account and Vault.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd26762b-ccde-49d6-8b54-ec29f9af39b4"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d5b95ea7-dee9-4995-8704-96c02e6fb77f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd5b1ed9-500c-421a-8669-88f9f0dcb9ff"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e6972e20-8701-41a6-bb95-fb04bdbb5cc4">

Enter encryption password.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/38c94f78-668d-4c6c-b226-fece9583f3ab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9172929a-46ee-4d12-b2eb-7a0a6f421b95">

Run sync.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5f22ab4c-d7cf-4705-82ae-3cabd32764fb">

Enable [Vimrc Support](https://github.com/esm7/obsidian-vimrc-support) plugin

```
cp /path/to/.obsidian.vimrc ~/Documents/(Obsidian Vault)
```

## Things 3

https://culturedcode.com/things/

Turn on Things Cloud.

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/51c58f87-d332-4185-ba4e-1a7db0c61901">

## CleanShot X

https://cleanshot.com/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5e9b6abd-8a35-43af-9fba-9e9275acc2a8"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/4ce287ea-c36b-4510-9cd7-f9e76be0613a"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/a09beb6d-c6f5-41ae-8c28-ba8b4d0f3ec9"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e4b55262-ae18-4957-8072-b0ca2894644d">

## PopClip

https://www.popclip.app/

Install extensions from https://www.popclip.app/extensions/

- [Base64](https://www.popclip.app/extensions/x/19SiD)
- [Translate Tab](https://www.popclip.app/extensions/x/14UeG)

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9fca0072-9fee-439c-9185-52aff8d77653"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b5f685fc-188e-4de9-a06a-1ccc20ab1393">

## Spark

https://sparkmailapp.com/

Log in.

## Spotify

https://open.spotify.com/

Log in.

## Hidden Bar

https://github.com/dwarvesf/hidden

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/16f7a3db-7dbc-45c3-a335-805b59363cc0">

## Magnet

https://magnet.crowdcafe.com/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2d5c6c14-a429-4ee5-8b4e-8948a4ca3bab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/605e0be0-6c2a-4876-aa38-9c21209cb6d4">

## MeetingBar

https://meetingbar.app/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c85a5528-70ce-4df1-8193-129102ab0f32"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/85daebaa-d77c-43bc-b2d1-b956f2f2ecf2"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5a349124-dbff-40ff-9b8e-7396c0d37ebf">

## Paste

https://pasteapp.io/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8e3bb2fe-697d-4e59-a88e-a495ff016355"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/95eead1f-6ff9-415d-a1b1-384791df78ca">

## Yoink

https://eternalstorms.at/yoink/mac/

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b8a6512f-87b3-421b-9d46-20bdbf3305f2">

<img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/54620cec-6b87-41d6-a684-e58428318a2f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/ddeeabdb-5fe6-4b73-b06a-8227c50d04e9">
