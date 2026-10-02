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

Some packages carry local patches, applied from a directory in name order. Each declares its entry in `my.forkPatches` ([fork-patches.nix](../../nix/home-manager/fork-patches.nix)) next to the package, which names the fork, the upstream source and the patch directory; `git grep my.forkPatches` lists them.

The patch files are not edited by hand. Each one is a commit on the fork's `patches` branch, exported with `git format-patch`, so git does the rebasing onto a new release and every file carries its commit message. [.githooks/check-patches](../../.githooks/check-patches) holds this: it exports each package's patches again from the branch on GitHub, on the tag the package is built from, and fails when the committed files differ. pre-commit runs it when patch files are staged, and [patches.yaml](../../.github/workflows/patches.yaml) in CI when they change. It compares with the pushed branch, so push the branch before exporting. pre-push runs it too on the pushed main and warns, without stopping the push, when a fork's branch has moved ahead of the patch files, so a change made in the fork is not left out.

Each fork is cloned at `~/src/github.com/babarot/<name>`, with `origin` the fork and `upstream` the original. The examples below run there, with `<name>` the package and `<tag>` the release the branch sits on, the one the package is built from:

```bash
nix eval --raw "$HOME/src/github.com/babarot/dotfiles#darwinConfigurations.pro23.config.home-manager.users.babarot.my.forkPatches.<name>.check.tag"
```

Development stays in the fork and distribution in dotfiles: a change is made, tested and pushed on the `patches` branch, and dotfiles only exports the patches and builds. Two skills follow these steps: [fork-patches](../../home/skills/fork-patches/SKILL.md) in the fork, and [import-fork-patches](../../.claude/skills/import-fork-patches/SKILL.md) in this repo. dotfiles could instead take the `patches` branch itself as the source (a flake input or `fetchFromGitHub` pointing at it), so that shipping a change is only `nix flake update`. The patches are kept here anyway, so that what is added to each package can be read in this repo and every patched package is handled the same way. The export is one command (below).

Change a patch or add one:

```bash
git switch patches
# edit, then commit: one commit per feature
git commit                        # a new feature
git commit --fixup=<its commit>   # a fix to an existing one, then fold it in:
git rebase --autosquash <tag>
```

Check it as the package's .nix file says, in a comment by the package or its `my.forkPatches` entry, then push the branch. It is rebased, so the push rewrites it:

```bash
git push --force-with-lease origin patches
```

Then export the patches in dotfiles. This writes the pushed branch over the package's patch files with `git format-patch` and stages them; the Nix file picks up whatever the directory holds, so it needs no change:

```bash
.githooks/check-patches --write --only <name>
```

It exports with `--no-numbered`, `--zero-commit` and `--no-signature`, which keep a file unchanged when only the number of patches, commit hashes or the git version change, and with the histogram diff algorithm and no user git config, so every Mac and CI split the hunks the same way.

Follow a new release (for a package from nixpkgs, when a nixpkgs bump moves its version and the build log names a patch that failed to apply):

1. `git fetch upstream --tags`, then `git rebase --onto <new> <tag>`, which moves only the commits after `<tag>`. Some projects tag each release on a release branch (herdr does), so an older tag is not an ancestor of a newer one and a plain `git rebase <new>` would try to replay that branch's other commits too. If a commit conflicts, resolve it; if upstream took the change, drop the commit.
2. Check, push and export as above, with `<new>`.
3. For a package built from its release tag in its tool file, set `version` to the new release and every hash in the file to `lib.fakeHash`, then build: each failure prints the right hash to put back. A package from nixpkgs follows nixpkgs and needs nothing more.

Patch another package: make a fork `babarot/<name>` with the patches on a `patches` branch based on the release tag, export them into `nix/home-manager/tools/<name>/`, and declare them next to the package, where `src` is the upstream source the patches apply to (fetched with `fetchFromGitHub` from that tag):

```nix
# How to check the patches branch: ...
my.forkPatches.<name> = {
  inherit (<package>) src;
  dir = ./<name>;
};
```

The package applies `config.my.forkPatches.<name>.patches`. Set `fork` when the fork has another name. check-patches picks the new entry up by itself.

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
5. Add the Mac to the host table in [AGENTS.md](../../AGENTS.md) and to the hosts named in [structure.md](../reference/structure.md#two-macs-one-flake) and [setup-mac.md](./setup-mac.md#nixzsh).

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
