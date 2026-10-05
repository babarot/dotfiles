# dotfiles

<img width="500" alt="" src="./docs/images/2025-11-09.png">

My macOS environment for two Macs, declared in one Nix flake ([nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager)).

- Terminal: [Ghostty](https://ghostty.org/) + [Herdr](https://herdr.dev/), one workspace per git worktree for Claude Code and Codex
- Editor: [Neovim](https://github.com/neovim/neovim)
- Packages: [Nix](https://nixos.org/)

## Shell for humans and AI agents

AI agents (Claude Code, Codex, ...) now run more commands in this shell than I do, so the shell is plain by default and human UX is opt-in.

- `.zshenv` defines `is_human`: true only when stdin/stdout are a TTY and no agent marker (`CLAUDECODE`, `AI_AGENT`, ...) is set
- Agents get plain zsh: none of the human aliases (`cp -i`, `ls` → eza), no fzf-driven `cd`, `EDITOR=true` and `PAGER=cat`, so nothing waits for input
- `.zshrc` returns early unless `is_human`; below that line come aliases, plugins, prompt, keybinds and setopts

Export `AI_AGENT=1` to force the agent side.

## One file, one lifecycle

What is added and removed together is installed and configured in one file under `nix/home-manager/tools/` (or `nix/hosts/<host>/` for one Mac), imported automatically: usually one tool, sometimes a tool with its companions or a set, like the Kubernetes tools below. Adding a tool is adding a file, and deleting the file is all it takes to remove it. Three properties make that safe:

- Cohesion: deleting a tool's file removes everything that was for it (package, aliases, variables, plugins), so nothing outlives the tool.
- Loose coupling: deleting a tool's file breaks nothing else. A tool used inside another's settings is referenced by its store path, not through PATH. In the example below, kubectx's picker keeps working after `fzf.nix`, and `fzf` on PATH with it, is deleted.
- Reproducibility: a new Mac gets the same thing. Everything is declared here and pinned by `flake.lock`; what Nix cannot hold (self-updating apps through Homebrew casks, Claude Code) is declared as an exception.

A tool's settings sit next to its package, by who they are for: `my.human` for humans only, `my.ai` for agents only, `my.env` for both. The rules are in [AGENTS.md](./AGENTS.md#principles), and how Nix makes the properties hold is in [docs/concepts/dependencies.md](./docs/concepts/dependencies.md).

```nix
# nix/hosts/PC-M-2025-026/kubernetes.set.nix (abridged)
# A set: the Kubernetes tools, added and removed together with this file
{ lib, pkgs, ... }:
let
  # kubectx runs fzf for its picker, looking it up on PATH by name. This wraps
  # kubectx so it finds fzf by its path in the Nix store instead: deleting
  # fzf.nix takes fzf off PATH, but not away from kubectx.
  kubectx = pkgs.symlinkJoin {
    name = "kubectx-with-fzf";
    paths = [ pkgs.kubectx ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/kubectx --suffix PATH : ${lib.makeBinPath [ pkgs.fzf ]}
    '';
  };
in
{
  # Installed by this file, and uninstalled when it is deleted
  home.packages = with pkgs; [
    helmfile
    kubectl
    kubectx # the wrapped one above
    kustomize
  ];

  # For humans only: agents never get this abbreviation
  my.human.plugins.zsh-abbr.init = ''
    abbr --session --quiet k=kubectl
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
  home-manager/          # dotfile links, shell env, tool files in tools/
  ...
home/                    # hand-written dotfiles, linked into ~ under the same names
  .zshenv, .zshrc, .zsh/ # zsh
  .config/               # linked to ~/.config as a whole
  .claude/               # Claude Code user settings
  bin/                   # scripts still being shaped
  skills/                # my own Agent Skills on trial
  ...
docs/                    # guides, concepts and reference (see docs/README.md)
```

## Apply changes

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

Updating packages is in [maintenance.md](./docs/guides/maintenance.md#update-flake-inputs).

## Docs

- [Setting up a Mac](./docs/guides/setup-mac.md)
- Everything else (how things work, how to maintain them, why they are this way) is indexed in [docs/](./docs/README.md)
