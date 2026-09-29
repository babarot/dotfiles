# herdr-activity: Claude Code hook that shows each Claude session's latest
# tool call in its row of herdr's sidebar, and the branch of its worktree
# space. The script is herdr-activity.sh; the hook is registered in
# home/.claude/settings.json (PostToolUse) and the $activity and $branch
# tokens are placed in home/.config/herdr/config.toml.
{ lib, pkgs, ... }:
{
  home.file.".claude/hooks/herdr-activity".source = lib.getExe (
    pkgs.writeShellApplication {
      name = "herdr-activity";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.git
        pkgs.herdr
        pkgs.jq
      ];
      text = builtins.readFile ./herdr-activity.sh;
    }
  );
}
