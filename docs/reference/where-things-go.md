# Where things go

Where each kind of thing is declared, for adding or moving it. Why a file holds what it holds is in [AGENTS.md](../../AGENTS.md#cohesion-one-file-one-lifecycle); how one tool uses another is in [AGENTS.md](../../AGENTS.md#loose-coupling-dependencies-between-tools).

## By kind

| What | Where |
|---|---|
| New hand-written dotfile | put it in `home/` under its name in ~ and list it in `nix/home-manager/dotfiles.nix` (a tool's own dotfile is linked from its `nix/home-manager/tools/<tool>.nix`, like Claude Code's in `claude-code.nix`) |
| CLI tool with no shell settings | `nix/home-manager/tools/packages.nix`, a list (alphabetical) |
| CLI tool with aliases, shell functions, env or a zsh hook | its own `nix/home-manager/tools/<tool>.nix`, settings under `my.human`; a function built around a tool (e.g. a picker using fzf) goes in that tool's file. A function that does not change the shell (no `cd`, `export`, zle) can instead be a command, `pkgs.writeShellApplication` in `home.packages` with what it runs in `runtimeInputs` (`gchange` and `ohayo` in `gcloud.nix`); keep a human-only or same-named wrapper (`codex` in `codex.nix`) a function. A companion goes in its main tool's file, and a tool for a subject that has a set goes in the set ([One file, one lifecycle](../../AGENTS.md#cohesion-one-file-one-lifecycle)) |
| Script of my own | settled: `pkgs.writeShellApplication` in `home.packages` of the file of the tool it belongs to (`git-url` in `git.nix`, `tovim` in `vim.nix`), with what it runs in `runtimeInputs`, or its own `<script>.nix` when it belongs to none; one that belongs to none can live in a gist, read from its input (`deadlink.nix`, [install-from-git.md](../guides/install-from-git.md#keep-a-script-of-your-own-in-a-gist)). `home/bin` (`~/bin`, on PATH) is only for a script still being shaped; move it into Nix once it settles |
| Another tool used inside a tool's settings (fzf in `bat-theme`, eza in enhancd's filter) | by store path, never through PATH ([Dependencies between tools](../../AGENTS.md#loose-coupling-dependencies-between-tools)) |
| Alias or function not tied to any one tool | an existing `home/.zsh/NN_*.zsh`, or a new one with a numeric prefix (only `[0-9]*.zsh` is loaded; hand-written, humans only; loaded through `my.human` as the plugin `zsh-local`) |
| Tool for one Mac only | `nix/hosts/<host>/<name>.nix` when it has settings or more than one package (a set included), else a line in `nix/hosts/<host>.nix` ([One file, one lifecycle](../../AGENTS.md#cohesion-one-file-one-lifecycle)) |
| App, cask or brew for one Mac only | `nix/hosts/<host>.nix` |
| zsh plugin | `my.human.plugins.<name>` with `src`, `file`, and `after`/`before` naming other plugins (the hand-written `~/.zsh` is `zsh-local`), only where the order has a reason, written in a comment next to it |
| Variable agents also need (GOPATH, ...) | `my.env` in the tool's `nix/home-manager/tools/<tool>.nix`; rendered to `~/.config/zsh/env.zsh`, which `.zshenv` sources |
| git setting that runs a tool (a pager, a diff alias) | `my.gitConfig` in the tool's file, with the store path (`ov.nix`, `difftastic.nix`); rendered to `~/.config/git/tools.gitconfig`, which `home/.gitconfig` includes |
| Directory one tool needs on PATH (e.g. `~/.krew/bin`) | `my.path` next to the tool; appended to the end of PATH in `env.zsh`, only if it exists |
| Setting only agents get (e.g. `BAT_PAGER=cat`, or an alias an agent takes for the command it knows, like `rm` → gomi) | `my.ai` in the tool's `nix/home-manager/tools/<tool>.nix`; rendered to `~/.config/zsh/ai.zsh`, which `.zshenv` sources unless `is_human` |
| PATH order, and env not tied to a tool (EDITOR, locale) | `.zshenv`, before or outside the `is_human` branch |
| GUI app that does not self-update and passes `codesign --verify --deep --strict` | `nix/home-manager/tools/apps.nix`, a list |
| GUI app that self-updates, needs `/Applications` or system components, or fails codesign in nixpkgs | a cask in `nix/homebrew.nix` (or the host file) |
| macOS System Settings (Dock, Finder, trackpad, ...) | `nix/macos.nix`, only values that differ from the macOS default; check the key with `defaults read` first |
| Mac App Store app | `my.masApps` in `nix/home-manager/tools/app-store.nix`, a list, or in the host file; IDs from `mas list` |
| babarot's own tools | released with GoReleaser's `nix` publisher (or c-c-statusline's workflow) to babarot/nur-packages, then `inputs.babarot.packages.<system>.<name>` |
| Third-party tool not in nixpkgs that ships a flake | a flake input pinned to a release tag (see `crit`) |
| zsh plugin or source not in nixpkgs | a flake input with `flake = false` ([install-from-git.md](../guides/install-from-git.md)) |
| Third-party Homebrew tap | `homebrew.brews` / `homebrew.casks` with the full `owner/tap/name`; nix-darwin marks each entry `trusted: true` |
| A new doc | `docs/guides/`, `docs/concepts/` or `docs/reference/` by what the reader wants (see [docs/README.md](../README.md)); never duplicate what the code or its comments already say |
| Per-project language or tool versions | the project's `mise.toml`, not this repo |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home-manager/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |
| Neovim LSP servers, formatters, tools its plugins call (fd, rg for snacks.nvim) and treesitter parsers | `nix/home-manager/tools/neovim.nix` (servers, formatters and tools in its `tools` list, on nvim's own PATH; languages in its `languages` list); not mason or `:TSInstall` |
| Local patches on a package | only after [Patches are the last resort](../../AGENTS.md#patches-are-the-last-resort); commits on the `patches` branch of a fork `babarot/<name>`, exported into `nix/home-manager/tools/<name>/` and declared with `my.forkPatches.<name>` next to the package; never edit the patch files ([maintenance.md](../guides/maintenance.md#patch-a-package-from-a-fork-branch)) |
| Agent Skill that ships with a tool | `my.skills.<name> = <dir with SKILL.md>` next to the package (`nix/home-manager/skills.nix` links it into `~/.claude/skills` and `~/.agents/skills`) |
| My own Agent Skill on trial | `home/skills/<name>/SKILL.md` (`nix/home-manager/skills.nix` links each directory into `~/.claude/skills` and `~/.agents/skills`). A proving ground, not the main home: it skips the release flow of babarot/agent-skills, so edits apply as soon as they are in the main checkout (the links point there, so a worktree edit applies once landed). Keep it public-safe (nothing from work); once a skill settles, move it to babarot/agent-skills and delete it here |
| Agent Skills for Codex and other agents | babarot/agent-skills (private, fetched over SSH) linked into `~/.agents/skills` by `nix/home-manager/tools/agent-skills.nix`; `my.agentSkills.scopes` picks the plugins (`work` only on the work Mac). Claude Code uses the plugin marketplace instead, with the work plugin on both Macs (`home/.claude/settings.json` is shared) |

## Sets

- Name: the subject, then `.set` before `.nix`: `kubernetes.set.nix`, never `kubernetes.nix`. Without the marker, a listing reads the file as a tool of that name (nixpkgs even has a `kubernetes` package). The marker is a suffix so files still sort by subject.
- The file opens with a comment saying what the set is for, which Macs get it, and that new tools for the subject go in it.
- A set is one file, never a directory of per-tool files. Settings the set shares (an abbreviation, wrapper links, `my.path`) sit in it next to the packages. Scripts it reads go in a `<subject>/` directory beside it, as tools/ does for tools; only `*.nix` directly in the directory is imported.
- A tool is in exactly one file. A tool also used for another subject, or on its own, gets its own file.
- A tool-with-companions file has no marker: the main tool's name already says what it holds.
- Companions big enough to want files of their own (plugins built from source, a launchd agent with options) go in `tools/<tool>/`, listed in the `imports` of the tool's file (`herdr.nix`). Only the tool's file imports them, so deleting it removes them all, and a host file that sets one of their options guards it with `options.my ? <option>` (`nix/hosts/pro23/herdr-devstack.nix`).

## One Mac or both

Where the file lives depends on which Macs get it:

| Which Macs | Where | Loaded by |
|---|---|---|
| Both | `nix/home-manager/tools/<name>.nix` | `nix/home-manager/default.nix`, every `*.nix` in that directory |
| One, and the tool or set has settings (`my.*`, wrapper links) or more than one package | `nix/hosts/<host>/<name>.nix`, a home-manager module of the same shape as a tools/ file | `mkHost` in `flake.nix`, every `*.nix` directly in that directory, for that Mac only |
| One, a single package with no settings | a line in `home.packages` in `nix/hosts/<host>.nix` | the host file itself |

Casks, brews and App Store apps for one Mac stay in `nix/hosts/<host>.nix`: it is a nix-darwin module, while the files in `nix/hosts/<host>/` are home-manager modules and cannot hold them.
