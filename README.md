# dotfiles

<img width="500" alt="" src="./docs/images/2025-11-09.png">

My macOS environment for two Macs, declared in one Nix flake ([nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager)).

- Shell: zsh, plain for AI agents with opt-in UX for humans (see below)
- Terminal: [Ghostty](https://ghostty.org/) + [Herdr](https://herdr.dev/), one workspace per git worktree for Claude Code and Codex
- Editor: [Neovim](https://github.com/neovim/neovim)
- Packages: [Nix](https://nixos.org/); Homebrew casks and mas only for apps Nix can't handle well

## Shell for humans and AI agents

AI agents (Claude Code, Codex, ...) now run more commands in this shell than I do, so the shell is plain by default and human UX is opt-in.

- `.zshenv` defines `is_human`: true only when stdin/stdout are a TTY and no agent marker (`CLAUDECODE`, `AI_AGENT`, ...) is set
- Agents get plain zsh: no aliases (`cp -i`, `ls` → eza), no fzf-driven `cd`, `EDITOR=true` and `PAGER=cat`, so nothing waits for input
- One alias is theirs too: `rm` is [gomi](https://github.com/babarot/gomi), which takes rm's flags, so agents use it as the rm they know and a mistaken delete goes to the trash
- `.zshrc` returns early unless `is_human`; below that line come aliases, plugins, prompt, keybinds and setopts

Export `AI_AGENT=1` to force the agent side.

## One file per tool

A tool is installed and configured in the same place. Each file under `nix/home-manager/tools/` holds a tool's package together with its environment variables, aliases, functions and zsh plugins, and is imported automatically. Adding a tool means adding a file; deleting the file removes the tool and everything it set, so no alias or variable outlives the tool it was for. What is removed together shares a file: tools that exist only for a main tool sit in its file (`gh.nix` has delta and lazygit for gh-dash), and peer tools for one subject share a group, named `<subject>.group.nix` so it is not mistaken for a tool. Tools that merely share a kind, such as linters, are never grouped. Files for one Mac only live in `nix/hosts/<host>/` and are imported only there. The rules are in [AGENTS.md](./AGENTS.md#one-file-one-unit). A tool used inside another's settings is referenced by its store path, not through PATH: in the example below, `bat-theme` keeps working if `fzf.nix`, and with it `fzf` on PATH, is deleted.

Settings for humans go in `my.human`, rendered into `~/.config/zsh/human.zsh` and sourced after the `is_human` guard, so agents never see them. Variables agents also need (`GOPATH`, ...) go in `my.env`, and settings only agents get go in `my.ai`, sourced by `.zshenv` for agents only.

```nix
# nix/home-manager/tools/bat.nix
{ lib, pkgs, ... }:
let
  # Used inside bat-theme only; fzf on PATH is fzf.nix's
  fzf = lib.getExe pkgs.fzf;
in
{
  home.packages = [ pkgs.bat ];

  my.human.env = {
    BAT_PAGER = "less -RF";
    BAT_STYLE = "numbers,changes";
    BAT_THEME = "DarkNeon";
  };

  # Agents read bat's output, not scroll it
  my.ai.env.BAT_PAGER = "cat";

  my.human.init = ''
    bat-theme() {
      local file=$1
      if [[ -z $file ]]; then
        file=$(${fzf})
      fi
      bat --list-themes | ${fzf} --preview="bat --theme={} --color=always ''${file}"
    }
  '';
}
```

## Layout

```ini
flake.nix                # one configuration per Mac
nix/
  darwin.nix, macos.nix  # system settings and macOS System Settings for every Mac
  homebrew.nix           # vendor apps installed by Homebrew casks
  hosts/                 # per-Mac packages, casks and App Store apps
  home-manager/          # dotfile links, shell env, one file per tool in tools/
  ...
home/                    # hand-written dotfiles, linked into ~ under the same names
  .zshenv, .zshrc, .zsh/ # zsh
  .config/               # linked to ~/.config as a whole
  .claude/               # Claude Code user settings
  bin/                   # my scripts
  skills/                # my own Agent Skills on trial
  ...
docs/                    # guides, concepts and reference (see docs/README.md)
```

The full tree is in [docs/reference/structure.md](./docs/reference/structure.md#layout).

## Apply changes

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

New files must be tracked by git (`git add`) before Nix can see them. Updating packages is in [maintenance.md](./docs/guides/maintenance.md#update-flake-inputs).

## Docs

- [Setting up a Mac](./docs/guides/setup-mac.md)
- Everything else (how things work, how to maintain them, why they are this way) is indexed in [docs/](./docs/README.md)
