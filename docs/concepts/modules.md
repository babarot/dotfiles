# Modules

The home-manager modules in [nix/home-manager/](../../nix/home-manager/) define a few options of their own under `my.*`. They are what lets a tool file in `tools/` set its shell variables, aliases, plugins, skills and apps next to its package, as the [README](../../README.md#one-file-per-tool) describes. This page lists each option and how it reaches the Mac.

## Importing tools

[default.nix](../../nix/home-manager/default.nix) imports the modules below and every `*.nix` file in `tools/`. Only files ending in `.nix` are imported, so a tool's own scripts and patches can sit beside its file. Adding a tool means adding a file; nothing lists it.

Tool files for one Mac only sit in `nix/hosts/<host>/`. `mkHost` in [flake.nix](../../flake.nix) imports every `*.nix` directly in that directory into that Mac's home-manager user, beside default.nix, so they work like files in `tools/` and set the same `my.*` options. A Mac without the directory imports nothing more. What one file may hold (a single tool, a tool with companions, a `*.set.nix` or a list) is in [AGENTS.md](../../AGENTS.md#cohesion-one-file-one-lifecycle).

## Dotfile links

[dotfiles.nix](../../nix/home-manager/dotfiles.nix) links the hand-written files in `home/` into `~` under the same names. The links are made with `mkOutOfStoreSymlink` and point at the repo checkout, not the Nix store, so an edit applies without a switch. A new file still needs to be added to the list and switched once.

`~/.config` is linked to `home/.config` as a whole, so tools that write their own config keep writing it into the repo. It cannot be a `home.file` entry: home-manager itself writes files inside it. An activation script makes the link before home-manager checks its targets, so those generated files go through the link and land in the repo, where `home/.config/.gitignore` ignores them. If `~/.config` exists and is not that link, the switch stops and asks to move it aside.

## my.env

[env.nix](../../nix/home-manager/env.nix). Plain variables every zsh gets, AI agents included. Values are literal strings. They are rendered as `export` lines into `~/.config/zsh/env.zsh`, which [.zshenv](../../home/.zshenv) sources before the `is_human` branch.

Put a variable here when agents need it too and it belongs to one tool. Other variables not tied to a tool (locale, `EDITOR`) are in `.zshenv`.

`PATH` itself is hand-written in `.zshenv`, because its order is global and not any one tool's. A directory that one tool needs on PATH (krew's plugins in `~/.krew/bin`) goes in `my.path` next to the tool instead: env.zsh appends it to the end, when it exists, so it never reorders the hand-written list.

## my.gitConfig

[git.nix](../../nix/home-manager/git.nix). git settings that belong to a tool, by section: ov as the pager for `git log` and `git show`, the `dft` alias that runs difftastic. A tool's file writes them next to its package, with the store path of the command, and they are rendered into `~/.config/git/tools.gitconfig`. The hand-written [.gitconfig](../../home/.gitconfig) includes that file last, so it never names those tools; deleting a tool's file drops its git settings, and git falls back to its defaults.

## my.human

[human.nix](../../nix/home-manager/human.nix). Shell UX for humans only: environment variables, aliases, zsh plugins and free-form zsh. It is rendered into `~/.config/zsh/human.zsh`, which [.zshrc](../../home/.zshrc) sources after the `is_human` guard, so agents never load any of it. The options and the order they are written in are in human.nix.

Plugins are sourced in the order their `after` and `before` give, lists of other plugins' names, sorted as a DAG by home-manager's `lib.hm.dag.topoSort`. A name that is not a plugin is ignored, so removing a plugin's file never means editing the files that load around it; a cycle fails the build. Plugins with no constraint between them keep topoSort's order, which follows their names, so a plugin declares only the constraints it has a reason for, with the reason next to it. The hand-written `~/.zsh/[0-9]*.zsh` (bindkeys, aliases and functions, setopts, zstyles; a file without a numeric prefix is not loaded) is the entry `zsh-local` in human.nix, which the others place themselves around: zsh-abbr after it, since it binds space in the keymap `bindkey -v` selects, and fast-syntax-highlighting after it and everything else that defines widgets, since it wraps only the widgets that exist when it loads.

Abbreviations are declared with `abbr --session`, so none is saved to zsh-abbr's user file and one removed from Nix does not live on.

## my.ai

[ai.nix](../../nix/home-manager/ai.nix). The counterpart of `my.human`: environment variables and aliases for AI agents only. It is rendered into `~/.config/zsh/ai.zsh`, which [.zshenv](../../home/.zshenv) sources when `is_human` is false, so humans never load it.

Each setting then has one of three places, by who gets it:

| Who gets it | Option | Loaded by |
|---|---|---|
| humans only | `my.human` | `.zshrc`, after the `is_human` guard |
| agents only | `my.ai` | `.zshenv`, when `is_human` is false |
| both | `my.env` | `.zshenv`, before the `is_human` branch |

