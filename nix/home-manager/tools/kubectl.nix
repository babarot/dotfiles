{ pkgs, ... }:
{
  home.packages = [ pkgs.kubectl ];

  my.human.plugins.zsh-abbr.init = ''
    abbr --session --quiet k=kubectl
  '';
}
