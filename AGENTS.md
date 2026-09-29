# AGENTS.md

Instructions for AI coding agents (Claude Code, Codex, ...) working in this repository. Claude Code reads this file because there is no CLAUDE.md here. See README.md for the overview and docs/setup-mac.md for setting up a Mac.

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
flake.nix              # inputs, one darwinConfiguration per hostname, and the formatter
nix/darwin.nix         # system settings for every Mac (allowUnfree, primaryUser)
nix/macos.nix          # macOS System Settings for every Mac (system.defaults, keyboard, Touch ID sudo)
nix/homebrew.nix       # vendor apps installed by Homebrew casks (install only)
nix/treefmt.nix        # formatters and linters behind `nix fmt`
nix/hosts/<host>.nix   # per-Mac packages, casks and App Store apps
nix/home/default.nix   # imports every file in nix/home/tools
nix/home/dotfiles.nix  # links the files in home/ (.zshrc, .gitconfig, bin, .config, ...) into ~
nix/home/env.nix       # my.env: variables for every shell, rendered to ~/.config/zsh/env.zsh
nix/home/human.nix     # my.human: human-only zsh UX, rendered to ~/.config/zsh/human.zsh
nix/home/mas.nix       # my.masApps: Mac App Store apps installed with mas
nix/home/tools/*.nix   # one file per tool: its package and its shell settings
home/                  # files linked into ~ under the same names (nix/home/dotfiles.nix)
  .zshenv, .zshrc, .zsh/ # hand-written zsh
  .gitconfig, bin/, ...
  .claude/             # Claude Code user settings, linked into ~/.claude
  skills/              # my own Agent Skills on trial, linked into ~/.claude/skills and ~/.agents/skills
  .config/             # linked to ~/.config as a whole (by activation, see dotfiles.nix)
docs/                  # setup guide (setup-mac.md) and images
.githooks/             # git hooks for this repo (pre-commit: gitleaks, nix fmt)
.claude/skills/        # repo skills for this repo (e.g. nvim-plugin-audit); not linked into ~
```

## Applying and checking changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- Run `nix fmt` before committing: nixfmt, deadnix, statix and shfmt, configured in `nix/treefmt.nix`. `nix flake check` fails on unformatted files.
- `.githooks/pre-commit` (turned on for this repo and its worktrees by an `includeIf` in `home/.gitconfig`) runs gitleaks on the staged changes and checks `nix fmt`. When it stops a commit, remove the secret or stage the reformatted files; never bypass it with `--no-verify`. A reviewed false positive goes in `.gitleaksignore`.
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).
- Quote flake references in zsh (`'nixpkgs#foo'`); `#` is a glob with extended_glob.
- Update inputs with `nix flake update` (all) or `nix flake update babarot` (own tools).
- After `nix flake update agent-skills`, run `nix build` as yourself before `sudo darwin-rebuild`: the input is a private repo fetched with your SSH key, which root does not have.

## Where things go

| What | Where |
|---|---|
| New hand-written dotfile | put it in `home/` under its name in ~ and list it in `nix/home/dotfiles.nix` (a tool's own dotfile is linked from its `nix/home/tools/<tool>.nix`, like `.tmux.conf`) |
| CLI tool with no shell settings | `nix/home/tools/packages.nix` (alphabetical) |
| CLI tool with aliases, env or a zsh hook | its own `nix/home/tools/<tool>.nix`, settings under `my.human` |
| Tool or app for one Mac only | `nix/hosts/<host>.nix` |
| zsh plugin | `my.human.plugins.<name>` with `src`, `file`, `order` (hand-written `~/.zsh` loads at 5000, zsh-abbr at 6000) |
| Variable agents also need (GOPATH, ...) | `my.env` in the tool's `nix/home/tools/<tool>.nix`; rendered to `~/.config/zsh/env.zsh`, which `.zshenv` sources |
| PATH entries, and env not tied to a tool (EDITOR, locale) | `.zshenv`, before or outside the `is_human` branch |
| GUI app that does not self-update and passes `codesign --verify --deep --strict` | `nix/home/tools/apps.nix` |
| GUI app that self-updates, needs `/Applications` or system components, or fails codesign in nixpkgs | a cask in `nix/homebrew.nix` (or the host file) |
| macOS System Settings (Dock, Finder, trackpad, ...) | `nix/macos.nix`, only values that differ from the macOS default; check the key with `defaults read` first |
| Mac App Store app | `my.masApps` in `nix/home/tools/app-store.nix` (or the host file); IDs from `mas list` |
| babarot's own tools | released with GoReleaser's `nix` publisher (or c-c-statusline's workflow) to babarot/nur-packages, then `inputs.babarot.packages.<system>.<name>` |
| Third-party tool not in nixpkgs that ships a flake | a flake input pinned to a release tag (see `crit`) |
| zsh plugin or source not in nixpkgs | a flake input with `flake = false` |
| Third-party Homebrew tap | `homebrew.brews` / `homebrew.casks` with the full `owner/tap/name`; nix-darwin marks each entry `trusted: true` |
| Per-project language or tool versions | the project's `mise.toml`, not this repo |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |
| Neovim LSP servers and treesitter parsers | `nix/home/tools/neovim.nix` (servers in `home.packages`, languages in its `languages` list); not mason or `:TSInstall` |
| Agent Skill that ships with a tool | `my.skills.<name> = <dir with SKILL.md>` next to the package (`nix/home/skills.nix` links it into `~/.claude/skills` and `~/.agents/skills`) |
| My own Agent Skill on trial | `home/skills/<name>/SKILL.md` (`nix/home/skills.nix` links each directory into `~/.claude/skills` and `~/.agents/skills`). A proving ground, not the main home: it skips the release flow of babarot/agent-skills, so edits apply at once. Keep it public-safe (nothing from work); once a skill settles, move it to babarot/agent-skills and delete it here |
| Agent Skills for Codex and other agents | babarot/agent-skills (private, fetched over SSH) linked into `~/.agents/skills` by `nix/home/tools/agent-skills.nix`; `my.agentSkills.scopes` picks the plugins (`work` only on the work Mac). Claude Code uses the plugin marketplace instead |

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
- `~/.config` links into this repo, so tools write their state here; ignore it in `home/.config/.gitignore` (never commit tokens, e.g. wrangler's).
- `home/.claude/settings.json` is edited by Claude Code itself (`/config`); those edits show up as git diffs and are expected.

## Gotchas

- home-manager moves existing regular files aside as `*.before-hm`, but not symlinks: remove old symlinks it reports as "would be clobbered".
- Claude Code restores the PATH of the terminal it was started from; restart it from a new tab after PATH changes.
- Activation scripts run with a minimal PATH (no awk, grep); use bash builtins or store paths.
- Binaries built by `deno compile` break if Nix strips them; package them with `dontFixup = true`.
- Replacing an app: quit the old one before trashing it, or a copy running from the Trash keeps its profile locked.
- `claude` must resolve to `~/.local/bin/claude`. A copy installed with `npm install -g @anthropic-ai/claude-code` into a mise-managed node gets a mise shim, which comes first on PATH and hides the official one; remove it and run `mise reshim --force`.
