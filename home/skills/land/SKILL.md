---
name: land
description: Commit this session's work in a git worktree and land it in main without a PR (rebase, then fast-forward main in the main worktree), pushing only when asked. Use when the user says to land, bring the branch into main, or "land and push" in a repository whose worktree branches go straight into main, such as dotfiles. Not for repositories that take PRs.
---

# land

The user works in a git worktree of a repository that takes no PRs. Commit what this session changed, then land the branch in main with `git land` (an alias in babarot's `~/.gitconfig`: it rebases the branch onto main and fast-forwards main in the main worktree). `git land --push` also pushes main.

## When to run it

- Run it when the user asks to land the work, bring it into main, or finish the branch. Doing the task is not a request to land it.
- Push (`--push`) only when the user asks for a push in this request. Landing locally does not imply a push, and a push earlier in the conversation does not carry over.
- If the repository takes PRs (a PR template, branch protection, or AGENTS.md says so), do not land; say so instead.

## 1. Commit

- Look at `git status` and `git diff`. Commit only what this session changed; if other changes are there, leave them and say so.
- Follow the repository's rules for commits (AGENTS.md, CLAUDE.md, recent `git log`). Without any, write an imperative summary line and a short body on why.
- Split unrelated changes into separate commits.
- If the repository says to check something before committing (a build, tests, a formatter), do it first.
- If there is nothing to commit and the branch has no commits that main lacks, stop and say so.

## 2. Land

Run `git land`, or `git land --push` when a push was asked for, from the worktree.

- If the rebase stops on a conflict, resolve it only when the fix is obvious and within this session's changes; otherwise `git rebase --abort` and report.
- If it fails because the main worktree is not on main or cannot fast-forward, report the message; do not force anything.
- If the push is rejected or a pre-push hook fails, report it; never push with `--no-verify` or `--force`.

## 3. Report

One or two lines: the commits made and the commit main now points at. Say whether it was pushed, or how far main is ahead of its remote if not. If the user asked to watch CI after a push, follow the run to the end and report its result.
