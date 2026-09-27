# dotfiles

<!--
<img width="500" alt="" src="https://user-images.githubusercontent.com/4442708/222952851-12e3765b-44c2-49c2-93e5-07eb16502994.png">
-->

<img width="500" alt="" src="./etc/ss/2025-11-09.png">

Setup guide is here: [setup-mac.md](./etc/docs/setup-mac.md)

- Shell: zsh
  - Package manager: [Nix](https://nixos.org/) ([nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager))
- Terminal: [Ghostty](https://ghostty.org/)
- Editor: [Neovim](https://github.com/neovim/neovim)
- ~~Multiplexer: [tmux](https://github.com/tmux/tmux)~~
  - Plugin manager: [tpm](https://github.com/tmux-plugins/tpm) (Press `prefix` + <kbd>I</kbd> to install)
- Font: [nerd-fonts](https://github.com/ryanoasis/nerd-fonts#font-installation) (DejaVuSansMono Nerd Font Mono)

## Shell for humans and AI agents

AI agents (Claude Code, Codex, ...) now run more commands in this shell than I do, so the shell is plain by default and human UX is opt-in.

- `.zshenv` defines `is_human`: true only when stdin/stdout are a TTY and no agent marker (`CLAUDECODE`, `AI_AGENT`, ...) is set
- Agents get plain zsh: no aliases (`cp -i`, `rm` → trash, `ls` → eza), no fzf-driven `cd`, `EDITOR=true` and `PAGER=cat`, so nothing waits for input
- `.zshrc` returns early unless `is_human`; below that line come aliases, plugins, prompt, keybinds and setopts

Export `AI_AGENT=1` to force the agent side.

## Packages

CLI tools and zsh plugins are managed by Nix. GUI apps are still in the [Brewfile](./Brewfile).

```
flake.nix              # one darwinConfiguration per hostname
nix/
  darwin.nix           # system settings shared by all Macs
  hosts/<hostname>.nix # per-machine settings
  home/
    human.nix          # my.human: aliases, plugins and env for humans only
    tools/<tool>.nix   # one file per tool: its package and its shell settings
```

Each file in `nix/home/tools/` is imported automatically. It installs a tool and puts its human-only settings in `my.human`, which is rendered into `~/.config/zsh/human.zsh` and sourced after the `is_human` guard. Deleting the file removes both the tool and its settings.

```nix
# nix/home/tools/eza.nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.eza ];
  my.human.aliases.ls = "eza --group-directories-first";
}
```

My own tools (e.g. [naminator](https://github.com/babarot/naminator)) are published to [babarot/nur-packages](https://github.com/babarot/nur-packages) by GoReleaser on each release.

### Apply changes

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

New files must be tracked by git (`git add`) before Nix can see them.

### Update packages

```bash
nix flake update           # everything
nix flake update babarot   # only my own tools
```
