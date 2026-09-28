# Every .nix file in ./tools is one tool: its package and its shell settings
# live together, so deleting the file removes both. Other files there are
# the tools' own scripts, read by their .nix file.
{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./env.nix
    ./human.nix
    ./skills.nix
    ./herdr-plugins.nix
    ./mas.nix
  ]
  ++ map (f: ./tools + "/${f}") (
    builtins.filter (f: builtins.match ".*\\.nix" f != null) (builtins.attrNames (builtins.readDir ./tools))
  );

  home.stateVersion = "26.05";
}
