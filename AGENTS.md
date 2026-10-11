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

Everything here serves one goal: what deleting a tool's file does can be told from that file alone. Three properties make that true. Where no written rule fits, choose what keeps all three.

- Cohesion: deleting a tool's file removes everything that was for the tool (its package, aliases, variables, PATH entries, git settings, plugins and skills). A file holds one lifecycle; shared files (`human.zsh`, `env.zsh`, `tools.gitconfig`, ...) are assembled from what each tool's file contributes through `my.*`.
- Loose coupling: deleting a tool's file breaks nothing else. A file puts only its own tool and its companions on PATH; any other tool it runs, it runs by store path.
- Reproducibility: a new Mac gets the same thing. Everything is declared in this repo, in Nix where it can be; what Nix cannot hold is a declared exception, with its reason, in the file of what it is for.

The first two pull against each other. Adding a tool another file uses to your own `home.packages` keeps it from breaking but stops its file from removing it; calling it by name lets its file remove it but breaks you when it does. A store path keeps both.

Before finishing a change, ask of each file it touches: if this file were deleted, what would be left over, and what would break? Both answers must be "nothing".

Three rules follow from them:

- Never install a tool by hand (`brew install`, `npm install -g`, `curl ... | sh`, `go install`, `pipx install`, `cargo install`, `mise use -g`): it would be on one Mac only, at whatever version it was that day, and nothing would remove it. The exceptions that exist are intended; do not move them into Nix or remove them without asking.
- Patches are the last resort: each one has to be carried onto every upstream release. Do not propose one before going through [the steps before a patch](./docs/guides/maintenance.md#before-proposing-a-patch), and do not start one before the user agrees.
- The shell is plain for AI agents; human UX loads only when `is_human`. Aliases, prompts and interactive behavior go in `my.human`, never where agents run. Keep macOS's BSD userland on PATH; agents write BSD syntax.

## Before a task, read

| Before you | Read |
|---|---|
| add, move or remove a tool, app, setting, script or skill | [where-things-go.md](./docs/reference/where-things-go.md) |
| make one tool run another | [where-things-go.md](./docs/reference/where-things-go.md#dependencies-between-tools) |
| touch the shell: an alias, a variable, PATH | [ai-agents.md](./docs/concepts/ai-agents.md#shell), [modules.md](./docs/concepts/modules.md) |
| decide on an untracked file in `home/.config` | [where-things-go.md](./docs/reference/where-things-go.md#untracked-files-in-homeconfig) |
| patch a package, update flake inputs, deal with a failed switch | [maintenance.md](./docs/guides/maintenance.md) |

The rest of the docs are listed in [docs/README.md](./docs/README.md).

## Checking and applying changes

- Check without sudo, for both Macs, before asking the user to apply:
  `nix build .#darwinConfigurations.pro23.system --no-link` and the same for `PC-M-2025-026`.
- Nix only sees files tracked by git: `git add` (or `git add -N`) new files first.
- When the pre-commit or pre-push hook stops a commit or push, fix what it reports; a reviewed gitleaks false positive goes in `.gitleaksignore`. What the hooks and CI check is in [workflow.md](./docs/concepts/workflow.md#checks).
- Applying needs sudo, so the user runs it:
  `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles` (always the absolute path).

## Conventions

- English for comments, commit messages and docs; this repo is public.
- Say in a comment why anything unusual is there.
- Do not add a directory at the repository root without a strong reason; new files go under `nix/`, `home/` or `docs/` ([README](./README.md#layout)).
- `home/.claude/settings.json` is edited by Claude Code itself (`/config`); those edits show up as git diffs and are expected.
