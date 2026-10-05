# Colors in home-manager's activation output (its "Activating ..." lines,
# warnEcho, errorEcho).
#
# What happens: nix-darwin's activate script starts with
# `#!/usr/bin/env -i`, which drops TERM. It then starts home-manager's
# activation with `sudo -u <user>`, and sudo, finding no TERM, sets
# TERM=unknown. home-manager decides on colors once, when its lib-bash is
# sourced: setupColors asks `tput colors`, which fails for "unknown", so
# every message comes out uncolored, warnings included.
#   - sudo setting TERM=unknown:
#     https://github.com/sudo-project/sudo/blob/7558270aec61b772a749409d62cb72ae0ef43296/plugins/sudoers/env.c#L1101-L1102
#
# Why TERM is dropped: nix-darwin empties the environment on purpose, so
# activation behaves the same whether `sudo darwin-rebuild` or its
# launchd daemon starts it, without depending on the caller's variables.
# TERM is among the ones it names as pointless for activation; losing
# colors was not discussed.
#   - "purify environment":
#     https://github.com/nix-darwin/nix-darwin/commit/4bff4bc8ae105dbc3a56ed5255fbde9495cbf4c1
#   - reverted, then landed again as "purify environment again":
#     https://github.com/nix-darwin/nix-darwin/commit/051283a8953d08a7c16de5304e8dba5c4418e02e
#   - in "The Plan, phase 1":
#     https://github.com/nix-darwin/nix-darwin/pull/1341
#
# What this does: as the first step, if home-manager left colors off, it
# runs setupColors again with a TERM that Nix's ncurses knows. The TERM is
# set for that call only, so no later step or command it starts sees it,
# and the caller's environment is still not used. When colors are already
# on (home-manager run on its own, with a real TERM), it does nothing.
# setupColors still leaves colors off when stdout is not a terminal or
# NO_COLOR is set.
#
# Why that is sound: it does not undo nix-darwin's purpose, since the value
# is fixed rather than taken from whoever started the switch, and it only
# touches home-manager's user activation; system activation and the boot
# daemon (which does not run home-manager) are unaffected. The catch is
# that setupColors is internal to home-manager (lib-bash promises no
# compatibility), hence the check that it exists: if it goes away, output
# is uncolored again and nothing else changes.
{ lib, ... }:
{
  home.activation.colors =
    lib.hm.dag.entryBefore
      [
        "checkAppManagementPermission"
        "checkFilesChanged"
        "checkLinkTargets"
      ]
      ''
        if declare -F setupColors >/dev/null && [[ -z ''${noteColor-} ]]; then
          TERM=xterm-256color setupColors
        fi
      '';
}
