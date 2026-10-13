# Where things go

Where each kind of thing is declared, for adding, moving or removing it, and how one tool's file uses another tool. The principles behind it are in [AGENTS.md](../../AGENTS.md#principles); why Nix makes them hold is in [dependencies.md](../concepts/dependencies.md).

## One file, one lifecycle

A tool file (a `*.nix` in `nix/home-manager/tools/` or `nix/hosts/<host>/`) holds one lifecycle, what is added and removed together: adding the file installs and sets up everything in it, and deleting the file removes all of that and nothing that is still wanted. Every file is one of four kinds:

| Kind | File name | Holds | Examples |
|---|---|---|---|
| Single tool | `<tool>.nix` | one tool and its own settings | `eza.nix`, `gomi.nix` |
| Tool with companions | `<main tool>.nix` | a main tool and its settings, plus companion tools that exist only to serve it | `gh.nix` (delta and lazygit, used by gh-dash), `neovim.nix` (LSP servers and formatters), `go.nix` (goimports) |
| Set | `<subject>.set.nix` | tools used together for one subject outside the tools (a system or platform you work with), with no main one; deleting the file removes them all | `nix/hosts/PC-M-2025-026/kubernetes.set.nix` |
| List | a fixed name | tools or apps with no settings, one per line, alphabetically; each line is its own unit (deleting a line removes only that tool), and the file is just where they are listed | `packages.nix`, `apps.nix`, `app-store.nix` |

To decide where a tool goes:

1. Does a set for its subject exist? List them with `ls nix/home-manager/tools/*.set.nix nix/hosts/*/*.set.nix`. If the tool is for that subject, add it to the set. Do not make a file of its own next to a set (no `stern.nix` beside `kubernetes.set.nix`).
2. Does it exist only to serve one main tool? Ask: "if the main tool were removed, would I keep this one?" If not, it is a companion and goes in the main tool's file.
3. Otherwise it is a tool of its own: its own file (a single tool) if it has settings, a line in `packages.nix` (a list) if it has none.

A set is only for tools tied to one subject, where the test is: "if I stopped working with <subject>, would every one of these go at the same time?" Tools that merely share a kind are never a set, however many there are: linters, formatters, JSON/YAML tools, "Go tools", git helpers, cloud CLIs. Each of those is added and dropped on its own, so a file holding them would make deleting it remove tools still in use, and would hide each tool's settings under a name that is not the tool's. They stay one file each, or lines in `packages.nix`.

Before adding a nixpkgs package, check it is the same tool: several names belong to something else (`yq` is Python's, use `yq-go`; `mmv` is not itchyny's, use `mmv-go`; `pup`, `ktop`, `kubesec`, `gist` differ too).

## By kind