A setting both need but in different forms is written twice, once in `my.human` and once in `my.ai`, next to each other in the tool's file, rather than in a shared option that one side overrides. `BAT_PAGER` is `less -RF` for humans and `cat` for agents; `rm` is `gomi` in both, written twice on purpose so that agents getting it too reads as a decision.

An alias in `my.ai` has to behave like the command agents know, for every flag they write, without asking for input or changing output. Agents then use it as that command and never notice the difference. `rm` → gomi is the case this was made for: gomi takes rm's flags and exits like rm, and a mistaken `rm -rf` goes to the trash, where `gomi -b` brings it back. Anything that changes behavior an agent can see belongs in `my.human`.

An alias only reaches commands zsh runs itself. `xargs rm`, `find -exec rm` and scripts in other shells still get `/bin/rm`; that is accepted, since an `rm` on PATH would send every script's deletes to the trash too.

## my.skills

[skills.nix](../../nix/home-manager/skills.nix). Agent Skill directories (each holding a `SKILL.md`) by skill name. Each one is linked into both `~/.claude/skills/<name>` and `~/.agents/skills/<name>`, so Claude Code and Codex know how to use a tool as soon as it is installed. A tool file sets it next to the package, pointing at the skill the package ships.

The same module adds every directory in [home/skills/](../../home/skills/), my own skills on trial. Those links point at the main checkout, not the store, so edits apply without a switch once they are in it (a worktree edit applies when landed); a new skill needs a switch. Why the directory exists is in [ai-agents.md](./ai-agents.md#skills).

## my.agentSkills.scopes

[tools/agent-skills.nix](../../nix/home-manager/tools/agent-skills.nix). Which plugins of the private babarot/agent-skills input are linked into `~/.agents/skills`, for Codex and other agents. Work skills are picked only in the work Mac's host file. Each skill directory is linked on its own, so `~/.agents/skills` stays open to skills from elsewhere, including `my.skills`. Claude Code gets these skills from the plugin marketplace instead.

## my.herdrPlugins

[herdr-plugins.nix](../../nix/home-manager/herdr-plugins.nix). herdr plugins built by Nix, by plugin id.

On every switch, an activation script runs `herdr plugin link` on each store path. Linking never writes into the plugin directory, so a read-only store path works, and linking an id again replaces its old store path in `~/.config/herdr/plugins.json`. It then runs `herdr plugin unlink` on every registered plugin whose root is in `/nix/store` but whose id is no longer in `my.herdrPlugins`. Plugins installed or linked by hand are left alone. A failed link or unlink warns and does not stop the switch.

## my.forkPatches

[fork-patches.nix](../../nix/home-manager/fork-patches.nix). Packages built with local patches, by package name: the upstream source, the directory of patch files and the fork they are exported from. A tool's file declares its entry next to the package and applies the entry's `patches`; [.githooks/check-patches](../../.githooks/check-patches) reads the same entries to check the files against the fork's `patches` branch. How the patches are made and imported is in [maintenance.md](../guides/maintenance.md#patch-a-package-from-a-fork-branch).

## my.herdrWorktreeStatus

[tools/herdr-worktree-status.nix](../../nix/home-manager/tools/herdr-worktree-status.nix). Marks in herdr's sidebar for worktree workspaces, by token name: a shell condition, the repos it runs in and the mark it puts. Set per Mac in the host file; what the marks are for is in [workflow.md](./workflow.md#naming-a-workspace).

## my.masApps

[mas.nix](../../nix/home-manager/mas.nix). Mac App Store apps, shared in [tools/app-store.nix](../../nix/home-manager/tools/app-store.nix) or per host. Each switch installs the missing ones with `mas`. It only installs: versions and updates are left to the App Store, and an app dropped from the list is not removed. If an install fails (usually because nobody is signed in to the App Store), the switch warns and goes on.

## my.knownBins

[stray-bins.nix](../../nix/home-manager/stray-bins.nix). Commands that something outside Nix puts in a directory on PATH on purpose, by directory under `~`: `claude` in `.local/bin` (the official installer, from [tools/claude-code.nix](../../nix/home-manager/tools/claude-code.nix)), and in `go/bin` what go.nvim may `go install` (from [tools/neovim.nix](../../nix/home-manager/tools/neovim.nix)). Naming a directory, even with an empty list, has it checked.

Each switch warns about every other command in those directories: a `curl | sh` installer or `npm install -g` writes to `~/.local/bin`, and `go install` to `~/go/bin`, and nothing in this repo would show them. It removes nothing, unlike Homebrew's cleanup, since such a command cannot be declared without packaging it: move it into Nix, delete it, or, if it is meant to be there, add it to the list in the file of what puts it there.
