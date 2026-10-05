# Homebrew only installs vendor apps on a new Mac. These apps update
# themselves, install system components, or have a broken code signature
# in nixpkgs, so Nix is a poor fit. Nothing is updated or upgraded here,
# but casks and brews no file declares are uninstalled (cleanup below).
#
# Homebrew itself is installed by nix-homebrew, which pins its version
# (update with `nix flake update nix-homebrew`). Mac App Store apps are
# in nix/home-manager/tools/app-store.nix; host-only apps are in
# nix/hosts/<hostname>.nix.
{ config, ... }:
{
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    # Take over a Homebrew installed with the official script, keeping
    # its installed packages; does nothing on a Mac without one
    autoMigrate = true;
    # .zshenv puts /opt/homebrew/bin after the Nix profiles; brew shellenv
    # in /etc/zshrc would move it to the front
    enableZshIntegration = false;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Uninstall what no file declares, so a cask or brew tried by hand
      # goes away on the next switch, as removing a line here does
      cleanup = "uninstall";
    };
    casks = [
      "1password" # browser integration requires /Applications
      "cleanshot"
      "google-chrome"
      "google-japanese-ime" # an input method installs system components
      "numi"
      "obsidian"
      "spotify"
      "tableplus"
    ];
    # nix-darwin marks every entry `trusted: true` in the Brewfile, so
    # third-party taps are trusted per entry (Homebrew refuses to load
    # untrusted taps), never as a whole tap
    brews = [
      "franvy/gtab/gtab"
    ];
  };
}
