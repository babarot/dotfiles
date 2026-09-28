# Every file in ./tools is one tool: its package and its shell settings
# live together, so deleting the file removes both.
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
  ++ map (f: ./tools + "/${f}") (builtins.attrNames (builtins.readDir ./tools));

  home.stateVersion = "26.05";
}
