# difftastic: syntax-aware diff. `git dft` runs git diff through it; plain
# `git diff` stays line-based
{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.difftastic ];

  my.gitConfig.alias.dft = "-c diff.external='${lib.getExe pkgs.difftastic} --syntax-highlight=off' diff";
}
