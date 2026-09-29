---
name: ff-main
description: Commit the work of this session and fast-forward main to it from a git worktree, without a PR and without pushing. For repositories where worktree branches go straight into main (dotfiles and the like).
disable-model-invocation: true
---

# ff-main

The user works in a git worktree of a repository that takes no PRs. Commit what this session changed, then bring the branch into main with `git ff-main` (an alias in babarot's `~/.gitconfig`: it rebases the branch onto main and fast-forwards main in the main worktree). Do not push; `git land` is the same plus a push, and the user asks for that separately.

## 1. Commit

- Look at `git status` and `git diff`. Commit only what this session changed; if other changes are there, leave them and say so.
- Follow the repository's rules for commits (AGENTS.md, CLAUDE.md, recent `git log`). Without any, write an imperative summary line and a short body on why.
- Split unrelated changes into separate commits.
- If the repository says to check something before committing (a build, tests, a formatter), do it first.
- If there is nothing to commit and the branch has no commits that main lacks, stop and say so.

## 2. Fast-forward main

Run `git ff-main` from the worktree.

- If the rebase stops on a conflict, resolve it only when the fix is obvious and within this session's changes; otherwise `git rebase --abort` and report.
- If it fails because the main worktree is not on main or cannot fast-forward, report the message; do not force anything.

## 3. Report

One or two lines: the commits made and the commit main now points at. Mention how far main is ahead of its remote, if it is.
