# Decisions

What was tried or used here and dropped, and why, so it is not brought back by mistake. A dropped thing has no file left to carry a comment, which is why it is written here.

Everything else has a home of its own. The reason for something that exists is a comment next to it, a rule agents follow is in [AGENTS.md](../../AGENTS.md), and the full history is in `git log`. Each entry names what replaced the dropped thing, and the commits in parentheses.

## Packages

- afx, the Brewfile and the Makefile: replaced by the flake, with Homebrew itself installed by nix-homebrew (`autoMigrate` took over the existing installs). ([a53df59](https://github.com/babarot/dotfiles/commit/a53df59), [754339f](https://github.com/babarot/dotfiles/commit/754339f), [1282eb4](https://github.com/babarot/dotfiles/commit/1282eb4), [52ac4c2](https://github.com/babarot/dotfiles/commit/52ac4c2))
- `go install`, afx and taps for my own tools: they are released by GoReleaser to babarot/nur-packages instead. ([5dacc8e](https://github.com/babarot/dotfiles/commit/5dacc8e), [087b476](https://github.com/babarot/dotfiles/commit/087b476), [8d39f04](https://github.com/babarot/dotfiles/commit/8d39f04), [f6ceea1](https://github.com/babarot/dotfiles/commit/f6ceea1))
- A `/usr/local/go` that ran under Rosetta: Go for arm64 comes from Nix. ([2b4aabd](https://github.com/babarot/dotfiles/commit/2b4aabd))
- Spotify, Obsidian and TablePlus from nixpkgs: their packages fail `codesign --verify --deep --strict`, and Spotify showed only a black window, so they are casks. IINA and Equinox were dropped. ([0810eef](https://github.com/babarot/dotfiles/commit/0810eef), [39830a6](https://github.com/babarot/dotfiles/commit/39830a6), [3fdbf2a](https://github.com/babarot/dotfiles/commit/3fdbf2a), [532863d](https://github.com/babarot/dotfiles/commit/532863d))
- Homebrew leaving undeclared casks and brews installed (`cleanup = "none"`): a cask removed from a host file, or tried with `brew install`, stayed for good. Undeclared ones are now uninstalled on switch. ([f348e27](https://github.com/babarot/dotfiles/commit/f348e27))
- Rust, and global bun and yarn: no longer used, or moved to the one project that uses them. ([863cebe](https://github.com/babarot/dotfiles/commit/863cebe), [51f7c5c](https://github.com/babarot/dotfiles/commit/51f7c5c))
- Hand-made patch files for herdr and gh-news, and mo built from its fork's own branch released to nur-packages: patches are commits on a fork's `patches` branch, exported with `git format-patch`. Hand-made diffs overlapped and had to be remade for each release, where a rebase carries commits over; mo's fork branch mixed its changes with reverted experiments and release commits. ([67a9973](https://github.com/babarot/dotfiles/commit/67a9973), [bfd854c](https://github.com/babarot/dotfiles/commit/bfd854c), [d13681f](https://github.com/babarot/dotfiles/commit/d13681f), [f3b72d8](https://github.com/babarot/dotfiles/commit/f3b72d8), [861c87e](https://github.com/babarot/dotfiles/commit/861c87e))

## Layout

- `make install`: home-manager links the dotfiles, still pointing at the repo. ([1e957f1](https://github.com/babarot/dotfiles/commit/1e957f1))
- Dotfiles at the repo root: they moved under `home/`. ([a31cf20](https://github.com/babarot/dotfiles/commit/a31cf20), [1feb641](https://github.com/babarot/dotfiles/commit/1feb641))
- `nix/home`: renamed `nix/home-manager`, since it and the root `home/` both said "home" for different things. ([f498323](https://github.com/babarot/dotfiles/commit/f498323))
- A `kubectl.nix` for both Macs beside loose Kubernetes lines in the work Mac's host file, with krew's `my.path` apart from krew: one `kubernetes.set.nix` for the work Mac. Sets were first called groups (`<subject>.group.nix`) and lists catalogs; the kinds were renamed so each name says it is about tools.
- Host files listing a one-Mac tool's package apart from its settings: one-Mac tool files go in `nix/hosts/<host>/`.
- Settled scripts in `home/bin`, which ran whatever their commands resolved to on PATH, unchecked: they are `writeShellApplication` with `runtimeInputs`, and `home/bin` is only for scripts still being shaped.
- `docs/reference/structure.md`, a full tree of the repo: `ls` and each file's opening comment say the same, so AGENTS.md keeps only what a listing does not show.
- Screenshots of System Settings in the setup guide, which had drifted: the settings are declared in `nix/macos.nix`. ([50b7b6d](https://github.com/babarot/dotfiles/commit/50b7b6d))

## Shell

- `.zprofile`: an old copy of `.zshenv` that login shells read afterwards, putting `~/bin` and Homebrew ahead of Nix and setting `EDITOR=vim` for agents, where `git commit` could hang. ([a454b98](https://github.com/babarot/dotfiles/commit/a454b98))
- Numbers ordering zsh plugins: a number said where a plugin went but not why, and nothing checked it. Plugins name what they load after or before. Writing only the constraints with a reason showed that fast-syntax-highlighting had been loading before `~/.zsh`, so nothing was highlighted while typing.
- zsh-abbr abbreviations saved to its user file: one removed from Nix kept loading. They are declared with `--session`. ([a9b6fda](https://github.com/babarot/dotfiles/commit/a9b6fda))
- Hand-kept completions in `~/.zsh/Completion` (a 2013 `_docker`, compose v1, ...): carapace, for a listed set of commands. ([d5cc8f6](https://github.com/babarot/dotfiles/commit/d5cc8f6))

## Editor

- mason and nvim-treesitter: servers and parsers come from Nix. nvim-treesitter is archived, and mason-lspconfig's handlers were silently ignored. ([9dec4a1](https://github.com/babarot/dotfiles/commit/9dec4a1), [cd84813](https://github.com/babarot/dotfiles/commit/cd84813))
- go.nvim's install-everything build step, whose tools in `~/bin` shadowed gopls and golangci-lint from Nix; then go.nvim installing what its keys use on first use, which a new Mac lacked. Those tools are on nvim's PATH from `neovim.nix`. ([f9ce075](https://github.com/babarot/dotfiles/commit/f9ce075), [ae181c2](https://github.com/babarot/dotfiles/commit/ae181c2))
- wilder.nvim, barbecue.nvim, diffview.nvim and other plugins current Neovim covers or nobody maintains; the `nvim-plugin-audit` skill repeats that review. ([6ba4481](https://github.com/babarot/dotfiles/commit/6ba4481), [88cfd22](https://github.com/babarot/dotfiles/commit/88cfd22), [3da640f](https://github.com/babarot/dotfiles/commit/3da640f), [eaca215](https://github.com/babarot/dotfiles/commit/eaca215), [0fa024e](https://github.com/babarot/dotfiles/commit/0fa024e))
- `:lcd` into each buffer's directory: the cwd stays at the project root, so pickers and the terminal see the whole project. ([3450737](https://github.com/babarot/dotfiles/commit/3450737))
- Zed, tried on both Macs for running Claude Code and Codex inside it: editing stays in Neovim inside herdr. ([ce6df8a](https://github.com/babarot/dotfiles/commit/ce6df8a), [12777d1](https://github.com/babarot/dotfiles/commit/12777d1))

## Terminal and agents

- tmux: herdr, inside Ghostty, got its `ctrl+s` prefix and `prefix+o`; its config and tpm went later. cmux went from the work Mac. ([54f2dbf](https://github.com/babarot/dotfiles/commit/54f2dbf), [98aac8c](https://github.com/babarot/dotfiles/commit/98aac8c), [3c32ab9](https://github.com/babarot/dotfiles/commit/3c32ab9), [66dbc86](https://github.com/babarot/dotfiles/commit/66dbc86))
- The main-drift hook, which told Claude when origin/main moved under its branch: it often ran past its 5s timeout and never reported a drift. ([8d22ee7](https://github.com/babarot/dotfiles/commit/8d22ee7), [7ef2478](https://github.com/babarot/dotfiles/commit/7ef2478))
- The herdr-activity sidebar row showing each session's latest tool call: more noise than help. Before that, reporting the branch from its hook gave way to patching herdr. ([7027b39](https://github.com/babarot/dotfiles/commit/7027b39), [44e84f7](https://github.com/babarot/dotfiles/commit/44e84f7), [bfd854c](https://github.com/babarot/dotfiles/commit/bfd854c), [b37be02](https://github.com/babarot/dotfiles/commit/b37be02))
- Pinning the Claude Code model in `settings.json`: the default model is used. ([c4c1926](https://github.com/babarot/dotfiles/commit/c4c1926))

## CI and hooks

- Building every Mac in CI: a fresh runner rebuilt everything on each push (12-17 min). CI only evaluates them; the pre-push hook builds them from the local store. ([a1c790f](https://github.com/babarot/dotfiles/commit/a1c790f), [d164444](https://github.com/babarot/dotfiles/commit/d164444))
- A `ci/` directory holding the agent-skills stub: the CI job creates it. ([306f592](https://github.com/babarot/dotfiles/commit/306f592))
