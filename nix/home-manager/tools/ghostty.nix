# Settings live in ~/.config/ghostty (.config/ghostty in this repo)
{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty-bin ];
}
