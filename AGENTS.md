# AGENTS.md

Instructions for AI coding agents (Claude Code, Codex, ...) working in this repository. Claude Code reads this file because there is no CLAUDE.md here. See README.md for the overview, docs/reference/structure.md for the layout and docs/guides/setup-mac.md for setting up a Mac.

## What this repo is

babarot's macOS environment, shared by two Macs through one Nix flake (nix-darwin + home-manager):

| Hostname | Machine | Host file |
|---|---|---|
| `pro23` | private Mac | `nix/hosts/pro23.nix` |
| `PC-M-2025-026` | work Mac | `nix/hosts/PC-M-2025-026.nix` |

`darwin-rebuild` picks the configuration by `scutil --get LocalHostName`. Anything not in a host file applies to both Macs. The work Mac is operated by a separate agent session on that machine; changes for it are made here, pushed, then pulled and applied there.

This repository takes no PRs: work is done in a git worktree and landed in main with `git land` (`--push` to push), which the `/land` skill wraps. Land or push only when the user asks.

This repository is public. Never commit credentials, tokens, or internal names from work (company, org, internal hosts or repos).

## Layout

The directory tree, with what each file is for, is in [docs/reference/structure.md](./docs/reference/structure.md#layout). Read it before adding or moving files.

Do not add a directory at the repository root without a strong reason; put new files under `nix/`, `home/` or `docs/`. The README describes the root directories, so each new one means editing it too.

## Applying and checking changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- Run `nix fmt` before committing: nixfmt, deadnix, statix and shfmt, configured in `nix/treefmt.nix`. `nix flake check` fails on unformatted files.
- `.githooks/pre-commit` (turned on for this repo and its worktrees by an `includeIf` in `home/.gitconfig`) runs gitleaks on the staged changes and checks `nix fmt`; when patch files are staged, `.githooks/check-patches` checks they are exported from the fork's pushed `patches` branch. When it stops a commit, remove the secret or stage the reformatted files; never bypass it with `--no-verify`. A reviewed false positive goes in `.gitleaksignore`.
- `.githooks/pre-push` builds every Mac at the pushed commit when the push changes Nix files, and warns (without stopping the push) when a fork's `patches` branch has moved ahead of the patch files; import it with the import-fork-patches skill. It uses the local store and the real `agent-skills`, so it is quick unless nixpkgs moved. When it fails, fix the build; do not push with `--no-verify`.
- CI (`.github/workflows/nix.yaml`) runs `nix flake check` and evaluates every Mac's system derivation on pushes to main and PRs that touch Nix files. It does not build them: a fresh runner rebuilds everything (~15 min), which the pre-push hook does locally from a warm store. It cannot fetch the private `agent-skills` input, so it overrides it with an empty stub made in the job; a change that only breaks with the real skills passes CI.
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).
- Quote flake references in zsh (`'nixpkgs#foo'`); `#` is a glob with extended_glob.
- Update inputs with `nix flake update` (all) or `nix flake update babarot` (own tools).
- After `nix flake update agent-skills`, run `nix build` as yourself before `sudo darwin-rebuild`: the input is a private repo fetched with your SSH key, which root does not have.

## Where things go

