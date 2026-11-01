# drop: a local-first home for HTML pages. Each folder in ~/drop is a site,
# pushed to my drop on Cloudflare; AI tools write pages there instead of
# calling an API. Both Macs push to the same instance and pull with
# `drop pull` (explicit, like git).
#
# Not declared here: the credentials. `drop login` stores the Access service
# token in the login keychain (service drop-cli), once on each Mac. Until
# then drop watch keeps running and reports each failed push (its log,
# `drop status`, a notification).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # From babarot/nur-packages, which GoReleaser updates on each drop release
  drop = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.drop;
  dir = "${config.home.homeDirectory}/drop";
in
{
  home.packages = [ drop ];

  # Generated rather than linked from the repo, so deleting this file removes
  # it; it is rarely edited
  xdg.configFile."drop/config.toml".text = ''
    remote = "https://drop.babarot.dev"
    dir = "${dir}"
  '';

  # Pushes a folder of ~/drop once its files have been quiet for a few
  # seconds. launchd's default PATH has /usr/bin, where drop finds security
  # (the keychain) and osascript (notifications)
  launchd.agents.drop-watch = {
    enable = true;
    config = {
      # drop watch exits when the sync directory is missing, as on a new Mac
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''/bin/mkdir -p "${dir}" && exec ${lib.getExe drop} watch''
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.xdg.stateHome}/drop-watch.log";
      StandardErrorPath = "${config.xdg.stateHome}/drop-watch.log";
      # Should it exit anyway, restart it at most once every 30s
      ThrottleInterval = 30;
    };
  };
}
