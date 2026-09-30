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

## Patch a nixpkgs package

Herdr is the example: [herdr.nix](../../nix/home-manager/tools/herdr.nix) overrides nixpkgs' herdr with the patches in [tools/herdr/](../../nix/home-manager/tools/herdr/). The rules for the patches are in the comment at the top of herdr.nix.

To make a patch, clone herdr at the tag nixpkgs builds, make the change, and save the diff next to the others:

```bash
git clone --branch <tag> https://github.com/herdrdev/herdr
cd herdr
# edit, then
git diff > ~/src/github.com/babarot/dotfiles/nix/home-manager/tools/herdr/<change>.patch
```

Then list it in `patches` and `git add` the file so Nix can see it.

When a herdr bump breaks a patch, the build log names the patch that failed to apply. Remake that one patch against the new tag, or drop it if upstream took the change. The other patches stay as they are.

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