| What | Where |
|---|---|
| New hand-written dotfile | put it in `home/` under its name in ~ and list it in `nix/home-manager/dotfiles.nix` (a tool's own dotfile is linked from its `nix/home-manager/tools/<tool>.nix`, like Claude Code's in `claude-code.nix`) |
| CLI tool with no shell settings | `nix/home-manager/tools/packages.nix` (alphabetical) |
| CLI tool with aliases, shell functions, env or a zsh hook | its own `nix/home-manager/tools/<tool>.nix`, settings under `my.human`; a function built around a tool (e.g. a picker using fzf) goes in that tool's file |
| Another tool used inside a tool's settings (fzf in `bat-theme`, eza in enhancd's filter) | refer to it by store path (`lib.getExe pkgs.<tool>`), not through PATH: a file puts only its own tool on PATH, so deleting `fzf.nix` removes `fzf` but not bat's use of it. Exceptions: macOS's userland and git, hand-written config files that cannot hold a store path (they put the tool on PATH from the file that uses it, as `gh.nix` does for gh-dash), and optional uses guarded by `$+commands[...]` |
| Alias or function not tied to any one tool | an existing `home/.zsh/NN_*.zsh`, or a new one with a numeric prefix (only `[0-9]*.zsh` is loaded; hand-written, humans only; loaded through `my.human` at order 5000) |
| Tool or app for one Mac only | `nix/hosts/<host>.nix` |
| zsh plugin | `my.human.plugins.<name>` with `src`, `file`, `order` (hand-written `~/.zsh` loads at 5000, zsh-abbr at 6000) |
| Variable agents also need (GOPATH, ...) | `my.env` in the tool's `nix/home-manager/tools/<tool>.nix`; rendered to `~/.config/zsh/env.zsh`, which `.zshenv` sources |
| Directory one tool needs on PATH (e.g. `~/.krew/bin`) | `my.path` next to the tool; appended to the end of PATH in `env.zsh`, only if it exists |
| Setting only agents get (e.g. `BAT_PAGER=cat`, or an alias an agent takes for the command it knows, like `rm` → gomi) | `my.ai` in the tool's `nix/home-manager/tools/<tool>.nix`; rendered to `~/.config/zsh/ai.zsh`, which `.zshenv` sources unless `is_human` |
| PATH order, and env not tied to a tool (EDITOR, locale) | `.zshenv`, before or outside the `is_human` branch |
| GUI app that does not self-update and passes `codesign --verify --deep --strict` | `nix/home-manager/tools/apps.nix` |
| GUI app that self-updates, needs `/Applications` or system components, or fails codesign in nixpkgs | a cask in `nix/homebrew.nix` (or the host file) |
| macOS System Settings (Dock, Finder, trackpad, ...) | `nix/macos.nix`, only values that differ from the macOS default; check the key with `defaults read` first |
| Mac App Store app | `my.masApps` in `nix/home-manager/tools/app-store.nix` (or the host file); IDs from `mas list` |
| babarot's own tools | released with GoReleaser's `nix` publisher (or c-c-statusline's workflow) to babarot/nur-packages, then `inputs.babarot.packages.<system>.<name>` |
| Third-party tool not in nixpkgs that ships a flake | a flake input pinned to a release tag (see `crit`) |
| zsh plugin or source not in nixpkgs | a flake input with `flake = false` |
| Third-party Homebrew tap | `homebrew.brews` / `homebrew.casks` with the full `owner/tap/name`; nix-darwin marks each entry `trusted: true` |
| A new doc | `docs/guides/`, `docs/concepts/` or `docs/reference/` by what the reader wants (see [docs/README.md](./docs/README.md)); never duplicate what the code or its comments already say |
| Per-project language or tool versions | the project's `mise.toml`, not this repo |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home-manager/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |
| Neovim LSP servers and treesitter parsers | `nix/home-manager/tools/neovim.nix` (servers in `home.packages`, languages in its `languages` list); not mason or `:TSInstall` |
| Local patches on a package | commits on the `patches` branch of a fork `babarot/<name>`, exported into `nix/home-manager/tools/<name>/` and declared with `my.forkPatches.<name>` next to the package; never edit the patch files (docs/guides/maintenance.md) |
| Agent Skill that ships with a tool | `my.skills.<name> = <dir with SKILL.md>` next to the package (`nix/home-manager/skills.nix` links it into `~/.claude/skills` and `~/.agents/skills`) |
| My own Agent Skill on trial | `home/skills/<name>/SKILL.md` (`nix/home-manager/skills.nix` links each directory into `~/.claude/skills` and `~/.agents/skills`). A proving ground, not the main home: it skips the release flow of babarot/agent-skills, so edits apply as soon as they are in the main checkout (the links point there, so a worktree edit applies once landed). Keep it public-safe (nothing from work); once a skill settles, move it to babarot/agent-skills and delete it here |
| Agent Skills for Codex and other agents | babarot/agent-skills (private, fetched over SSH) linked into `~/.agents/skills` by `nix/home-manager/tools/agent-skills.nix`; `my.agentSkills.scopes` picks the plugins (`work` only on the work Mac). Claude Code uses the plugin marketplace instead, with the work plugin on both Macs (`home/.claude/settings.json` is shared) |

Before adding a nixpkgs package, check it is the same tool: several names belong to something else (`yq` is Python's, use `yq-go`; `mmv` is not itchyny's, use `mmv-go`; `pup`, `ktop`, `kubesec`, `gist` differ too).

## Shell: AI agents by default, human UX opt-in

- `.zshenv` defines `is_human`: stdin/stdout are a TTY and no agent marker (`CLAUDECODE`, `AI_AGENT`, ...) is set. Agents get `EDITOR=true`, `PAGER=cat`, `GIT_TERMINAL_PROMPT=0`, so nothing blocks on input.
- `.zshrc` returns early unless `is_human`. Aliases (`cp -i`, `ls` → eza), enhancd's `cd`, prompt, keybinds and setopts exist only for humans.
- Never put aliases, prompts or interactive behavior where agents run (`.zshenv`, non-interactive paths). The one exception is `my.ai`: an alias there must behave like the command agents know for every flag they write, as `rm` → gomi does ([docs/concepts/modules.md](./docs/concepts/modules.md#myai)).
- Keep macOS's BSD userland on PATH; agents write BSD syntax (`sed -i ''`, `stat -f`). GNU tools only under other names (`timeout`, `gsed`).
- Login shells read only `.zshenv` and `.zshrc`; there is no `.zprofile` on purpose.

## Conventions

- English for comments, commit messages and docs; this repo is public.
- Commit messages: an imperative summary line, then a short body explaining why. No Claude session links or attribution trailers.
- One file per tool; keep lists alphabetical; say in a comment why anything unusual is there.
- Before adding an alias or shell function, grep the tool's `.nix` file and `home/.zsh/` for one that already does it; extend that instead of adding a second.
- `~/.config` links into this repo, so tools write their state here; ignore it in `home/.config/.gitignore` (never commit tokens, e.g. wrangler's).
- `home/.claude/settings.json` is edited by Claude Code itself (`/config`); those edits show up as git diffs and are expected.

## Gotchas

- home-manager moves existing regular files aside as `*.before-hm`, but not symlinks: remove old symlinks it reports as "would be clobbered".
- Claude Code restores the PATH of the terminal it was started from; restart it from a new tab after PATH changes.
- Activation scripts run with a minimal PATH (no awk, grep); use bash builtins or store paths.
- Binaries built by `deno compile` break if Nix strips them; package them with `dontFixup = true`.
- Replacing an app: quit the old one before trashing it, or a copy running from the Trash keeps its profile locked.
- `claude` must resolve to `~/.local/bin/claude`. A copy installed with `npm install -g @anthropic-ai/claude-code` into a mise-managed node gets a mise shim, which comes first on PATH and hides the official one; remove it and run `mise reshim --force`.
