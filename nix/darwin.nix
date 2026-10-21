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

  # The private keys of eight eMudhra intermediate CAs leaked in October 2026
  # (https://emudhra.we-have-a-problem.com/). Tools that read the Nix CA bundle
  # (NIX_SSL_CERT_FILE) do not check revocation, so drop the roots they chain to.
  # Remove once nixpkgs' cacert is NSS 3.131.1 or later.
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
