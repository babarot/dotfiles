# home-manager links fonts in home.packages into ~/Library/Fonts
{ pkgs, ... }:
{
  home.packages = with pkgs.nerd-fonts; [
    hack
    jetbrains-mono
  ];
}
