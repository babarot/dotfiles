# Homebrew only installs vendor apps on a new Mac. These apps update
# themselves, install system components, or have a broken code signature
# in nixpkgs, so Nix is a poor fit. Nothing is updated, upgraded or
# removed here; apps not listed are left alone.
#
# Homebrew itself must be installed first (see etc/docs/setup-mac.md).
# Mac App Store apps are in nix/home/tools/app-store.nix; host-only apps
# are in nix/hosts/<hostname>.nix.
{ ... }:
{
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
