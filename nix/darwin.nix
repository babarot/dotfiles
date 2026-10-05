# System-level settings shared by all Macs
{ inputs, user, ... }:
{
  # Nix itself is installed and managed by the Determinate installer
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Many GUI apps and some CLI tools (terraform, zsh-abbr) are unfree.
  # Set here because home-manager uses this pkgs (useGlobalPkgs).
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user;
  # home-manager takes home.username and home.homeDirectory from here
  users.users.${user}.home = "/Users/${user}";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
