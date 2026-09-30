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
- Agents get plain zsh: no aliases (`cp -i`, `rm` → trash, `ls` → eza), no fzf-driven `cd`, `EDITOR=true` and `PAGER=cat`, so nothing waits for input
- `.zshrc` returns early unless `is_human`; below that line come aliases, plugins, prompt, keybinds and setopts

Export `AI_AGENT=1` to force the agent side.

## Docs

- [Setting up a Mac](./docs/setup-mac.md)
- [Structure](./docs/structure.md): how the flake is organized, packages, Agent Skills, applying and updating
