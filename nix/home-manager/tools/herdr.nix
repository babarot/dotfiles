# herdr: terminal multiplexer for coding agents, used inside Ghostty.
# Its settings live in home/.config/herdr/config.toml.
{
  config,
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
in
{
  # Everything that runs herdr (plugins, launchd agents) takes it from here,
  # so it is the patched build the user runs, not a second, unpatched one
  options.my.herdr = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    description = "herdr with this repo's patches.";
  };

  config.my.herdr = herdr;

  config.home.packages = [ herdr ];

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
