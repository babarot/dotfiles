# AGENTS.md

babarot's macOS environment, shared by two Macs through one Nix flake (nix-darwin + home-manager):

| Hostname | Machine | Host file |
|---|---|---|
| `pro23` | private Mac | `nix/hosts/pro23.nix` |
| `PC-M-2025-026` | work Mac | `nix/hosts/PC-M-2025-026.nix` |

- Both Macs read this file.
  - `scutil --get LocalHostName` tells which one you are on; it is also how `darwin-rebuild` picks the configuration.
  - Anything not in a host file applies to both Macs.
  - A change for the other Mac is made and pushed from where you are, then pulled and applied on that Mac by an agent session there.
- Changes go to main directly, not through a PR.
  - Work is done in a git worktree and landed in main with `git land` (`--push` to push), which the `/land` skill wraps.
  - Open a PR only when the user asks for one. Land or push only when the user asks.
- This repository is public.
  - Never commit credentials, tokens, or internal names from work (company, org, internal hosts or repos).

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

Do not add a directory at the repository root without a strong reason; put new files under `nix/`, `home/` or `docs/`. The README describes the root directories, so each new one means editing it too.

- `nix/home-manager/*.nix` (outside `tools/`) are the modules behind the `my.*` options ([docs/concepts/modules.md](./docs/concepts/modules.md)); `tools/` holds the tool files, and only its `*.nix` are imported, so a tool's scripts and patches sit beside its file.
- `nix/hosts/<host>.nix` is a nix-darwin module (casks, brews, App Store apps, single packages for that Mac); `nix/hosts/<host>/*.nix` are home-manager modules shaped like tool files, for that Mac only.
- `home/` is linked into `~` under the same names, pointing at the repo checkout rather than the store, so an edit applies without a switch; `home/.config` is `~/.config` as a whole.
- `home/skills/` holds my own Agent Skills on trial, linked into `~/.claude/skills` and `~/.agents/skills`; `.claude/skills/` holds skills for working on this repo only, not linked anywhere.

## Applying and checking changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- When a change makes one tool run another, check loose coupling: delete the other tool's file in the worktree, build, read the generated files for the tool's bare name (`home-files/.config/zsh/human.zsh` and any generated config in the home-manager generation), then restore the file.
- Run `nix fmt` before committing. `nix flake check` fails on unformatted files.
- The pre-commit hook (gitleaks, `nix fmt`, patch files) and the pre-push hook (builds every Mac) stop a bad commit or push: fix what they report, never bypass them with `--no-verify`. A reviewed gitleaks false positive goes in `.gitleaksignore`. What the hooks and CI check is in [docs/concepts/workflow.md](./docs/concepts/workflow.md#checks).
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).
- Quote flake references in zsh (`'nixpkgs#foo'`); `#` is a glob with extended_glob.
- Updating inputs, including the private `agent-skills`, is in [docs/guides/maintenance.md](./docs/guides/maintenance.md#update-flake-inputs).

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

The rules for naming and writing a set, and where a file for one Mac lives, are in [docs/reference/where-things-go.md](./docs/reference/where-things-go.md#sets).

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
- Load order between zsh plugins is declared with `after` and `before` ([where-things-go.md](./docs/reference/where-things-go.md)), never inferred. A name that is not a plugin is ignored, so deleting a plugin's file breaks no one.

## Declared, never installed by hand

- Do not install a tool with `brew install`, `npm install -g`, `curl ... | sh`, `go install`, `pipx install`, `cargo install` or `mise use -g`. It would be on one Mac only, at whatever version it was that day, and nothing would remove it.
- Add it to Nix ([where-things-go.md](./docs/reference/where-things-go.md)). When Nix cannot hold it, declare it where its kind is declared, with the reason in a comment: a cask or brew in `nix/homebrew.nix` or the host file, an App Store app in `my.masApps`, an official installer run by activation (`claude-code.nix`), or `my.knownBins` next to the tool that puts commands in a directory on PATH (claude, go.nvim's `go install`, reviewr's link).
- The exceptions that exist are intended. Do not move them into Nix or remove them without asking.
- To try a tool, run it with `nix shell 'nixpkgs#<pkg>'` or `nix run 'nixpkgs#<pkg>'`; nothing stays behind.
- Each switch uninstalls Homebrew casks and brews no file declares, and warns about commands in `~/.local/bin` and `~/go/bin` that no `my.knownBins` lists. Per-project versions in a project's `mise.toml` belong to that project, not to this repo.

## Patches are the last resort

A patch has to be carried onto every upstream release, and it costs the binary cache. Before proposing one, go through these in order, and stop at the first that does what is wanted:

1. The latest version: does the latest upstream release, or the version in nixpkgs, already do it?
2. The documentation: can a setting, option, environment variable or plugin do it?
3. Precedent: do upstream's issues, pull requests or discussions have the same request, a workaround or a plan for it?
4. Other combinations: can it be done by wrapping the program, generating its config, combining it with another tool, or accepting the behavior and declaring it (`my.knownBins` for reviewr's link)?
5. Only then, propose a patch to the user, saying what 1-4 found and why each fell short, and offer an upstream issue or pull request as the alternative. Do not start a patch before the user agrees.

Once agreed, the patch is made in the fork and imported here ([where-things-go.md](./docs/reference/where-things-go.md), "Local patches on a package").

## Where things go

Before adding or moving anything, look up where it goes in [docs/reference/where-things-go.md](./docs/reference/where-things-go.md): a table by kind (dotfile, CLI tool, script, zsh plugin, variable, git setting, GUI app, cask, App Store app, macOS setting, skill, patch, ...), the rules for sets, and where a file for one Mac lives. The common cases:

- A CLI tool with no settings: a line in `nix/home-manager/tools/packages.nix`, alphabetically.
- A tool with settings (aliases, functions, variables, a zsh hook): its own `nix/home-manager/tools/<tool>.nix`, settings under `my.*` next to the package.
- A tool for one Mac only: `nix/hosts/<host>/<name>.nix`, or a line in `nix/hosts/<host>.nix` when it is a single package with no settings.

Before adding a nixpkgs package, check it is the same tool: several names belong to something else (`yq` is Python's, use `yq-go`; `mmv` is not itchyny's, use `mmv-go`; `pup`, `ktop`, `kubesec`, `gist` differ too).

## Shell: AI agents by default, human UX opt-in

Agents get a plain zsh; human UX loads only when `is_human` (README, "Shell for humans and AI agents").

- Never put aliases, prompts or interactive behavior where agents run (`.zshenv`, non-interactive paths); they go in `my.human`. The one exception is `my.ai`: an alias there must behave like the command agents know for every flag they write, as `rm` → gomi does ([docs/concepts/modules.md](./docs/concepts/modules.md#myai)).
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
