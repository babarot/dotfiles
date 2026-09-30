# Mac App Store apps used on every Mac, installed by nix/home-manager/mas.nix
# (IDs: `mas list`). Host-only apps are in nix/hosts/<hostname>.nix.
{ ... }:
{
  my.masApps = {
    "1Password for Safari" = 1569813296;
    "Amphetamine" = 937984704;
    "DaisyDisk" = 411643860;
    "Day One" = 1055511498;
    "Magnet" = 441258766;
    "MenubarX" = 1575588022;
    "Paste" = 967805235;
    "Spark" = 1176895641;
    "Tailscale" = 1475387142;
    "Things" = 904280696;
    "Yoink" = 457622435;
  };
}
