# Structure

How this flake is organized, where packages come from, and how to apply and update it. Setting up a new Mac is in [setup-mac.md](../guides/setup-mac.md).

## Two Macs, one flake

Two Macs share this flake: `pro23` (private) and `PC-M-2025-026` (work). `darwin-rebuild` picks the configuration by `scutil --get LocalHostName`; anything outside `nix/hosts/` applies to both.

## Layout

```ini
flake.nix              # inputs, one darwinConfiguration per hostname, and the formatter
nix/
  darwin.nix           # system settings for every Mac (allowUnfree, primaryUser)
  macos.nix            # macOS System Settings for every Mac (system.defaults, keyboard, Touch ID sudo)
  homebrew.nix         # vendor apps installed by Homebrew casks (install only)
  treefmt.nix          # formatters and linters behind `nix fmt`
  hosts/<host>.nix     # per-Mac packages, casks and App Store apps
  home-manager/
    default.nix        # imports every file in nix/home-manager/tools
    dotfiles.nix       # links the files in home/ (.zshrc, .gitconfig, bin, .config, ...) into ~
    env.nix            # my.env: variables for every shell, rendered to ~/.config/zsh/env.zsh
    herdr-plugins.nix  # my.herdrPlugins: herdr plugins linked on every switch
    human.nix          # my.human: human-only zsh UX, rendered to ~/.config/zsh/human.zsh
    mas.nix            # my.masApps: Mac App Store apps installed with mas
    skills.nix         # my.skills: Agent Skills shipped with tools or on trial in home/skills
    tools/<tool>.nix   # one file per tool: its package and its shell settings
    tools/<other>      # a tool's scripts and patches beside it (only *.nix is imported)
home/                  # files linked into ~ under the same names (nix/home-manager/dotfiles.nix)
  .zshenv, .zshrc, .zsh/ # hand-written zsh
  .gitconfig, bin/, ...
  .claude/             # Claude Code user settings, linked into ~/.claude
  skills/              # my own Agent Skills on trial, linked into ~/.claude/skills and ~/.agents/skills
  .config/             # linked to ~/.config as a whole (by activation, see dotfiles.nix)
docs/                  # guides/, concepts/, reference/ and images (docs/README.md)
.githooks/             # git hooks for this repo (pre-commit: gitleaks, nix fmt; pre-push: builds every Mac)
.github/workflows/     # CI: nix flake check and evaluating every Mac
.claude/skills/        # repo skills for this repo (e.g. nvim-plugin-audit); not linked into ~
```

## Packages

How a tool file is written is in the [README](../../README.md#one-file-per-tool).

Everything is declared in the flake and installed by `darwin-rebuild switch`:

- CLI tools, zsh plugins, fonts and most GUI apps: Nix
- Mac App Store apps: `mas`, from the list in [app-store.nix](../../nix/home-manager/tools/app-store.nix)
- Vendor apps that update themselves or install system components (1Password, Chrome, Docker, ...): Homebrew casks in [homebrew.nix](../../nix/homebrew.nix), used only to install them

Nothing is pinned for App Store or vendor apps; only a missing app is installed.

My own tools (e.g. [naminator](https://github.com/babarot/naminator)) are published to [babarot/nur-packages](https://github.com/babarot/nur-packages) by GoReleaser on each release.

Herdr is built from nixpkgs with small patches, one per change ([herdr.nix](../../nix/home-manager/tools/herdr.nix)).

## Agent Skills

Agent Skills for Codex and other agents come from [babarot/agent-skills](https://github.com/babarot/agent-skills) (private, fetched over SSH) and are linked into `~/.agents/skills`. Claude Code gets the same skills from the plugin marketplace.

`home/skills/` is a proving ground for new skills of my own. Each directory there is linked into both `~/.claude/skills` and `~/.agents/skills`, pointing at this repo, so a skill can be tried without releasing babarot/agent-skills. Once a skill settles, it moves to babarot/agent-skills.

## Apply changes

```bash
sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles
```

New files must be tracked by git (`git add`) before Nix can see them.

## Update packages

```bash
nix flake update           # everything
nix flake update babarot   # only my own tools
```

After `nix flake update agent-skills`, run `nix build ".#darwinConfigurations.$(scutil --get LocalHostName).system" --no-link` as yourself before `sudo darwin-rebuild`, since root has no SSH key for the private repo.
