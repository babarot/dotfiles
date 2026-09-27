# System-level settings shared by all Macs
{ inputs, lib, ... }:
{
  # Nix itself is installed and managed by the Determinate installer
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow unfree packages one by one. Set here because home-manager uses
  # this pkgs (useGlobalPkgs).
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "zsh-abbr" # CC BY-NC-SA 4.0
    ];

  system.primaryUser = "babarot";
  users.users.babarot.home = "/Users/babarot";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
