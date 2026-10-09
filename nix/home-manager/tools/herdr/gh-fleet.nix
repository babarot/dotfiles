# gh fleet's d removes herdr's worktrees through herdr, so a space open on
# one closes with it instead of being left on a directory that is gone.
# herdr worktree remove takes the space's id, not the path gh fleet passes,
# so a script looks it up; a worktree with no space open is removed with
# git, as gh fleet would. herdr runs git worktree remove itself and keeps
# the branch, which gh fleet deletes after.
#
# my.ghFleet comes from gh-fleet.nix. optionalAttrs (not mkIf, which still
# fails on an undeclared option) keeps this building without it; config is
# spelled out so the module's shape never depends on options.
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  remove = pkgs.writeShellApplication {
    name = "herdr-gh-fleet-remove";
    runtimeInputs = [
      config.my.herdr
      pkgs.jq
    ];
    # git is macOS's own
    text = ''
      path=$1
      # Without a running herdr server there is no space to close
      space=$(herdr worktree list --cwd "$PWD" 2>/dev/null |
        jq -r --arg p "$path" '.result.worktrees[] | select(.path == $p) | .open_workspace_id // empty') || space=
      if [ -n "$space" ]; then
        exec herdr worktree remove --workspace "$space"
      fi
      exec git worktree remove "$path"
    '';
  };
in
{
  config = lib.optionalAttrs (options.my ? ghFleet) {
    my.ghFleet.cleanup.worktree_remove = [
      (lib.getExe remove)
      "{path}"
    ];
  };
}
