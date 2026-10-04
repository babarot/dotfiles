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
  hosts/<host>/*.nix   # per-Mac tool files with settings (e.g. kubernetes.set.nix), imported for that Mac only
  home-manager/
    default.nix        # imports every file in nix/home-manager/tools
    ai.nix             # my.ai: agent-only zsh settings, rendered to ~/.config/zsh/ai.zsh
    dotfiles.nix       # links the files in home/ (.zshrc, .gitconfig, bin, .config, ...) into ~
    env.nix            # my.env, my.path: variables and PATH entries for every shell, rendered to ~/.config/zsh/env.zsh
    git.nix            # my.gitConfig: tools' git settings, rendered to ~/.config/git/tools.gitconfig
    fork-patches.nix   # my.forkPatches: packages patched from a fork's patches branch
    herdr-plugins.nix  # my.herdrPlugins: herdr plugins linked on every switch
    human.nix          # my.human: human-only zsh UX, rendered to ~/.config/zsh/human.zsh
    mas.nix            # my.masApps: Mac App Store apps installed with mas
    skills.nix         # my.skills: Agent Skills shipped with tools or on trial in home/skills
    stray-bins.nix     # my.knownBins: warns on switch about commands nothing declares in ~/.local/bin, ~/go/bin
    tools/<tool>.nix   # one lifecycle per file: a single tool, a tool with companions, a <subject>.set.nix or a list (AGENTS.md, "One file, one lifecycle")
    tools/<other>      # a tool's scripts and patches beside it (only *.nix is imported)
home/                  # files linked into ~ under the same names (nix/home-manager/dotfiles.nix)
  .zshenv, .zshrc, .zsh/ # hand-written zsh
  .gitconfig, bin/, ...  # bin/: scripts still being shaped; settled ones are in tools/
  .claude/             # Claude Code user settings, linked into ~/.claude
  skills/              # my own Agent Skills on trial, linked into ~/.claude/skills and ~/.agents/skills
  .config/             # linked to ~/.config as a whole (by activation, see dotfiles.nix)
docs/                  # guides/, concepts/, reference/ and images (docs/README.md)
.githooks/             # git hooks for this repo (pre-commit: gitleaks, nix fmt, check-patches; pre-push: builds every Mac, warns about unimported patches)
.github/workflows/     # CI: nix flake check and evaluating every Mac; check-patches when patch files change
.claude/skills/        # repo skills for this repo (e.g. nvim-plugin-audit, import-fork-patches); not linked into ~
```

## Packages

How a tool file is written is in the [README](../../README.md#one-file-per-tool).

Everything is declared in the flake and installed by `darwin-rebuild switch`:

- CLI tools, zsh plugins, fonts and most GUI apps: Nix
- Mac App Store apps: `mas`, from the list in [app-store.nix](../../nix/home-manager/tools/app-store.nix)
- Vendor apps that update themselves or install system components (1Password, Chrome, Docker, ...): Homebrew casks in [homebrew.nix](../../nix/homebrew.nix), used only to install them

Nothing is pinned for App Store or vendor apps; only a missing app is installed.

My own tools (e.g. [naminator](https://github.com/babarot/naminator)) are published to [babarot/nur-packages](https://github.com/babarot/nur-packages) by GoReleaser on each release.

Herdr, mo and gh-news are built with small patches, one per change, exported from the `patches` branch of a fork and declared with `my.forkPatches` ([modules.md](../concepts/modules.md#myforkpatches), [maintenance.md](../guides/maintenance.md#patch-a-package-from-a-fork-branch)).

## Agent Skills

Where the skills come from and where each is linked is in [ai-agents.md](../concepts/ai-agents.md#skills).

## Apply and update

Applying a change is in the [README](../../README.md#apply-changes); updating inputs is in [maintenance.md](../guides/maintenance.md#update-flake-inputs).
