# Work Mac. Put settings that only this machine needs here.
{ ... }:
{
  home-manager.users.babarot =
    { pkgs, ... }:
    {
      # TODO(work setup): apps that may be needed only on the work Mac.
      # Uncomment what is actually used; all of these are in nixpkgs.
      #
      # home.packages = with pkgs; [
      #   slack
      #   zoom-us
      # ];
      #
      # Mac App Store apps only for work go here too, e.g.:
      # my.masApps = { "Some App" = 123456789; };
    };

  # TODO(work setup): vendor apps only for the work Mac, installed by
  # Homebrew (see nix/homebrew.nix), e.g.:
  # homebrew.casks = [ "some-vendor-app" ];
}
