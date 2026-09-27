# Homebrew only installs vendor apps on a new Mac. These apps update
# themselves or install system components, so Nix is a poor fit. Nothing
# is updated, upgraded or removed here; apps not listed are left alone.
#
# Homebrew itself must be installed first (see etc/docs/setup-mac.md).
# Mac App Store apps are in nix/home/tools/app-store.nix.
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
      "discord"
      "docker-desktop"
      "google-chrome"
      "google-drive"
      "logi-options+"
      "postman"
    ];
  };
}
