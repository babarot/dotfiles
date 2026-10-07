# Set up a Mac

The first `darwin-rebuild switch` installs everything this repo declares: CLI tools, apps (casks, App Store apps, Nix apps), Homebrew itself, the dotfiles links in `$HOME`, and the System Settings in [nix/macos.nix](../../nix/macos.nix). This page is what comes before it, the switch itself, and what is left by hand after it.

For a Mac that was already set up by hand, read [migrate-mac.md](./migrate-mac.md) before the first switch.

## 1. Before the first switch

### Sign in to the App Store

App Store apps are installed by the switch with [mas](https://github.com/mas-cli/mas), which needs a signed-in App Store. An app that fails to install only prints a warning; switching again after signing in installs it.

### Install the Command Line Tools

They provide git, which cloning this repo needs.

```bash
xcode-select --install
```

### Register an SSH key with GitHub

The key is used to clone this repo and to fetch the private `agent-skills` input.

```bash
ssh-keygen -t ed25519 -C "babarot@gmail.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Paste it at https://github.com/settings/ssh/new, then check that it works:

```console
$ ssh -T git@github.com
Hi babarot! You've successfully authenticated, but GitHub does not provide shell access.
```

### Clone this repo

Keep this exact path: the links into `$HOME` and the `darwin-rebuild` commands point at it.

```bash
git clone git@github.com:babarot/dotfiles.git ~/src/github.com/babarot/dotfiles
```

### Add this Mac as a host

The switch picks its configuration by hostname, and stops with an error for a hostname that [flake.nix](../../flake.nix) does not list. Check it before installing Nix:

```bash
scutil --get LocalHostName
```

If the name is in the host table in [AGENTS.md](../../AGENTS.md), go on. Otherwise add it, starting from the Mac it is most like:

| This Mac is | Start from |
|---|---|
| private | `pro23` |
| work | `PC-M-2025-026` |

1. Copy `nix/hosts/<base>.nix` to `nix/hosts/<hostname>.nix`, and `nix/hosts/<base>/` to `nix/hosts/<hostname>/` if it exists. Drop what this Mac does not need.
2. Add `"<hostname>" = mkHost "<hostname>";` to `darwinConfigurations` in [flake.nix](../../flake.nix).
3. `git add` the new files. Nix only sees files tracked by git.
4. Add the Mac to the host table in [AGENTS.md](../../AGENTS.md).
5. Commit and push once the first switch works.

Everything outside the host files applies to every host, so the new Mac gets the shared setup as it is.

### Install Nix

With the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer):

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 2. The first switch

Build the configuration as yourself first. `agent-skills` is fetched over SSH with your key, which root does not have; once it is in the Nix store, the `sudo` run finds it there.

```bash
nix build "$HOME/src/github.com/babarot/dotfiles#darwinConfigurations.$(scutil --get LocalHostName).system" --no-link
```

Then apply it. `darwin-rebuild` is not installed yet, so it runs through `nix run`. Quote the flake reference, since zsh treats `#` as a glob.

```bash
sudo /nix/var/nix/profiles/default/bin/nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake ~/src/github.com/babarot/dotfiles
```

> [!NOTE]
> nix-darwin moves the existing `/etc/zshrc`, `/etc/zshenv` and `/etc/bashrc` aside as `*.before-nix-darwin`. home-manager does not move existing symlinks: remove any it reports as "would be clobbered" and run it again.

Restart the Mac when it finishes. Some of what was installed, such as Google Japanese Input, only works after a restart. Open a new terminal afterwards; until the switch, the shell was plain macOS zsh.

## 3. After the switch

### Bring history from the old Mac

Copy these files from the old Mac with AirDrop, or with `scp` when Remote Login is on there. Shell history can hold tokens, so do not pass it through a gist or any other service.

| File | What it is |
|---|---|
| `~/.zsh_history` | zsh history |
| `~/.enhancd/enhancd.log` | directory history for [enhancd](https://github.com/babarot/enhancd) |
| `~/.claude/vault.db` | the [claude-recall](https://github.com/babarot/claude-recall) archive of Claude Code sessions, including those whose transcripts Claude Code has deleted |

```bash
scp <old-mac>.local:.zsh_history ~/.zsh_history
scp <old-mac>.local:.enhancd/enhancd.log ~/.enhancd/enhancd.log
```

The archive is a SQLite database written while Claude Code runs, so copy a snapshot of it rather than the file itself. On the old Mac:

```bash
sqlite3 ~/.claude/vault.db ".backup '$HOME/vault.db'"
```

On the new Mac, quit Claude Code and `recall ui` first, put the snapshot in place, then import the sessions the new Mac already has:

```bash
rm -f ~/.claude/vault.db-wal ~/.claude/vault.db-shm
mv ~/vault.db ~/.claude/vault.db
recall import
```

The old Mac's sessions can then be read and searched, and recalled into a new claude with `c`, but not resumed with `claude -r`: Claude Code resumes only from the transcripts in `~/.claude/projects`, which are not copied.

### macOS settings left by hand

These are not declared in [nix/macos.nix](../../nix/macos.nix).

| Setting | How |
|---|---|
| Finder sidebar | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/7309a814-3c5f-4a88-8146-ed4f91dbac95"> |
| Displays | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/1ff3f3a1-a052-478b-b9da-8c317a6d6030"> |
| Touch ID fingerprints | <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c61af4f6-4673-48ef-afb8-2c1876e27439"> |
| Input sources | Add Google Japanese Input under System Settings > Keyboard > Input Sources and allow it when asked. <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8f3f919e-700e-4d1a-bb8a-dea3eed53822"> |
| Dock contents | Add apps by hand. |

Do not enable an input source with `defaults write` or the TIS API: macOS records the consent only when the source is added in System Settings, so a source enabled another way asks for consent again on every switch.

### Sign in to apps and set them up

Apps marked "work" are only on the work Mac; the rest are on both.

| App | What to do |
|---|---|
| 1Password | Sign in with the Setup Code, then set the appearance. <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b2ef6f71-d7a4-4add-8926-3ea838f45cab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5472aeeb-2742-40b0-8049-3d1eee1a81bb"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/17dd37b2-2af5-47d2-a252-daecc82ff598"> |
| Google Japanese Input | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e208b204-1f0b-4bfc-8020-23a9d6bb1761"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c8b7ae19-744d-462a-8acd-92cb72472e3d"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f57a6418-8265-4e33-ade5-c68998ce40e1"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/f3fe14cf-6d5b-4d13-a7dc-933740ba49c3"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/86d09068-5b07-4a25-be97-ea912df2901e"> |
| Obsidian | Sign in, open the vault, enter the encryption password and run sync. Enable the [Vimrc Support](https://github.com/esm7/obsidian-vimrc-support) plugin and copy the vimrc: `cp ~/src/github.com/babarot/dotfiles/home/.obsidian.vimrc ~/Documents/<vault>/` <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd26762b-ccde-49d6-8b54-ec29f9af39b4"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/d5b95ea7-dee9-4995-8704-96c02e6fb77f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/bd5b1ed9-500c-421a-8669-88f9f0dcb9ff"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e6972e20-8701-41a6-bb95-fb04bdbb5cc4"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/38c94f78-668d-4c6c-b226-fece9583f3ab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9172929a-46ee-4d12-b2eb-7a0a6f421b95"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5f22ab4c-d7cf-4705-82ae-3cabd32764fb"> |
| Things 3 | Turn on Things Cloud. <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/51c58f87-d332-4185-ba4e-1a7db0c61901"> |
| CleanShot X | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5e9b6abd-8a35-43af-9fba-9e9275acc2a8"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/4ce287ea-c36b-4510-9cd7-f9e76be0613a"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/a09beb6d-c6f5-41ae-8c28-ba8b4d0f3ec9"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/e4b55262-ae18-4957-8072-b0ca2894644d"> |
| PopClip | Install the [Base64](https://www.popclip.app/extensions/x/19SiD) and [Translate Tab](https://www.popclip.app/extensions/x/14UeG) extensions. <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/9fca0072-9fee-439c-9185-52aff8d77653"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b5f685fc-188e-4de9-a06a-1ccc20ab1393"> |
| Spark | Sign in. |
| Spotify | Sign in. |
| Hidden Bar | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/16f7a3db-7dbc-45c3-a335-805b59363cc0"> |
| Magnet | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/2d5c6c14-a429-4ee5-8b4e-8948a4ca3bab"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/605e0be0-6c2a-4876-aa38-9c21209cb6d4"> |
| MeetingBar (work) | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/c85a5528-70ce-4df1-8193-129102ab0f32"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/85daebaa-d77c-43bc-b2d1-b956f2f2ecf2"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/5a349124-dbff-40ff-9b8e-7396c0d37ebf"> |
| Paste | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/8e3bb2fe-697d-4e59-a88e-a495ff016355"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/95eead1f-6ff9-415d-a1b1-384791df78ca"> |
| Yoink | Settings: <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/b8a6512f-87b3-421b-9d46-20bdbf3305f2"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/54620cec-6b87-41d6-a684-e58428318a2f"> <img width="200" alt="" src="https://github.com/babarot/dotfiles/assets/4442708/ddeeabdb-5fe6-4b73-b06a-8227c50d04e9"> |

## 4. From then on

Apply changes with:

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

Each switch also uninstalls Homebrew casks and brews that no file declares, so an app installed with `brew install` by hand goes away; declare it instead ([where-things-go.md](../reference/where-things-go.md)).

Updating inputs (after an `agent-skills` update, build as yourself first) is in [maintenance.md](./maintenance.md#update-flake-inputs).

## Appendix: hardware

- HHKB: https://happyhackingkb.com/jp/download/, [manual](https://origin.pfultd.com/downloads/hhkb/manual/P3PC-6641-05.pdf)
- Logicool mouse: https://www.logicool.co.jp/ja-jp/setup/ergosetup/mouse-setup/bluetooth.html
