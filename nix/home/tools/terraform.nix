# terraform is BUSL-1.1 (unfree in nixpkgs); allowed in nix/darwin.nix
{ pkgs, ... }:
{
  home.packages = [
    pkgs.terraform
    pkgs.terraform-ls
  ];

  my.human.plugins.zsh-abbr.init = ''
    abbr --quiet tf=terraform
  '';
}
