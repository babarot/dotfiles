# AI agents

How Claude Code, Codex and other coding agents are wired into this machine: where they come from, where they read settings and skills, and what a switch writes for them. The daily loop of worktrees, Herdr panes, review and landing is in [workflow.md](./workflow.md); the `my.*` options used below are described in [modules.md](./modules.md).

## At a glance

| Agent | Installed by | Settings | Skills |
|---|---|---|---|
| Claude Code | official installer, `~/.local/bin/claude` | `~/.claude/` (files linked from `home/.claude/`) | `~/.claude/skills`, plugin marketplace |
| Codex | nixpkgs (`pkgs.codex`) | `~/.codex/`, not managed here | `~/.agents/skills` |
| Others reading `~/.agents/skills` | per tool | not managed here | `~/.agents/skills` |

## Claude Code

Claude Code updates itself, so it does not come from nixpkgs. [claude-code.nix](../../nix/home-manager/tools/claude-code.nix) runs the official installer during activation only when `~/.local/bin/claude` is missing, e.g. on a new Mac.

User settings live in [home/.claude/](../../home/.claude), linked into `~/.claude` one file at a time ([claude-code.nix](../../nix/home-manager/tools/claude-code.nix) has the list). The links point at this repo, not the Nix store, because Claude Code writes to `settings.json` itself (`/config`, plugins, permissions); those edits show up as git diffs and are expected.

Claude Code gets my skills through babarot/agent-skills added as a plugin marketplace in `settings.json`. It also connects to Neovim on start (claudecode.nvim), since it runs in a herdr pane and would not find an IDE by itself.

### claude-recall

[claude-recall.nix](../../nix/home-manager/tools/claude-recall.nix) installs claude-recall (`recall`), which archives past agent sessions and finds them again from a TUI, the CLI or MCP. Its package ships a Claude Code plugin, linked into `~/.claude/skills` where it loads in place, so the plugin always matches the binary and needs no marketplace or hook in `settings.json`. Codex gets only the `recall` skill, in `~/.agents/skills`.

## Codex

[codex.nix](../../nix/home-manager/tools/codex.nix) installs Codex from nixpkgs and wraps it in a shell function. Codex runs commands inside the Seatbelt sandbox, which cannot read the Keychain, so `gh` fails to get its token there. The wrapper passes `GH_TOKEN` from `gh auth token` when Codex is launched. It is set in `my.human`, so it exists only in a human's shell.

`~/.codex/config.toml` is not managed by this repo, apart from what the Herdr integration adds.

## Skills

Skills reach the agents from four sources:

| Source | Declared in | Linked into |
|---|---|---|
| [babarot/agent-skills](https://github.com/babarot/agent-skills) (private, flake input over SSH) | [agent-skills.nix](../../nix/home-manager/tools/agent-skills.nix) | `~/.agents/skills`; Claude Code uses the marketplace instead |
| Skills that ship with a tool (crit, herdr, hunk, tuicr, ...) | `my.skills` in the tool's file | `~/.claude/skills` and `~/.agents/skills` |
| My own skills on trial | [home/skills/](../../home/skills) | `~/.claude/skills` and `~/.agents/skills`, pointing at the repo |
| claude-recall's plugin | [claude-recall.nix](../../nix/home-manager/tools/claude-recall.nix) | `~/.claude/skills` (plugin), `~/.agents/skills` (skill only) |

`home/skills/` is a proving ground for new skills of my own: a skill there can be tried without releasing babarot/agent-skills, and moves there once it settles ([maintenance.md](../guides/maintenance.md#retire-a-trial-skill)).

babarot/agent-skills is split into plugins, and each Mac picks which ones it links ([modules.md](./modules.md#myagentskillsscopes)). Updating it needs a build as yourself first; see [maintenance.md](../guides/maintenance.md#update-flake-inputs).

Tool skills are taken from the pinned package or source, so a skill always matches the binary it describes. A host can adjust one, as [pro23.nix](../../nix/hosts/pro23.nix) does for agent-browser so it does not take over from the Chrome extension.

A skill meant to run only on request says so twice: `disable-model-invocation` in `SKILL.md` for Claude Code and `allow_implicit_invocation` in `agents/openai.yaml` for Codex.

Repo-only skills, such as `nvim-plugin-audit`, live in [.claude/skills/](../../.claude/skills) and are not linked into `~`.

## Herdr

Herdr is where the agents run. [herdr.nix](../../nix/home-manager/tools/herdr.nix) reinstalls Herdr's Claude Code and Codex integrations on every switch, so Herdr can resume their conversations after its server restarts. They add a hook to each agent's settings (including this repo's `home/.claude/settings.json`) that does nothing outside Herdr.

## Shell

Agents run commands in the same zsh as I do, so the shell is plain by default. `.zshenv` decides whether a human is at the shell, and `.zshrc` stops there for agents. Every PATH entry agents need is set in `.zshenv`, since Claude Code restores the PATH it captured at start. One alias reaches agents on purpose: `rm` is gomi for them too, through `my.ai` ([modules.md](./modules.md#myai)), so a mistaken delete can be restored. Details are in the [README](../../README.md#shell-for-humans-and-ai-agents).

## AGENTS.md

[AGENTS.md](../../AGENTS.md) at the repo root is the entry point for any agent working on this repo: where things go, how to check a change for both Macs, and the rules for a public repo. Claude Code reads it because the repo has no `CLAUDE.md`. Personal instructions for every project are in `home/.claude/CLAUDE.md`, linked to `~/.claude/CLAUDE.md`.
