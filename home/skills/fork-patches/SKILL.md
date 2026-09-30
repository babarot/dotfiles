---
name: fork-patches
description: Develop a change for a tool that babarot's dotfiles builds with patches from a fork (mo, gh-news, herdr and any other babarot/<name> fork with a patches branch). Work happens on the fork's patches branch, one commit per feature, checked and pushed there; dotfiles then imports the branch as patch files. Use when working in such a fork, e.g. "mo に機能を足したい", "gh-news のこの patch を直して", "patches ブランチを upstream の新しいリリースに載せ替えて". Not for importing the patches into dotfiles, which is the import-fork-patches skill there.
---

# fork-patches

Some tools in babarot's dotfiles are built from an upstream release with local patches. The patches are the commits of the `patches` branch of a fork `babarot/<name>`, exported with `git format-patch` into dotfiles. Development stays in the fork; dotfiles only imports what is pushed. The full guide is `~/src/github.com/babarot/dotfiles/docs/guides/maintenance.md` ("Patch a package from a fork branch").

## Where things are

- The fork is cloned at `~/src/github.com/babarot/<name>`: `origin` is the fork, `upstream` the original project.
- The `patches` branch sits on the upstream release tag the package is built from (`<tag>`). Find it from dotfiles:
  `nix eval --raw "$HOME/src/github.com/babarot/dotfiles#darwinConfigurations.pro23.config.home-manager.users.babarot.my.forkPatches.<name>.check.tag"`
- How to check the branch (tests, linters, toolchain) is in a comment in the tool's Nix file in dotfiles, by the package or its `my.forkPatches.<name>` entry: `git -C ~/src/github.com/babarot/dotfiles grep -n -B12 'my.forkPatches.<name> ='` and the top of that file.
- Other branches of the fork (`main`, old release branches) are not what dotfiles builds. Work on `patches` only.

## Rules

- One commit per feature. Each commit becomes one patch file, and its message is that patch's description: an imperative summary line and a body on what the change does and why, in English.
- A fix to an existing feature is folded into that feature's commit, not added on top: `git commit --fixup=<its commit>`, then `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <tag>`.
- Every commit on the branch must build and pass the checks on its own, not only the last one. Check each with `git rebase -x '<check command>' <tag>`.
- Commit nothing that is not a change to the tool: no notes, plans, CLAUDE.md or AGENTS.md, CI or release setup. Everything on the branch is shipped as a patch.
- Keep the change small enough to follow upstream: touch what the feature needs, match upstream's style and formatter, and do not reformat or refactor around it.
- When a patch changes dependencies (package.json and its lockfile, go.mod), commit the lockfile the project's own tool rewrites. The package's hashes in dotfiles change too; the import step handles that.

## Workflow

1. `git -C ~/src/github.com/babarot/<name> switch patches` and `git fetch origin` so you start from the pushed branch. If the local branch and `origin/patches` differ, find out why before going on.
2. Make the change and commit it as above.
3. Run the checks from the dotfiles comment, on every commit (`git rebase -x`). To try the tool itself, build it with the project's own tooling (e.g. `make build` for a Go project) and run it from the checkout, not from Nix.
4. Push. The branch is rebased, so the push rewrites it: `git push --force-with-lease origin patches`.
5. Tell the user the branch is pushed and that dotfiles imports it with the import-fork-patches skill (in the dotfiles repo). Do not write into dotfiles from here.

## Follow a new upstream release

1. `git fetch upstream --tags`, then `git rebase --onto <new> <tag> patches`, which moves only the commits after `<tag>`. A plain `git rebase <new>` can replay unrelated commits when upstream tags releases on release branches.
2. Resolve each conflict in the commit it belongs to. When upstream now does what a commit did, drop the commit; when upstream renamed or reworked what a commit touches, adapt the commit rather than adding a fix on top. New upstream tests that the patches break are fixed in the commit that breaks them.
3. Check every commit (`git rebase -x`), push, and tell the user that dotfiles needs the new `<new>` release too: the import-fork-patches skill moves the package's version and hashes along.
