# Workflow

How work gets done day to day: each change gets its own git worktree and herdr workspace, agents (Claude Code, Codex) work in it, I review their changes in panes next to them, and the branch lands in main. The pieces are set up in [herdr.nix](../../nix/home-manager/tools/herdr.nix), its plugins next to it, and [config.toml](../../home/.config/herdr/config.toml).

## One workspace per worktree

A worktree stays open for a whole feature, and each one gets its own herdr workspace. herdr creates the worktrees itself.

When herdr creates or opens a worktree workspace, a plugin ([herdr-worktree-layout.nix](../../nix/home-manager/tools/herdr-worktree-layout.nix)) lays it out with Claude Code, a reviewr pane beside it and a shell below them, all in the worktree. Reopening a worktree picks up Claude's conversation where it left off, and a workspace someone already arranged is left alone.

herdr's integrations for Claude Code and Codex are installed on every switch, so herdr resumes their conversations after its server restarts.

## Naming a workspace

A worktree workspace is named after what it is for, when it is created or later. The branch changes as the work moves on, so the name does not follow it.

herdr is patched ([herdr/](../../nix/home-manager/tools/herdr), one patch per change, each described in [herdr.nix](../../nix/home-manager/tools/herdr.nix)) so a named worktree workspace still shows its branch and its worktree directory, which other sessions go by.

A worktree workspace can also carry marks after its name, each put by a condition that holds in its folder. A launchd agent ([herdr-worktree-status.nix](../../nix/home-manager/tools/herdr-worktree-status.nix)) runs every condition, a line of shell set per Mac, in each worktree every 10 seconds, and reports the marks with a TTL, so they go away when the agent stops. On the private Mac, a green mark shows which worktrees have a minitube devstack running.

## Keys

The bindings, including the ones for the review plugins, are in [config.toml](../../home/.config/herdr/config.toml) with a comment on each. Two habits matter more than any one key: marking the panes in use with a leading `*` or `!` in their name, so they stand out among agents left idle, and jumping to the pane of the latest notification instead of hunting for it.

## Review

All of them show an agent's changes and send line comments back to it.

- [reviewr](../../nix/home-manager/tools/herdr-reviewr.nix): the pane the layout opens below the agent, files on the left and the diff on the right. It opens on the uncommitted edits; `b` switches to everything on the branch against main.
- [hunk-diff](../../nix/home-manager/tools/herdr-hunk-diff.nix): opens hunk on the focused agent's worktree and sends the comments to that agent. An agent can also drive hunk itself with its skill.
- [tuicr](../../nix/home-manager/tools/tuicr.nix): a review TUI the agent opens in a herdr pane through its skill, then reads the comments from.
- [crit](../../nix/home-manager/tools/crit.nix): `/crit` makes the agent start crit itself and wait for Finish Review, so every round's comments reach it directly. It also reviews plans and pages, not only code.

All of these are built by Nix; herdr plugins are registered with `herdr plugin link` on every switch ([herdr-plugins.nix](../../nix/home-manager/herdr-plugins.nix)), so both Macs run the same versions.

## Landing

Changes here usually go to main without a PR. A worktree branch lands in main with `git land`, an alias in [.gitconfig](../../home/.gitconfig): it rebases the branch onto main and fast-forwards main in the main worktree, since git will not move a branch checked out elsewhere. It stays local unless given `--push` (`-p`).

The [/land](../../home/skills/land/SKILL.md) skill has the agent commit its session's work and run `git land`, pushing only when a push is asked for in that request. The repo's pre-commit and pre-push hooks run as usual; the skill never skips them with `--no-verify`.

To continue the work in another session, [/handoff](../../home/skills/handoff/SKILL.md) writes a prompt for the next agent. It runs only when invoked.

## The other Mac

Both Macs work on this repo. A change for the other Mac is made and pushed from either one; the agent session on that Mac pulls and switches.

## Checks

- `.githooks/pre-commit` (turned on for this repo and its worktrees by an `includeIf` in [.gitconfig](../../home/.gitconfig)) runs gitleaks on the staged changes and checks `nix fmt`; when patch files are staged, `.githooks/check-patches` checks they are exported from the fork's pushed `patches` branch. When it stops a commit, remove the secret or stage the reformatted files; never bypass it with `--no-verify`. A reviewed false positive goes in `.gitleaksignore`.
- `.githooks/pre-push` builds every Mac at the pushed commit when the push changes Nix files, and warns (without stopping the push) when a fork's `patches` branch has moved ahead of the patch files; import it with the import-fork-patches skill. It uses the local store and the real `agent-skills`, so it is quick unless nixpkgs moved. When it fails, fix the build; do not push with `--no-verify`.
- CI (`.github/workflows/nix.yaml`) runs `nix flake check` and evaluates every Mac's system derivation on pushes to main and PRs that touch Nix files. It does not build them: a fresh runner rebuilds everything (~15 min), which the pre-push hook does locally from a warm store. It cannot fetch the private `agent-skills` input, so it overrides it with an empty stub made in the job; a change that only breaks with the real skills passes CI.

## mise in worktrees

mise records trust per path, so a fresh worktree would start untrusted and an agent there would stop on the prompt. [mise.nix](../../nix/home-manager/tools/mise.nix) trusts where my repos and their worktrees live, so they load their `mise.toml` unasked. Repos to try out go elsewhere.
