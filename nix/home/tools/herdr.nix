# herdr: terminal multiplexer for coding agents, used inside Ghostty.
# Its settings live in home/.config/herdr/config.toml.
{ lib, pkgs, ... }:
let
  # Small patches on nixpkgs' herdr, one per change, made against its release
  # tag and applied in order. Patching loses the binary cache, so a herdr or
  # nixpkgs bump builds herdr locally (~9 min).
  herdr = pkgs.herdr.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # A worktree space renamed after its feature keeps its branch and
      # ahead/behind in the sidebar; herdr hides them on every grouped
      # worktree (herdrdev/herdr#2952)
      ./herdr/renamed-worktree-branch.patch
      # A `worktree` space token: the checkout's directory name, which other
      # sessions go by
      ./herdr/worktree-token.patch
    ];
  });
in
{
  home.packages = [ herdr ];

  my.skills.herdr = "${herdr}/share/skills/herdr/herdr";

  # The integrations let herdr resume Claude Code and Codex conversations
  # after its server restarts (e.g. a reboot). The hook scripts come from
  # herdr itself, so reinstalling on every switch keeps them at its version.
  # It is idempotent and only adds a SessionStart hook to
  # ~/.claude/settings.json (this repo's home/.claude/settings.json) and
  # ~/.codex/hooks.json, plus `[features] hooks = true` in
  # ~/.codex/config.toml. The hooks do nothing outside herdr.
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for agent in claude codex; do
      run ${herdr}/bin/herdr integration install "$agent" >/dev/null \
        || warnEcho "herdr: installing the $agent integration failed"
    done
  '';
}
