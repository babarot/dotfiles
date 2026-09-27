{ pkgs, ... }:
{
  home.packages = [ pkgs.gomi ];

  my.human.aliases.rm = "gomi";
}
