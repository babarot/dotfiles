# Colors in home-manager's activation output (its "Activating ..." lines,
# warnEcho, errorEcho). nix-darwin runs activation with `env -i`, so TERM is
# gone, `tput colors` fails and home-manager turns its colors off. This sets
# a TERM that Nix's ncurses knows and has home-manager decide again, first
# thing; setupColors still leaves colors off when stdout is not a terminal
# or NO_COLOR is set. setupColors is internal to home-manager (lib-bash),
# hence the guard: if it goes away, output is only uncolored again.
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
        export TERM=xterm-256color
        if declare -F setupColors >/dev/null; then
          setupColors
        fi
      '';
}
