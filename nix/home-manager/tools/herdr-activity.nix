# herdr-activity: Claude Code hook that shows each Claude session's latest
# tool call in its row of herdr's sidebar. The script is herdr-activity.sh;
# the hook is registered in home/.claude/settings.json (PostToolUse) and the
# $activity token is placed in home/.config/herdr/config.toml. A herdr plugin
# (herdr-activity-idle.sh) dims the tool name while the agent is idle.
#
# Off for now. To turn it back on, set enable, add the PostToolUse hook back
# to home/.claude/settings.json and uncomment the row in config.toml.
{ lib, pkgs, ... }:
let
  enable = false;
  idle = lib.getExe (
    pkgs.writeShellApplication {
      name = "herdr-activity-idle";
      runtimeInputs = [
        pkgs.herdr
        pkgs.jq
      ];
      text = builtins.readFile ./herdr-activity-idle.sh;
    }
  );
in
{
  config = lib.mkIf enable {
    home.file.".claude/hooks/herdr-activity".source = lib.getExe (
      pkgs.writeShellApplication {
        name = "herdr-activity";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.herdr
          pkgs.jq
        ];
        text = builtins.readFile ./herdr-activity.sh;
      }
    );

    my.herdrPlugins."babarot.activity-idle" = pkgs.writeTextDir "herdr-plugin.toml" ''
      id = "babarot.activity-idle"
      name = "Activity idle"
      version = "0.1.0"
      min_herdr_version = "0.9.0"
      description = "Dim the latest tool call in the sidebar while its agent is idle."
      platforms = ["macos"]

      [[events]]
      on = "pane.agent_status_changed"
      command = ["${idle}"]
    '';
  };
}
