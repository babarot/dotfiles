---
name: import-fork-patches
description: Import the patches branch of a fork (babarot/mo, babarot/gh-news, babarot/herdr, ...) into this dotfiles repo as patch files, update the package's version and hashes when needed, build every Mac, commit and land. Use when a fork's patches branch has moved ahead, e.g. "mo の patch 取り込んで", "gh-news の patches を反映して", "patches ブランチの更新を取り込んで", or when pre-push warns that patch files differ from a fork's patches branch. Not for developing the change itself, which happens in the fork (the fork-patches skill).
---

# import-fork-patches

Packages declared in `my.forkPatches` (`nix/home-manager/fork-patches.nix`, one entry next to each package) are built with patch files exported from their fork's `patches` branch. The patch files are never edited here: `.githooks/check-patches --write` exports them again from the branch on GitHub. This skill brings a pushed branch in and ships it. The guide is `docs/guides/maintenance.md` ("Patch a package from a fork branch").

Work in a git worktree of this repo, as AGENTS.md says.

## 1. See what moved

Run `.githooks/check-patches` (all packages) or `.githooks/check-patches --only <name>`. It compares the staged patch files with each fork's `patches` branch on the tag the package is built from. It fetches from GitHub, so what is not pushed does not count; if the user expects a change that does not show, ask whether the branch was pushed.

When it says the branch is not on the package's tag, the branch was moved to another upstream release. Find the branch's base with `git -C ~/src/github.com/babarot/<name> fetch upstream --tags` and `git -C ~/src/github.com/babarot/<name> describe --tags --abbrev=0 origin/patches`, then:

- A package built from its release tag in its tool file (`fetchFromGitHub` with `tag` or `rev`): set `version` there to that release.
- A package from nixpkgs (overridden, like herdr): it follows nixpkgs. If the pinned nixpkgs builds another version, stop and tell the user: nixpkgs has to reach that version (`nix flake update nixpkgs`, a change of its own) or the branch has to go back.

## 2. Export

`.githooks/check-patches --write --only <name>` exports the branch over the package's patch files and stages them. Then look at what came in:

- `git diff --cached --stat -- nix/home-manager/tools/<name>/` and the subjects of added, removed and changed patches (`git diff --cached --name-status`, then the `Subject:` lines).
- Whether a patch now touches dependency files: `git diff --cached -- nix/home-manager/tools/<name>/ | grep -E '^\+\+\+ b/.*(package\.json|pnpm-lock\.yaml|go\.mod|go\.sum|Cargo\.(toml|lock))$'`.

## 3. Hashes and build

When the version moved or a patch changes dependencies, the package's fixed-output hashes change. In the tool file, set the affected ones to `lib.fakeHash` (with a version change, every hash in the file), build, and put back the hash each failure prints as `got:`, one at a time:

```bash
nix build .#darwinConfigurations.pro23.system --no-link
```

Without such changes the hashes stay as they are. Either way, finish with both Macs building (every host in `darwinConfigurations`):

```bash
nix build .#darwinConfigurations.pro23.system --no-link
nix build .#darwinConfigurations.PC-M-2025-026.system --no-link
```

A patch that fails to apply means the branch is not on the tag the package builds; go back to step 1. A build or test failure inside the package is the fork's to fix: stop, report it, and leave the fix to the fork (the fork-patches skill), since the patch files cannot be edited here.

Run `nix fmt` after editing a Nix file.

## 4. Commit and land

- One commit per package: `Update <name> patches` for a change on the same release, `Update <name> to v<new>` when the version moved. The body says what the new or changed patches do, from their subjects, and why the hashes changed if they did. No attribution trailers.
- pre-commit runs check-patches on the staged patch files; it must pass.
- Land with `git land` (the land skill). Push only when the user asks.
- Tell the user to apply it: `sudo darwin-rebuild switch --flake ~/src/github.com/babarot/dotfiles`, and to restart the tool if it runs as a server (`mo --restart`).
