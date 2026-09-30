# Maintenance

Short recipes for keeping this flake up to date: updating inputs, patching and pinning packages, adding a Mac, and moving tools and skills in and out. Rules that live in a file's own comments are not repeated here. Checking a change and applying it follow the steps in [AGENTS.md](../../AGENTS.md#applying-and-checking-changes); they are not repeated here.

## Update flake inputs

```bash
nix flake update           # every input
nix flake update babarot   # only my own tools (babarot/nur-packages)
```

`agent-skills` is a private repo fetched over SSH with my key, which root does not have. After updating it, build as yourself so the source is in the store before `sudo darwin-rebuild` looks for it:

```bash
nix flake update agent-skills
nix build ".#darwinConfigurations.$(scutil --get LocalHostName).system" --no-link
```

## Pushing after a nixpkgs bump

[.githooks/pre-push](../../.githooks/pre-push) builds every Mac before a push that changes Nix files. It is usually quick because the local store already holds nearly everything. After nixpkgs moves, it rebuilds what cache.nixos.org does not have, such as the patched herdr and the packages built here from source, so expect the push to take a while. If a Mac does not build, fix it and push again; do not skip the hook.

## Patch a package from a fork branch

Two packages carry local patches, each applied from a directory in name order:

| Package | Built from | Patches | Fork |
|---|---|---|---|
| herdr | nixpkgs' package, overridden in [herdr.nix](../../nix/home-manager/tools/herdr.nix) | [tools/herdr/](../../nix/home-manager/tools/herdr/) | [babarot/herdr](https://github.com/babarot/herdr), `upstream` herdrdev/herdr |
| gh-news | its release tag, in [gh.nix](../../nix/home-manager/tools/gh.nix) | [tools/gh-news/](../../nix/home-manager/tools/gh-news/) | [babarot/gh-news](https://github.com/babarot/gh-news), `upstream` chmouel/gh-news |

The patch files are not edited by hand. Each one is a commit on the fork's `patches` branch, exported with `git format-patch`, so git does the rebasing onto a new release and every file carries its commit message. Each fork is cloned at `~/src/github.com/babarot/<name>`, with `origin` the fork. The examples below run there, with `<name>` the package and `<version>` the release the branch sits on: for herdr the version nixpkgs builds (`nix eval --raw .#darwinConfigurations.pro23.pkgs.herdr.version` in dotfiles), for gh-news the `version` in gh.nix.

Change a patch or add one:

```bash
git switch patches
# edit, then commit: one commit per feature
git commit                        # a new feature
git commit --fixup=<its commit>   # a fix to an existing one, then fold it in:
git rebase --autosquash v<version>
```

Check it, then push the branch. It is rebased, so the push rewrites it. gh-news is checked with a throwaway Rust toolchain:

```bash
nix shell 'nixpkgs#cargo' 'nixpkgs#rustc' 'nixpkgs#clippy' 'nixpkgs#rustfmt' \
  -c sh -c 'cargo fmt --check && cargo clippy --all-targets && cargo test'
git push --force-with-lease origin patches
```

herdr's whole test suite depends on the host, so run the tests the patches touch by building it with the `doCheck` lines in the comment at the top of herdr.nix, after exporting.

Then export the patches over the old ones and `git add` them. The Nix file picks up whatever the directory holds, so it needs no change:

```bash
dir=~/src/github.com/babarot/dotfiles/nix/home-manager/tools/<name>
rm "$dir"/*.patch
git format-patch --no-numbered --zero-commit --no-signature -o "$dir" v<version>
```

`--no-numbered`, `--zero-commit` and `--no-signature` keep a file unchanged when only the number of patches, commit hashes or the git version change.

Follow a new release (for herdr, when a nixpkgs bump moves its version and the build log names a patch that failed to apply):

1. `git fetch upstream --tags`, then `git rebase --onto v<new> v<version>`, which moves only the commits after `v<version>`. herdr tags each release on a release branch, so an older tag is not an ancestor of a newer one and a plain `git rebase v<new>` would try to replay that branch's other commits too. If a commit conflicts, resolve it; if upstream took the change, drop the commit.
2. Check, push and export as above, with `v<new>`.
3. For gh-news, set `version` in gh.nix to the new release and both hashes to `lib.fakeHash`, then build: each failure prints the right hash to put back. herdr follows nixpkgs and needs nothing more.

## Bump a flake input pinned to a tag

Tools that are not in nixpkgs but ship a flake, like crit, are inputs pinned to a release tag in [flake.nix](../../flake.nix). Change the tag in the input's `url`, then relock it:

```bash
nix flake update crit
```

crit's Claude Code skills come from the same pinned source ([crit.nix](../../nix/home-manager/tools/crit.nix)), so they follow the binary.

## Add a Mac

1. Get the new Mac's hostname with `scutil --get LocalHostName`.
2. Copy an existing host file to `nix/hosts/<hostname>.nix` and keep only what that Mac needs.
3. Add `"<hostname>" = mkHost ./nix/hosts/<hostname>.nix;` to `darwinConfigurations` in [flake.nix](../../flake.nix).
4. `git add` the new host file.
5. Add the Mac to the host tables in [AGENTS.md](../../AGENTS.md) and [structure.md](../reference/structure.md#two-macs-one-flake).

CI and the pre-push hook read the hosts from `darwinConfigurations`, so neither needs a change. Setting up the machine itself is in [setup-mac.md](./setup-mac.md#nixzsh).

## Add a tool

Where a tool goes depends on what it is: the table under "Where things go" in [AGENTS.md](../../AGENTS.md#where-things-go) picks the file. Usually it is a new `nix/home-manager/tools/<tool>.nix`, imported automatically; remember to `git add` it.

## Retire a trial skill

Skills in `home/skills/<name>` are on trial and link straight to this repo. Once one settles:

1. Move it to babarot/agent-skills and release it there.
2. Delete `home/skills/<name>` here.
3. Update the input and build as yourself, as in [Update flake inputs](#update-flake-inputs):

```bash
nix flake update agent-skills
nix build ".#darwinConfigurations.$(scutil --get LocalHostName).system" --no-link
```

After the switch, Codex and other agents get it from `~/.agents/skills`; Claude Code gets it from the plugin marketplace.
