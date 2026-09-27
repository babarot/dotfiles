# Every file in ./tools is one tool: its package and its shell settings
# live together, so deleting the file removes both.
{ ... }:
{
  imports = [
    ./human.nix
    ./mas.nix
  ]
  ++ map (f: ./tools + "/${f}") (builtins.attrNames (builtins.readDir ./tools));

  home.stateVersion = "26.05";
}
