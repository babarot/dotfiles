# Decisions

Why things are the way they are, and what was tried and dropped. Each entry is one decision, the reason for it as the commits give it, and the commits in parentheses. The layout itself is in [structure.md](./structure.md).

## Packages

- Nix replaces afx and the Brewfile. Every tool, zsh plugin and app is declared in one flake shared by both Macs; tools that are not in nixpkgs come in as flake inputs. ([a53df59](https://github.com/babarot/dotfiles/commit/a53df59), [b48265b](https://github.com/babarot/dotfiles/commit/b48265b), [754339f](https://github.com/babarot/dotfiles/commit/754339f), [1282eb4](https://github.com/babarot/dotfiles/commit/1282eb4))
- Nix itself is managed by the Determinate installer, so nix-darwin leaves it alone (`nix.enable = false`). ([a53df59](https://github.com/babarot/dotfiles/commit/a53df59))
- One file per tool. A tool's package and its shell settings sit in `nix/home-manager/tools/<tool>.nix`, so deleting the file removes everything the tool set. ([a53df59](https://github.com/babarot/dotfiles/commit/a53df59), [f9379cf](https://github.com/babarot/dotfiles/commit/f9379cf), [3951820](https://github.com/babarot/dotfiles/commit/3951820))
- All unfree packages are allowed rather than listed one by one, since most GUI apps are unfree. ([0810eef](https://github.com/babarot/dotfiles/commit/0810eef))
- GUI apps come from Nix when they do not update themselves and pass `codesign --verify --deep --strict` ([apps.nix](../../nix/home-manager/tools/apps.nix)). ([0810eef](https://github.com/babarot/dotfiles/commit/0810eef))
- Spotify, Obsidian, TablePlus and Numi are Homebrew casks instead. Their nixpkgs packages fail `codesign --verify --deep --strict`, and Spotify showed only a black window; they update themselves anyway. ([39830a6](https://github.com/babarot/dotfiles/commit/39830a6))
- Homebrew casks only install vendor apps that update themselves or install system components ([homebrew.nix](../../nix/homebrew.nix)). Homebrew never updates, upgrades or removes anything. ([1282eb4](https://github.com/babarot/dotfiles/commit/1282eb4))
- Mac App Store apps are listed for `mas`, which installs only the missing ones and leaves versions to the App Store. ([0810eef](https://github.com/babarot/dotfiles/commit/0810eef))
- PopClip and The Unarchiver come from the App Store on the private Mac and from casks on the work Mac, so neither Mac reinstalls them. ([f259acd](https://github.com/babarot/dotfiles/commit/f259acd))
- Apps and tools are split into shared and per-host lists, so private apps do not land on the work Mac. ([3fdbf2a](https://github.com/babarot/dotfiles/commit/3fdbf2a))
- Homebrew itself is installed by nix-homebrew, which took over the existing installs with `autoMigrate` and replaced the Makefile. Its zsh integration is off because `brew shellenv` would put `/opt/homebrew/bin` before the Nix profiles. ([52ac4c2](https://github.com/babarot/dotfiles/commit/52ac4c2))
- Third-party taps go through `homebrew.brews` with the full `owner/tap/name`, trusted per entry, never per tap. ([3fdbf2a](https://github.com/babarot/dotfiles/commit/3fdbf2a))
- Claude Code comes from its official installer, not nixpkgs, because it updates itself. Activation runs the installer only when `~/.local/bin/claude` is missing. ([64ab58d](https://github.com/babarot/dotfiles/commit/64ab58d))
- My own tools are released by GoReleaser to babarot/nur-packages and installed from there, instead of `go install`, afx or a tap. ([5dacc8e](https://github.com/babarot/dotfiles/commit/5dacc8e), [087b476](https://github.com/babarot/dotfiles/commit/087b476), [8d39f04](https://github.com/babarot/dotfiles/commit/8d39f04), [f6ceea1](https://github.com/babarot/dotfiles/commit/f6ceea1))
- crit, which is not in nixpkgs, is a flake input pinned to a release tag, since its repository ships a flake. ([c3823d6](https://github.com/babarot/dotfiles/commit/c3823d6))
- node and pnpm are installed globally; per-project versions and one-project tools (yarn, bun) come from that project's `mise.toml`. ([863cebe](https://github.com/babarot/dotfiles/commit/863cebe), [51f7c5c](https://github.com/babarot/dotfiles/commit/51f7c5c))
- Go for arm64 comes from Nix, replacing a `/usr/local/go` that ran under Rosetta. `GOPATH` stays `$HOME`. ([2b4aabd](https://github.com/babarot/dotfiles/commit/2b4aabd))
- Nixpkgs names are checked before adding: `yq-go`, `mmv-go` and Datadog's `pup` tap, because the plain names are other tools. ([b48265b](https://github.com/babarot/dotfiles/commit/b48265b), [3fdbf2a](https://github.com/babarot/dotfiles/commit/3fdbf2a))
- herdr is nixpkgs' package with small patches, one per change, so a patch that fails after a bump is easy to find and drop. Patching loses the binary cache. ([67a9973](https://github.com/babarot/dotfiles/commit/67a9973), [bfd854c](https://github.com/babarot/dotfiles/commit/bfd854c), [d13681f](https://github.com/babarot/dotfiles/commit/d13681f))
- The herdr plugins are built by Nix and linked on every switch, so both Macs run the same pinned versions without `herdr plugin install`. ([c2945c7](https://github.com/babarot/dotfiles/commit/c2945c7))

## Shell

- The shell is plain for AI agents and human UX is opt-in. `is_human` is true only when stdin/stdout are a TTY and no agent marker is set; agents get `EDITOR=true` and `PAGER=cat`, so `cp -i`, enhancd's fzf on `cd` and similar no longer break or hang their commands. ([058a031](https://github.com/babarot/dotfiles/commit/058a031))
- Every PATH entry is in `.zshenv`, because Claude Code restores the PATH captured from its shell snapshot. ([058a031](https://github.com/babarot/dotfiles/commit/058a031))
- Nix profiles come before Homebrew on PATH, so Nix-managed tools win over leftover brew duplicates. ([b48265b](https://github.com/babarot/dotfiles/commit/b48265b))
- There is no `.zprofile`. It was an old copy of `.zshenv` that login shells read afterwards, putting `~/bin` and Homebrew ahead of Nix and setting `EDITOR=vim` for agents, where `git commit` could hang. ([a454b98](https://github.com/babarot/dotfiles/commit/a454b98))
- Human-only settings go in `my.human`, rendered after the `is_human` guard; variables agents also need go in `my.env`. PATH stays in `.zshenv` since its order is global. ([a53df59](https://github.com/babarot/dotfiles/commit/a53df59), [51f7c5c](https://github.com/babarot/dotfiles/commit/51f7c5c))
- macOS's BSD userland stays on PATH. Agents know they run on macOS and write BSD syntax, so GNU tools come only under names that do not clash: `timeout`, which macOS lacks, and `gsed`. ([d14fcde](https://github.com/babarot/dotfiles/commit/d14fcde), [e597613](https://github.com/babarot/dotfiles/commit/e597613))
- zsh-abbr abbreviations are declared with `--session`. Otherwise zsh-abbr saved them to its user file, where one removed from Nix kept loading. ([a9b6fda](https://github.com/babarot/dotfiles/commit/a9b6fda))
- carapace completes only a listed set of commands (docker, terraform, go, brew, ...) that have no completion on fpath or an outdated one. Every other command keeps zsh's own; the generated files are named `_carapace_<cmd>` so they do not shadow zsh's `_go`. ([d5cc8f6](https://github.com/babarot/dotfiles/commit/d5cc8f6), [9cd58ac](https://github.com/babarot/dotfiles/commit/9cd58ac))
- mise trusts configs under `~/src/github.com/babarot` and `~/.herdr/worktrees`, since trust is per path and every new worktree would otherwise stop an agent on the prompt. Repos to try out go elsewhere. ([2e072e4](https://github.com/babarot/dotfiles/commit/2e072e4))

## Editor

- Neovim uses its built-in LSP and treesitter, with servers and parsers from Nix instead of mason and nvim-treesitter. nvim-treesitter is archived, mason-lspconfig's handlers were silently ignored, and Nix gives both Macs the same versions with nothing downloaded from inside Neovim. ([9dec4a1](https://github.com/babarot/dotfiles/commit/9dec4a1), [cd84813](https://github.com/babarot/dotfiles/commit/cd84813))
- go.nvim no longer runs its install-everything build step, whose tools in `~/bin` shadowed gopls and golangci-lint from Nix. ([f9ce075](https://github.com/babarot/dotfiles/commit/f9ce075))
- Plugins that current Neovim covers, or that stopped being maintained, are dropped or replaced; the `nvim-plugin-audit` skill repeats that review. ([6ba4481](https://github.com/babarot/dotfiles/commit/6ba4481), [88cfd22](https://github.com/babarot/dotfiles/commit/88cfd22), [3da640f](https://github.com/babarot/dotfiles/commit/3da640f), [eaca215](https://github.com/babarot/dotfiles/commit/eaca215), [0fa024e](https://github.com/babarot/dotfiles/commit/0fa024e))
- Neovim keeps the cwd at the project root instead of `:lcd` into each buffer's directory, so pickers and the terminal see the whole project. ([3450737](https://github.com/babarot/dotfiles/commit/3450737))
- Claude Code talks to Neovim through claudecode.nvim, since it runs in a herdr pane rather than an IDE's terminal. ([654fa71](https://github.com/babarot/dotfiles/commit/654fa71), [56be61b](https://github.com/babarot/dotfiles/commit/56be61b))

## Agents

- Claude Code settings are linked straight to `home/.claude/` in this repo, not the Nix store, because Claude Code writes `settings.json` itself; its edits show up as git diffs. ([0bdb8d5](https://github.com/babarot/dotfiles/commit/0bdb8d5))
- Agent Skills for Codex and other agents come from babarot/agent-skills, linked into `~/.agents/skills` and pinned by `flake.lock`; Claude Code gets the same skills from the plugin marketplace. Work skills go only to the work Mac. ([ae4e83a](https://github.com/babarot/dotfiles/commit/ae4e83a))
- Skills that ship with a tool are linked next to its package (`my.skills`), so an agent knows the tool as soon as it is installed. ([98aac8c](https://github.com/babarot/dotfiles/commit/98aac8c))
- `home/skills/` is a proving ground for my own skills: linked to the repo so edits apply at once, skipping the PR and release that babarot/agent-skills takes. ([721eea4](https://github.com/babarot/dotfiles/commit/721eea4))
- agent-browser's skill is rewritten to trigger only when asked for by name, because as shipped it tells agents to prefer it over claude-in-chrome. ([fb1360d](https://github.com/babarot/dotfiles/commit/fb1360d))
- The handoff skill runs only when invoked, since handing a session over is always the user's call. ([5f28f60](https://github.com/babarot/dotfiles/commit/5f28f60), [8f744f6](https://github.com/babarot/dotfiles/commit/8f744f6))
- Worktree branches land in main without a PR through `git land`, because git refuses to move a branch checked out in another worktree. It pushes only with `--push`. ([8b02af8](https://github.com/babarot/dotfiles/commit/8b02af8), [5d93075](https://github.com/babarot/dotfiles/commit/5d93075), [3b39d89](https://github.com/babarot/dotfiles/commit/3b39d89))

## CI and hooks

- The Macs are built by a pre-push hook, not CI. A fresh runner rebuilt everything on each push (12-17 min), mostly patched herdr and packages missing from cache.nixos.org, while the local store has them and sees the real agent-skills. CI runs `nix flake check` and evaluates each Mac. ([a1c790f](https://github.com/babarot/dotfiles/commit/a1c790f), [d164444](https://github.com/babarot/dotfiles/commit/d164444))
- CI cannot fetch the private agent-skills input, so the job creates an empty stub for it; the module only lists skill directories. The stub used to live in `ci/`. ([a1c790f](https://github.com/babarot/dotfiles/commit/a1c790f), [306f592](https://github.com/babarot/dotfiles/commit/306f592))
- The hook and CI take the hosts from `darwinConfigurations`, so a new Mac needs no change in either. ([d164444](https://github.com/babarot/dotfiles/commit/d164444))
- A pre-commit hook runs gitleaks and checks `nix fmt`, because most commits are written by agents and the repo is public. It is turned on by an `includeIf` in `.gitconfig`, so every Mac and worktree gets it without per-clone setup. ([417a936](https://github.com/babarot/dotfiles/commit/417a936))
- `nix fmt` runs nixfmt, deadnix, statix and shfmt, and `nix flake check` fails on unformatted files. statix's `empty_pattern` lint is off to keep `{ ... }:`. ([9ef3835](https://github.com/babarot/dotfiles/commit/9ef3835))
- Reviewed gitleaks findings (a public GPG key ID, a revoked 2017 token) go in `.gitleaksignore`. ([d679b02](https://github.com/babarot/dotfiles/commit/d679b02))

## Repo layout

- The dotfiles are linked into `~` by home-manager instead of `make install`, still pointing at the repo so edits apply without a switch. `~/.config` is linked as a whole by activation, because home-manager writes files inside it. ([1e957f1](https://github.com/babarot/dotfiles/commit/1e957f1))
- The repo root holds only `nix/`, `home/` and `docs/`; files linked into `~` moved under `home/`. ([a31cf20](https://github.com/babarot/dotfiles/commit/a31cf20), [1feb641](https://github.com/babarot/dotfiles/commit/1feb641))
- `nix/home` became `nix/home-manager`, since it and the root `home/` both said "home" for different things. ([f498323](https://github.com/babarot/dotfiles/commit/f498323))
- macOS System Settings are declared in [macos.nix](../../nix/macos.nix) from the Mac's current values, replacing screenshots in the setup guide that had drifted. ([50b7b6d](https://github.com/babarot/dotfiles/commit/50b7b6d))
- The README says what the repo is and why; details live in [structure.md](./structure.md), and AGENTS.md links there instead of keeping its own tree. ([e859585](https://github.com/babarot/dotfiles/commit/e859585), [4fe4271](https://github.com/babarot/dotfiles/commit/4fe4271))

## Tried and dropped

- afx, the Brewfile and the Makefile: replaced by the flake and nix-homebrew. ([754339f](https://github.com/babarot/dotfiles/commit/754339f), [1282eb4](https://github.com/babarot/dotfiles/commit/1282eb4), [52ac4c2](https://github.com/babarot/dotfiles/commit/52ac4c2))
- tmux: no longer installed; herdr, used inside Ghostty, got tmux's `ctrl+s` prefix and `prefix+o`. tpm and `.tmux.conf` stay for reference. cmux went from the work Mac. ([54f2dbf](https://github.com/babarot/dotfiles/commit/54f2dbf), [98aac8c](https://github.com/babarot/dotfiles/commit/98aac8c), [3c32ab9](https://github.com/babarot/dotfiles/commit/3c32ab9), [66dbc86](https://github.com/babarot/dotfiles/commit/66dbc86))
- Zed: tried on both Macs for running Claude Code and Codex inside it, then dropped; editing stays in Neovim inside herdr. ([ce6df8a](https://github.com/babarot/dotfiles/commit/ce6df8a), [12777d1](https://github.com/babarot/dotfiles/commit/12777d1))
- The main-drift hook, which told Claude when origin/main moved under its branch: it often ran past its 5s timeout and never reported a drift. ([8d22ee7](https://github.com/babarot/dotfiles/commit/8d22ee7), [7ef2478](https://github.com/babarot/dotfiles/commit/7ef2478))
- The herdr-activity sidebar row showing each session's latest tool call: turned off as more noise than help, with the code kept. Before that, reporting the branch from its hook gave way to patching herdr. ([7027b39](https://github.com/babarot/dotfiles/commit/7027b39), [44e84f7](https://github.com/babarot/dotfiles/commit/44e84f7), [bfd854c](https://github.com/babarot/dotfiles/commit/bfd854c), [b37be02](https://github.com/babarot/dotfiles/commit/b37be02))
- mason and nvim-treesitter, wilder.nvim, barbecue.nvim, diffview.nvim and others: see Editor. ([cd84813](https://github.com/babarot/dotfiles/commit/cd84813), [88cfd22](https://github.com/babarot/dotfiles/commit/88cfd22), [3da640f](https://github.com/babarot/dotfiles/commit/3da640f), [eaca215](https://github.com/babarot/dotfiles/commit/eaca215))
- Hand-kept completions in `~/.zsh/Completion` (a 2013 `_docker`, compose v1, ...): replaced by carapace. ([d5cc8f6](https://github.com/babarot/dotfiles/commit/d5cc8f6))
- Rust, global bun and yarn: no longer used, or moved to the one project that uses them. ([863cebe](https://github.com/babarot/dotfiles/commit/863cebe), [51f7c5c](https://github.com/babarot/dotfiles/commit/51f7c5c))
- Obsidian and TablePlus from nixpkgs: moved to casks over the broken code signature (see Packages). IINA and Equinox were dropped. ([0810eef](https://github.com/babarot/dotfiles/commit/0810eef), [39830a6](https://github.com/babarot/dotfiles/commit/39830a6), [3fdbf2a](https://github.com/babarot/dotfiles/commit/3fdbf2a), [532863d](https://github.com/babarot/dotfiles/commit/532863d))
- Pinning the Claude Code model in `settings.json`, so the default model is used. ([c4c1926](https://github.com/babarot/dotfiles/commit/c4c1926))