| What | Where |
|---|---|
| New hand-written dotfile | put it in `home/` under its name in ~ and list it in `nix/home-manager/dotfiles.nix` (a tool's own dotfile is linked from its `nix/home-manager/tools/<tool>.nix`, like Claude Code's in `claude-code.nix`) |
| CLI tool with no shell settings | `nix/home-manager/tools/packages.nix`, a list (alphabetical) |
| CLI tool with aliases, shell functions, env or a zsh hook | its own `nix/home-manager/tools/<tool>.nix`, settings under `my.human`; a function built around a tool (e.g. a picker using fzf) goes in that tool's file. A function that does not change the shell (no `cd`, `export`, zle) can instead be a command, `pkgs.writeShellApplication` in `home.packages` with what it runs in `runtimeInputs` (`gchange` and `gcloud-login` in `gcloud.nix`); keep a human-only or same-named wrapper (`codex` in `codex.nix`) a function. A companion goes in its main tool's file, and a tool for a subject that has a set goes in the set ([One file, one lifecycle](#one-file-one-lifecycle)) |
| Script of my own | settled: `pkgs.writeShellApplication` in `home.packages` of the file of the tool it belongs to (`git-url` in `git.nix`, `tovim` in `vim.nix`), with what it runs in `runtimeInputs`, or its own `<script>.nix` when it belongs to none; a settled one can live in a gist, read from its input and built in the file it would otherwise be in: its own (`deadlink.nix`, `gist-ctl.nix`) or its main tool's for a companion (herdr-worktree-ctl in `herdr.nix`); when that is allowed and how is [gist-cli.md](../guides/gist-cli.md). `home/bin` (`~/bin`, on PATH) is only for a script still being shaped; move it into Nix once it settles |
| Another tool used inside a tool's settings (fzf in `bat-theme`, eza in enhancd's filter) | by store path, never through PATH ([Dependencies between tools](#dependencies-between-tools)) |
| Alias or function not tied to any one tool | an existing `home/.zsh/NN_*.zsh`, or a new one with a numeric prefix (only `[0-9]*.zsh` is loaded; hand-written, humans only; loaded through `my.human` as the plugin `zsh-local`) |
| Tool for one Mac only | `nix/hosts/<host>/<name>.nix` when it has settings or more than one package (a set included), else a line in `nix/hosts/<host>.nix` ([One file, one lifecycle](#one-file-one-lifecycle)) |
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
| Commands an official installer, `go install` or a plugin puts in `~/.local/bin` or `~/go/bin` | `my.knownBins` next to the tool that puts them there (claude, go.nvim's `go install`, reviewr's link); each switch warns about commands there that no entry lists |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home-manager/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |
| Neovim LSP servers, formatters, tools its plugins call (fd, rg for snacks.nvim) and treesitter parsers | `nix/home-manager/tools/neovim.nix` (servers, formatters and tools in its `tools` list, on nvim's own PATH; languages in its `languages` list); not mason or `:TSInstall` |
| Local patches on a package | only after [Before proposing a patch](../guides/maintenance.md#before-proposing-a-patch); commits on the `patches` branch of a fork `babarot/<name>`, exported into `nix/home-manager/tools/<name>/` and declared with `my.forkPatches.<name>` next to the package; never edit the patch files ([maintenance.md](../guides/maintenance.md#patch-a-package-from-a-fork-branch)) |
| Agent Skill that ships with a tool | `my.skills.<name> = <dir with SKILL.md>` next to the package (`nix/home-manager/skills.nix` links it into `~/.claude/skills` and `~/.agents/skills`) |
| Third-party Agent Skill | the tool that ships it, if it has one (`oh-my-mermaid.nix`: the CLI packaged in Nix, the skills from the same source, never its `setup` command); a skill on its own gets `nix/home-manager/tools/<name>.nix`, fetched at a fixed revision into `my.skills` (`japanese-tech-writing.nix`). Name the file after what is picked: a skill picked from a repo of several gets its own file and pin (`show-me.nix`); a repo taken whole, updated as one, is named after the repo (`agent-skills.nix`). Not `npx skills add` or a tool's installer. Read the skill before adding it or bumping its revision: it reaches the agent as instructions |
| My own Agent Skill on trial | `home/skills/<name>/SKILL.md` (`nix/home-manager/skills.nix` links each directory into `~/.claude/skills` and `~/.agents/skills`). A proving ground, not the main home: it skips the release flow of babarot/agent-skills, so edits apply as soon as they are in the main checkout (the links point there, so a worktree edit applies once landed). Keep it public-safe (nothing from work); once a skill settles, move it to babarot/agent-skills and delete it here |
| Agent Skills for Codex and other agents | babarot/agent-skills (private, fetched over SSH) linked into `~/.agents/skills` by `nix/home-manager/tools/agent-skills.nix`; `my.agentSkills.scopes` picks the plugins (`work` only on the work Mac). Claude Code uses the plugin marketplace instead, with the work plugin on both Macs (`home/.claude/settings.json` is shared). Tools those skills run are defined in agent-skills too (`nix/` there) and installed by the same file, so what they are stays private |

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

## Dependencies between tools

A file's `home.packages` holds its own tool and its companions, nothing else. Any other tool it runs, it runs by store path, in a way that depends on where the tool is run:

| Where it runs | How | Examples |
|---|---|---|
| Settings Nix renders: `my.human.init`, `my.env`, `my.gitConfig`, a generated config | embed `lib.getExe pkgs.<tool>` | `bat.nix` (fzf in bat-theme), `enhancd.nix`, `fzf-tab.nix`, `ov.nix` |
| A shell function that does not change the shell (no `cd`, `export`, zle) | make it a command: `pkgs.writeShellApplication` with the tool in `runtimeInputs` | `gchange` in `gcloud.nix` |
| A program that runs other tools by name (an editor, a plugin host) | wrap it: `symlinkJoin` + `wrapProgram --suffix PATH : ${lib.makeBinPath [ ... ]}`, suffix so a version a project pins with mise still wins | `neovim.nix` |
| A hand-written config naming a tool that is not a companion | generate the config in the tool's file with store paths when it is rarely edited; wrap the program when it is edited often | `gomi.nix`, `enter.nix` |

- Never fix a dependency by calling the tool by bare name (it breaks when the tool's file is deleted) or by adding the tool to your own `home.packages` (its file no longer removes it).
- Hand-written or generated: a config you keep trying things in (keybinds, colors) stays hand-written in `home/`, linked from the repo so an edit applies without a switch; it cannot hold store paths. A config that rarely changes and runs other tools is generated in its tool's file.
- Run by name only: macOS's userland and git, which nothing here removes; a companion named in a hand-written config, put on PATH by its main tool's file (`gh.nix` for gh-dash's delta and lazygit); optional uses guarded by `$+commands[...]` or `executable()` (rm.nvim with gomi).
- Put on PATH only the commands you mean to. Before adding a package, list its `bin/` (`ls "$(nix build --no-link --print-out-paths '.#darwinConfigurations.pro23.pkgs.<pkg>^out')/bin"`). When it brings names that shadow something (gawk's `awk`, bashInteractive's `sh`, gotools' `bundle`), link only the wanted commands with `runCommand` (`gawk.nix`, `bash.nix`, `go.nix`).
- Load order between zsh plugins is declared with `after` and `before` (the zsh plugin row above), never inferred. A name that is not a plugin is ignored, so deleting a plugin's file breaks no one.
- To check a change that makes one tool run another: delete the other tool's file in the worktree, build, read the generated files for the tool's bare name (`home-files/.config/zsh/human.zsh` and any generated config in the home-manager generation), then restore the file.

## Untracked files in home/.config

`~/.config` links into this repo, so whatever tools write there shows up as untracked files in `home/.config`. Decide by what the file is:

| File | Tells it apart | Do |
|---|---|---|
| Generated by home-manager | a symlink into `/nix/store` | ignore it in `home/.config/.gitignore`; its settings are in the tool's file |
| A config edited by hand | a regular file you change | track it |
| A template the tool writes on first run | a regular file listing the defaults, commented out | track it; it is where a setting is changed |
| The tool's state or credentials | rewritten as the tool runs, or holds tokens | ignore it in `home/.config/.gitignore` with a comment saying what writes it (never commit tokens, e.g. wrangler's) |
