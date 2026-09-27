# Private Mac. Put settings that only this machine needs here.
{ ... }:
{
  # Vendor apps only for this Mac (see nix/homebrew.nix)
  homebrew.casks = [
    "autodesk-fusion"
    "bambu-studio"
    "parallels"
  ];

  home-manager.users.babarot = { ... }: { };
}
