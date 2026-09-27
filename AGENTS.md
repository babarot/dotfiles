# AGENTS.md

Instructions for AI coding agents (Claude Code, Codex, ...) working in this repository. Claude Code reads this file because there is no CLAUDE.md here. See README.md for the overview and etc/docs/setup-mac.md for setting up a Mac.

## What this repo is

babarot's macOS environment, shared by two Macs through one Nix flake (nix-darwin + home-manager):

| Hostname | Machine | Host file |
|---|---|---|
| `pro23` | private Mac | `nix/hosts/pro23.nix` |
| `PC-M-2025-026` | work Mac | `nix/hosts/PC-M-2025-026.nix` |

`darwin-rebuild` picks the configuration by `scutil --get LocalHostName`. Anything not in a host file applies to both Macs. The work Mac is operated by a separate agent session on that machine; changes for it are made here, pushed, then pulled and applied there.

This repository is public. Never commit credentials, tokens, or internal names from work (company, org, internal hosts or repos).

## Layout

```
flake.nix              # inputs and one darwinConfiguration per hostname
nix/darwin.nix         # system settings for every Mac (allowUnfree, primaryUser)
nix/homebrew.nix       # vendor apps installed by Homebrew casks (install only)
nix/hosts/<host>.nix   # per-Mac packages, casks and App Store apps
nix/home/default.nix   # imports every file in nix/home/tools
nix/home/human.nix     # my.human: human-only zsh UX, rendered to ~/.config/zsh/human.zsh
nix/home/mas.nix       # my.masApps: Mac App Store apps installed with mas
nix/home/tools/*.nix   # one file per tool: its package and its shell settings
claude/                # Claude Code user settings, linked into ~/.claude
.zshenv, .zshrc, .zsh/ # hand-written zsh, linked into ~ by `make install`
.config/               # linked to ~/.config as a whole
```

## Applying and checking changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).
- Quote flake references in zsh (`'nixpkgs#foo'`); `#` is a glob with extended_glob.
- Update inputs with `nix flake update` (all) or `nix flake update babarot` (own tools).

## Where things go

| What | Where |
|---|---|
| CLI tool with no shell settings | `nix/home/tools/packages.nix` (alphabetical) |
| CLI tool with aliases, env or a zsh hook | its own `nix/home/tools/<tool>.nix`, settings under `my.human` |
| Tool or app for one Mac only | `nix/hosts/<host>.nix` |
| zsh plugin | `my.human.plugins.<name>` with `src`, `file`, `order` (hand-written `~/.zsh` loads at 5000, zsh-abbr at 6000) |
| Environment agents also need (PATH, EDITOR, ...) | `.zshenv`, before or outside the `is_human` branch |
| GUI app that does not self-update and passes `codesign --verify --deep --strict` | `nix/home/tools/apps.nix` |
| GUI app that self-updates, needs `/Applications` or system components, or fails codesign in nixpkgs | a cask in `nix/homebrew.nix` (or the host file) |
| Mac App Store app | `my.masApps` in `nix/home/tools/app-store.nix` (or the host file); IDs from `mas list` |
| babarot's own tools | released with GoReleaser's `nix` publisher (or c-c-statusline's workflow) to babarot/nur-packages, then `inputs.babarot.packages.<system>.<name>` |
| Third-party tool not in nixpkgs that ships a flake | a flake input pinned to a release tag (see `crit`) |
| zsh plugin or source not in nixpkgs | a flake input with `flake = false` |
| Third-party Homebrew tap | `homebrew.brews` / `homebrew.casks` with the full `owner/tap/name`; nix-darwin marks each entry `trusted: true` |
| Per-project language or tool versions | the project's `mise.toml`, not this repo |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |

Before adding a nixpkgs package, check it is the same tool: several names belong to something else (`yq` is Python's, use `yq-go`; `mmv` is not itchyny's, use `mmv-go`; `pup`, `ktop`, `kubesec`, `gist` differ too).

## Shell: AI agents by default, human UX opt-in

- `.zshenv` defines `is_human`: stdin/stdout are a TTY and no agent marker (`CLAUDECODE`, `AI_AGENT`, ...) is set. Agents get `EDITOR=true`, `PAGER=cat`, `GIT_TERMINAL_PROMPT=0`, so nothing blocks on input.
- `.zshrc` returns early unless `is_human`. Aliases (`cp -i`, `rm` → gomi, `ls` → eza), enhancd's `cd`, prompt, keybinds and setopts exist only for humans.
- Never put aliases, prompts or interactive behavior where agents run (`.zshenv`, non-interactive paths).
- Keep macOS's BSD userland on PATH; agents write BSD syntax (`sed -i ''`, `stat -f`). GNU tools only under other names (`timeout`, `gsed`).
- Login shells read only `.zshenv` and `.zshrc`; there is no `.zprofile` on purpose.

## Conventions

- English for comments, commit messages and docs; this repo is public.
- Commit messages: an imperative summary line, then a short body explaining why. No Claude session links or attribution trailers.
- One file per tool; keep lists alphabetical; say in a comment why anything unusual is there.
- `~/.config` links into this repo, so tools write their state here; ignore it in `.config/.gitignore` (never commit tokens, e.g. wrangler's).
- `claude/settings.json` is edited by Claude Code itself (`/config`); those edits show up as git diffs and are expected.

## Gotchas

- home-manager moves existing regular files aside as `*.before-hm`, but not symlinks: remove old symlinks it reports as "would be clobbered".
- Claude Code restores the PATH of the terminal it was started from; restart it from a new tab after PATH changes.
- Activation scripts run with a minimal PATH (no awk, grep); use bash builtins or store paths.
- Binaries built by `deno compile` break if Nix strips them; package them with `dontFixup = true`.
- Replacing an app: quit the old one before trashing it, or a copy running from the Trash keeps its profile locked.
