# terraform is BUSL-1.1 (unfree in nixpkgs)
{ pkgs, ... }:
{
  home.packages = [ pkgs.terraform ];

  my.human.plugins.zsh-abbr.init = ''
    abbr --session --quiet tf=terraform
  '';
}
