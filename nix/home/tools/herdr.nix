# herdr: terminal multiplexer for coding agents, used inside Ghostty.
# Its settings live in .config/herdr/config.toml.
{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.herdr ];

  my.skills.herdr = "${pkgs.herdr}/share/skills/herdr/herdr";

  # The integrations let herdr resume Claude Code and Codex conversations
  # after its server restarts (e.g. a reboot). The hook scripts come from
  # herdr itself, so reinstalling on every switch keeps them at its version.
  # It is idempotent and only adds a SessionStart hook to
  # ~/.claude/settings.json (this repo's home/.claude/settings.json) and
  # ~/.codex/hooks.json, plus `[features] hooks = true` in
  # ~/.codex/config.toml. The hooks do nothing outside herdr.
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for agent in claude codex; do
      run ${pkgs.herdr}/bin/herdr integration install "$agent" >/dev/null \
        || warnEcho "herdr: installing the $agent integration failed"
    done
  '';
}
