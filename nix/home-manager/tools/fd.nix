{ pkgs, ... }:
{
  home.packages = [ pkgs.fd ];

  my.human.aliases.fd = "fd --hidden";
}
