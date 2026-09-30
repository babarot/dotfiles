# herdr-devstack: marks the herdr spaces whose folder has a minitube devstack
# running, in the $devstack token of the sidebar row
# (home/.config/herdr/config.toml). The script is herdr-devstack.sh, kept
# running by launchd. On only where a host file sets
# my.herdrDevstack.enable, since devstacks run only on the private Mac.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "herdr-devstack";
    runtimeInputs = [
      pkgs.gnugrep
      pkgs.herdr
      pkgs.jq
    ];
    text = builtins.readFile ./herdr-devstack.sh;
  };
in
{
  options.my.herdrDevstack.enable = lib.mkEnableOption "the devstack mark in herdr's sidebar";

  config = lib.mkIf config.my.herdrDevstack.enable {
    launchd.agents.herdr-devstack = {
      enable = true;
      config = {
        ProgramArguments = [ (lib.getExe script) ];
        RunAtLoad = true;
        KeepAlive = true;
        # docker is OrbStack's, linked into /usr/local/bin; runtimeInputs
        # come before this
        EnvironmentVariables.PATH = "/usr/local/bin:/usr/bin:/bin";
        StandardErrorPath = "${config.xdg.stateHome}/herdr-devstack.log";
        # Should the script itself fail, restart it at most once every 30s
        ThrottleInterval = 30;
      };
    };
  };
}
