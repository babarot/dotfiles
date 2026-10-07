# herdr-worktree-status: marks on the sidebar rows of herdr's worktree
# spaces, each put by a condition (shell) that is true in the space's folder.
# A file in nix/hosts/<host>/ sets the conditions, since what is worth a
# mark differs by Mac (guarded, see nix/hosts/pro23/herdr-devstack.nix):
#
#   my.herdrWorktreeStatus.devstack = {
#     repos = [ "minitube" ];
#     condition = "test -f compose.devstack.yaml && ...";
#   };
#
# shows ● as $devstack, placed and styled in home/.config/herdr/config.toml.
# The script is worktree-status.sh, kept running by launchd while any
# condition is set.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.herdrWorktreeStatus;
  script = pkgs.writeShellApplication {
    name = "herdr-worktree-status";
    runtimeInputs = [
      pkgs.coreutils
      config.my.herdr
      pkgs.jq
    ];
    text = builtins.readFile ./worktree-status.sh;
  };
  conditions = pkgs.writeText "herdr-worktree-status.json" (
    builtins.toJSON (lib.mapAttrsToList (name: c: { inherit name; } // c) cfg)
  );
in
{
  options.my.herdrWorktreeStatus = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          condition = lib.mkOption {
            type = lib.types.str;
            description = "Shell run with bash -c in each space's folder; exit 0 puts the mark.";
          };
          repos = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Repo names (herdr's repo_name) to run it in; empty runs it in every worktree space.";
          };
          mark = lib.mkOption {
            type = lib.types.str;
            default = "●";
            description = "The token's value while the condition is true.";
          };
        };
      }
    );
    default = { };
    description = "Sidebar marks for herdr's worktree spaces by token name.";
  };

  config = lib.mkIf (cfg != { }) {
    # herdr takes token names of 1-32 letters, digits, _ and -
    assertions = lib.mapAttrsToList (name: _: {
      assertion = builtins.match "[A-Za-z0-9_-]{1,32}" name != null;
      message = "my.herdrWorktreeStatus.${name}: herdr token names are 1-32 letters, digits, _ or -";
    }) cfg;

    launchd.agents.herdr-worktree-status = {
      enable = true;
      config = {
        ProgramArguments = [
          (lib.getExe script)
          "${conditions}"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        # Conditions call tools from anywhere: the Nix profiles, and
        # /usr/local/bin for OrbStack's docker. runtimeInputs come before this
        EnvironmentVariables.PATH = lib.concatStringsSep ":" [
          "/etc/profiles/per-user/${config.home.username}/bin"
          "/run/current-system/sw/bin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
        ];
        StandardErrorPath = "${config.xdg.stateHome}/herdr-worktree-status.log";
        # Should the script itself fail, restart it at most once every 30s
        ThrottleInterval = 30;
      };
    };
  };
}
