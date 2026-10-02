{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # The filter and its preview, by store path: enhancd does not depend on
  # fzf.nix or eza.nix putting them on PATH
  fzf = lib.getExe pkgs.fzf;
  eza = lib.getExe pkgs.eza;
in
{
  my.human.plugins.enhancd = {
    src = inputs.enhancd;
    file = "init.sh";
    order = 400;
  };

  my.human.env.ENHANCD_FILTER = lib.concatStringsSep " " [
    "${fzf} --preview '${eza} -al --tree --level 1 --group-directories-first --git-ignore"
    "--header --git --no-user --no-time --no-filesize --no-permissions {}'"
    "--preview-window right,50% --height 35% --reverse --ansi"
  ];
}
