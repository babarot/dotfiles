# System-level settings shared by all Macs
{ inputs, ... }:
{
  # Nix itself is installed and managed by the Determinate installer
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "babarot";
  users.users.babarot.home = "/Users/babarot";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
