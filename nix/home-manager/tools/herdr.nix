# herdr: terminal multiplexer for coding agents, used inside Ghostty.
# Its settings live in home/.config/herdr/config.toml.
#
# Its companions, which exist only for herdr, are imported from herdr/ below,
# so deleting this file removes them too: the plugins, the sidebar marks'
# agent and my.herdrPlugins, the module the plugins register through.
# herdr-worktree-ctl, a script kept in a gist, is built here.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Small patches on nixpkgs' herdr, one per change, applied in name order;
  # each patch's message says what it does. They are exported from a fork
  # branch on the tag nixpkgs builds, not edited here
  # (docs/guides/maintenance.md). Patching loses the binary cache, so a herdr
  # or nixpkgs bump builds herdr locally (~9 min).
  #
  # Each patch also updates herdr's tests. nixpkgs leaves them off
  # (doCheck = false) because they change between releases and depend on the
  # host; to run the ones the patches touch, add these below and nix build:
  #   doCheck = true;
  #   checkFlags = [ "client::shell::tests" "client::shell::endpoint_agent_state" "ui::sidebar" ];
  herdr = pkgs.herdr.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ config.my.forkPatches.herdr.patches;
  });

  # herdr-worktree-ctl: list herdr's worktrees with whether a space is open
  # on each, its uncommitted changes, commits not in the default branch,
  # the processes working in it and its last activity, and remove the ones
  # picked with fzf; closing a worktree space leaves the checkout behind.
  # The Deno script and its tests live in a gist (the herdr-worktree-ctl
  # input in flake.nix); `nix flake update herdr-worktree-ctl` takes an
  # edit. The tests run at build time, against real git repositories and a
  # fake herdr, lsof, fzf and trash, so an edit that breaks them does not
  # build.
  herdr-worktree-ctl =
    pkgs.runCommand "herdr-worktree-ctl"
      {
        nativeBuildInputs = [
          pkgs.deno
          pkgs.git
          pkgs.makeWrapper
        ];
      }
      ''
        export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
        deno test --allow-all --no-lock ${inputs.herdr-worktree-ctl}/herdr-worktree-ctl_test.ts

        # Prefixed, so this herdr and the fzf pinned here win; fzf runs the
        # preview on this PATH. git, lsof and trash are macOS's own
        makeWrapper ${lib.getExe pkgs.deno} $out/bin/herdr-worktree-ctl \
          --add-flags "run --no-lock --allow-run=git,herdr,lsof,fzf,trash --allow-read --allow-write --allow-env ${inputs.herdr-worktree-ctl}/herdr-worktree-ctl.ts" \
          --prefix PATH : ${
            lib.makeBinPath [
              herdr
              pkgs.fzf
            ]
          }
      '';
in
{
  imports = [
    ./herdr/plugins.nix
    ./herdr/hunk-diff.nix
    ./herdr/reviewr.nix
    ./herdr/worktree-layout.nix
    ./herdr/worktree-status.nix
  ];

  # Everything that runs herdr (plugins, launchd agents) takes it from here,
  # so it is the patched build the user runs, not a second, unpatched one
  options.my.herdr = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    description = "herdr with this repo's patches.";
  };

  config.my.herdr = herdr;

  config.home.packages = [
    herdr
    herdr-worktree-ctl
  ];

  config.my.forkPatches.herdr = {
    inherit (pkgs.herdr) src;
    dir = ./herdr;
  };

  config.my.skills.herdr = "${herdr}/share/skills/herdr/herdr";

  # The integrations let herdr resume Claude Code and Codex conversations
  # after its server restarts (e.g. a reboot). The hook scripts come from
  # herdr itself, so reinstalling on every switch keeps them at its version.
  # It is idempotent and only adds a SessionStart hook to
  # ~/.claude/settings.json (this repo's home/.claude/settings.json) and
  # ~/.codex/hooks.json, plus `[features] hooks = true` in
  # ~/.codex/config.toml. The hooks do nothing outside herdr.
  config.home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for agent in claude codex; do
      run ${herdr}/bin/herdr integration install "$agent" >/dev/null \
        || warnEcho "herdr: installing the $agent integration failed"
    done
  '';
}
