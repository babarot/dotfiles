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

Each tool is installed and configured in one file under `nix/home-manager/tools/`, imported automatically. Adding a tool is adding a file, and deleting the file is all it takes to remove it. Three properties make that safe:

- Cohesion: deleting a tool's file removes everything that was for it (package, aliases, variables, plugins), so nothing outlives the tool. What is removed together shares a file:
  - a tool and its own settings: `eza.nix`
  - a main tool and the companions that exist only for it: `gh.nix`, with delta and lazygit for gh-dash
  - tools used together for one subject: `kubernetes.set.nix`
  - tools with no settings, one per line: `packages.nix`
- Loose coupling: deleting a tool's file breaks nothing else. A tool used inside another's settings is referenced by its store path, not through PATH. In the example below, `bat-theme` keeps working after `fzf.nix`, and `fzf` on PATH with it, is deleted.
- Reproducibility: a new Mac gets the same thing. Everything is declared here and pinned by `flake.lock`; what Nix cannot hold (self-updating apps, Claude Code) is declared as an exception, and a switch removes or flags what was installed by hand.

A tool's settings sit next to its package, by who they are for:

- `my.human`: humans only, rendered into `~/.config/zsh/human.zsh` and sourced after the `is_human` guard
- `my.env`: variables agents need too (`GOPATH`, ...)
- `my.ai`: settings only agents get, sourced by `.zshenv` for agents only

Files for one Mac live in `nix/hosts/<host>/` and are imported only there. The rules are in [AGENTS.md](./AGENTS.md#principles), and how Nix makes the properties hold is in [docs/concepts/dependencies.md](./docs/concepts/dependencies.md).

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
  bin/                   # scripts still being shaped (settled ones are in Nix)
  skills/                # my own Agent Skills on trial
  ...
docs/                    # guides, concepts and reference (see docs/README.md)
```

What a listing does not show is in [AGENTS.md](./AGENTS.md#layout).

## Apply changes

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

New files must be tracked by git (`git add`) before Nix can see them. Updating packages is in [maintenance.md](./docs/guides/maintenance.md#update-flake-inputs).

## Docs

- [Setting up a Mac](./docs/guides/setup-mac.md)
- Everything else (how things work, how to maintain them, why they are this way) is indexed in [docs/](./docs/README.md)
