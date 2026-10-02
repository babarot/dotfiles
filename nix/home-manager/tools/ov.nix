# ov: pager for `git log` / `git show`
{ lib, pkgs, ... }:
let
  ov = lib.getExe pkgs.ov;
in
{
  home.packages = [ pkgs.ov ];

  my.gitConfig.pager = {
    log = "${ov} -F --section-delimiter '^commit' --section-header-num 3";
    show = "${ov} -F --header 3";
  };
}
