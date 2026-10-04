# AGENTS.md

babarot's macOS environment, shared by two Macs through one Nix flake (nix-darwin + home-manager):

| Hostname | Machine | Host file |
|---|---|---|
| `pro23` | private Mac | `nix/hosts/pro23.nix` |
| `PC-M-2025-026` | work Mac | `nix/hosts/PC-M-2025-026.nix` |

Both Macs read this file; `scutil --get LocalHostName` tells which one you are on, and is also how `darwin-rebuild` picks the configuration. Anything not in a host file applies to both Macs. A change for the other Mac is made and pushed from where you are, then pulled and applied on that Mac by an agent session there.

Changes go to main directly, not through a PR: work is done in a git worktree and landed in main with `git land` (`--push` to push), which the `/land` skill wraps. Open a PR only when the user asks for one. Land or push only when the user asks.

This repository is public. Never commit credentials, tokens, or internal names from work (company, org, internal hosts or repos).

## Principles

Everything here serves one goal: what deleting a tool's file does can be told from that file alone. Three properties make that true. Every rule below follows from them; where no rule fits, choose what keeps all three.

| Property | Means | Kept by |
|---|---|---|
| Cohesion | Deleting a tool's file removes everything that was for the tool: its package, aliases, variables, PATH entries, git settings, plugins and skills. | [One file, one lifecycle](#one-file-one-lifecycle). Shared files (`human.zsh`, `env.zsh`, `tools.gitconfig`, ...) are assembled from what each tool's file contributes through `my.*`, never written by hand for one tool. |
| Loose coupling | Deleting a tool's file breaks nothing else. | A file puts only its own tool and its companions on PATH; any other tool it runs, it runs by store path ([Dependencies between tools](#dependencies-between-tools)). |
| Reproducibility | A new Mac gets the same thing. | Everything is declared in this repo: in Nix where it can be, pinned by `flake.lock`; otherwise as a declared exception, with its reason, in the file of what it is for ([Declared, never installed by hand](#declared-never-installed-by-hand)). |

The first two pull against each other. Adding a tool another file uses to your own `home.packages` keeps it from breaking but stops its file from removing it; calling it by name lets its file remove it but breaks you when it does. A store path keeps both.

Before finishing a change, ask of each file it touches: if this file were deleted, what would be left over, and what would break? Both answers must be "nothing". Why Nix makes this possible is in [docs/concepts/dependencies.md](./docs/concepts/dependencies.md).

## Layout

`ls` shows the tree, and each file says in its opening comment what it is for. What a listing does not show:

- `nix/home-manager/*.nix` (outside `tools/`) are the modules behind the `my.*` options ([docs/concepts/modules.md](./docs/concepts/modules.md)); `tools/` holds the tool files, and only its `*.nix` are imported, so a tool's scripts and patches sit beside its file.
- `nix/hosts/<host>.nix` is a nix-darwin module (casks, brews, App Store apps, single packages for that Mac); `nix/hosts/<host>/*.nix` are home-manager modules shaped like tool files, for that Mac only.
- `home/` is linked into `~` under the same names, pointing at the repo checkout rather than the store, so an edit applies without a switch; `home/.config` is `~/.config` as a whole.
- `home/skills/` holds my own Agent Skills on trial, linked into `~/.claude/skills` and `~/.agents/skills`; `.claude/skills/` holds skills for working on this repo only, not linked anywhere.

Do not add a directory at the repository root without a strong reason; put new files under `nix/`, `home/` or `docs/`. The README describes the root directories, so each new one means editing it too.

## Applying and checking changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- When a change makes one tool run another, check loose coupling: delete the other tool's file in the worktree, build, read the generated files for the tool's bare name (`home-files/.config/zsh/human.zsh` and any generated config in the home-manager generation), then restore the file.
- Run `nix fmt` before committing: nixfmt, deadnix, statix and shfmt, configured in `nix/treefmt.nix`. `nix flake check` fails on unformatted files.
- `.githooks/pre-commit` (turned on for this repo and its worktrees by an `includeIf` in `home/.gitconfig`) runs gitleaks on the staged changes and checks `nix fmt`; when patch files are staged, `.githooks/check-patches` checks they are exported from the fork's pushed `patches` branch. When it stops a commit, remove the secret or stage the reformatted files; never bypass it with `--no-verify`. A reviewed false positive goes in `.gitleaksignore`.
- `.githooks/pre-push` builds every Mac at the pushed commit when the push changes Nix files, and warns (without stopping the push) when a fork's `patches` branch has moved ahead of the patch files; import it with the import-fork-patches skill. It uses the local store and the real `agent-skills`, so it is quick unless nixpkgs moved. When it fails, fix the build; do not push with `--no-verify`.
- CI (`.github/workflows/nix.yaml`) runs `nix flake check` and evaluates every Mac's system derivation on pushes to main and PRs that touch Nix files. It does not build them: a fresh runner rebuilds everything (~15 min), which the pre-push hook does locally from a warm store. It cannot fetch the private `agent-skills` input, so it overrides it with an empty stub made in the job; a change that only breaks with the real skills passes CI.
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).
- Quote flake references in zsh (`'nixpkgs#foo'`); `#` is a glob with extended_glob.
- Update inputs with `nix flake update` (all) or `nix flake update babarot` (own tools).
- After `nix flake update agent-skills`, run `nix build` as yourself before `sudo darwin-rebuild`: the input is a private repo fetched with your SSH key, which root does not have.

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

Rules for sets:

- Name: the subject, then `.set` before `.nix`: `kubernetes.set.nix`, never `kubernetes.nix`. Without the marker, a listing reads the file as a tool of that name (nixpkgs even has a `kubernetes` package). The marker is a suffix so files still sort by subject.
- The file opens with a comment saying what the set is for, which Macs get it, and that new tools for the subject go in it.
- A set is one file, never a directory of per-tool files. Settings the set shares (an abbreviation, wrapper links, `my.path`) sit in it next to the packages. Scripts it reads go in a `<subject>/` directory beside it, as tools/ does for tools; only `*.nix` directly in the directory is imported.
- A tool is in exactly one file. A tool also used for another subject, or on its own, gets its own file.
- A tool-with-companions file has no marker: the main tool's name already says what it holds.

Where the file lives depends on which Macs get it:

| Which Macs | Where | Loaded by |
|---|---|---|
| Both | `nix/home-manager/tools/<name>.nix` | `nix/home-manager/default.nix`, every `*.nix` in that directory |
| One, and the tool or set has settings (`my.*`, wrapper links) or more than one package | `nix/hosts/<host>/<name>.nix`, a home-manager module of the same shape as a tools/ file | `mkHost` in `flake.nix`, every `*.nix` directly in that directory, for that Mac only |
| One, a single package with no settings | a line in `home.packages` in `nix/hosts/<host>.nix` | the host file itself |

Casks, brews and App Store apps for one Mac stay in `nix/hosts/<host>.nix`: it is a nix-darwin module, while the files in `nix/hosts/<host>/` are home-manager modules and cannot hold them.

## Dependencies between tools

- A file's `home.packages` holds its own tool and its companions, nothing else. Any other tool it runs, it runs by store path.
- How depends on where the tool is run:

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
- Load order between zsh plugins is declared with `after` and `before` ([Where things go](#where-things-go)), never inferred. A name that is not a plugin is ignored, so deleting a plugin's file breaks no one.

## Declared, never installed by hand

- Do not install a tool with `brew install`, `npm install -g`, `curl ... | sh`, `go install`, `pipx install`, `cargo install` or `mise use -g`. It would be on one Mac only, at whatever version it was that day, and nothing would remove it.
- Add it to Nix ([Where things go](#where-things-go)). When Nix cannot hold it, declare it where its kind is declared, with the reason in a comment: a cask or brew in `nix/homebrew.nix` or the host file, an App Store app in `my.masApps`, an official installer run by activation (`claude-code.nix`), or `my.knownBins` next to the tool that puts commands in a directory on PATH (claude, go.nvim's `go install`, reviewr's link).
- The exceptions that exist are intended. Do not move them into Nix or remove them without asking.
- To try a tool, run it with `nix shell 'nixpkgs#<pkg>'` or `nix run 'nixpkgs#<pkg>'`; nothing stays behind.
- Each switch uninstalls Homebrew casks and brews no file declares, and warns about commands in `~/.local/bin` and `~/go/bin` that no `my.knownBins` lists. Per-project versions in a project's `mise.toml` belong to that project, not to this repo.

## Where things go

| What | Where |
|---|---|
| New hand-written dotfile | put it in `home/` under its name in ~ and list it in `nix/home-manager/dotfiles.nix` (a tool's own dotfile is linked from its `nix/home-manager/tools/<tool>.nix`, like Claude Code's in `claude-code.nix`) |
| CLI tool with no shell settings | `nix/home-manager/tools/packages.nix`, a list (alphabetical) |
| CLI tool with aliases, shell functions, env or a zsh hook | its own `nix/home-manager/tools/<tool>.nix`, settings under `my.human`; a function built around a tool (e.g. a picker using fzf) goes in that tool's file. A function that does not change the shell (no `cd`, `export`, zle) can instead be a command, `pkgs.writeShellApplication` in `home.packages` with what it runs in `runtimeInputs` (`gchange` and `ohayo` in `gcloud.nix`); keep a human-only or same-named wrapper (`codex` in `codex.nix`) a function. A companion goes in its main tool's file, and a tool for a subject that has a set goes in the set ([One file, one lifecycle](#one-file-one-lifecycle)) |
| Script of my own | settled: `pkgs.writeShellApplication` in `home.packages` of the file of the tool it belongs to (`git-url` in `git.nix`, `tovim` in `vim.nix`), with what it runs in `runtimeInputs`, or its own `<script>.nix` when it belongs to none (`deadlink.nix`). `home/bin` (`~/bin`, on PATH) is only for a script still being shaped; move it into Nix once it settles |
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
| zsh plugin or source not in nixpkgs | a flake input with `flake = false` |
| Third-party Homebrew tap | `homebrew.brews` / `homebrew.casks` with the full `owner/tap/name`; nix-darwin marks each entry `trusted: true` |
| A new doc | `docs/guides/`, `docs/concepts/` or `docs/reference/` by what the reader wants (see [docs/README.md](./docs/README.md)); never duplicate what the code or its comments already say |
| Per-project language or tool versions | the project's `mise.toml`, not this repo |
| Claude Code | not from nixpkgs: it updates itself, so `nix/home-manager/tools/claude-code.nix` runs the official installer only when `~/.local/bin/claude` is missing |
| Neovim LSP servers, formatters, tools its plugins call (fd, rg for snacks.nvim) and treesitter parsers | `nix/home-manager/tools/neovim.nix` (servers, formatters and tools in its `tools` list, on nvim's own PATH; languages in its `languages` list); not mason or `:TSInstall` |
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
