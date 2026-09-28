# Homebrew only installs vendor apps on a new Mac. These apps update
# themselves, install system components, or have a broken code signature
# in nixpkgs, so Nix is a poor fit. Nothing is updated, upgraded or
# removed here; apps not listed are left alone.
#
# Homebrew itself is installed by nix-homebrew, which pins its version
# (update with `nix flake update nix-homebrew`). Mac App Store apps are
# in nix/home/tools/app-store.nix; host-only apps are in
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
      cleanup = "none";
    };
    casks = [
      "1password" # browser integration requires /Applications
      "cleanshot"
      "docker-desktop"
      "google-chrome"
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
