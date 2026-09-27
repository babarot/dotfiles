{ pkgs, ... }:
{
  home.packages = [ pkgs.eza ];

  my.human.aliases = {
    l = "eza --group-directories-first -a -1 -F --git-ignore";
    lt = "eza --group-directories-first -T --git-ignore --level 10";
    lta = "eza --group-directories-first -a -T --git-ignore --level 10 --ignore-glob .git";
    la = "eza --group-directories-first -a --header --git";
    ll = "eza --group-directories-first -l --header --git";
    lla = "eza --group-directories-first -la --header --git";
    ls = "eza --group-directories-first";
  };
}
