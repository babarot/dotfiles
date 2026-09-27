{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.fzf ];

  my.human.plugins.enhancd = {
    src = inputs.enhancd;
    file = "init.sh";
  };

  my.human.env.ENHANCD_FILTER = lib.concatStringsSep " " [
    "fzf --preview 'eza -al --tree --level 1 --group-directories-first --git-ignore"
    "--header --git --no-user --no-time --no-filesize --no-permissions {}'"
    "--preview-window right,50% --height 35% --reverse --ansi"
  ];
}
