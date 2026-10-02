{ lib, pkgs, ... }:
let
  # Used inside bat-theme only; fzf on PATH is fzf.nix's
  fzf = lib.getExe pkgs.fzf;
in
{
  home.packages = [ pkgs.bat ];

  my.human.env = {
    BAT_PAGER = "less -RF";
    BAT_STYLE = "numbers,changes";
    BAT_THEME = "DarkNeon";
  };

  # Agents read bat's output, not scroll it
  my.ai.env.BAT_PAGER = "cat";

  my.human.init = ''
    bat-theme() {
      local file=$1
      if [[ -z $file ]]; then
        file=$(${fzf})
      fi
      bat --list-themes | ${fzf} --preview="bat --theme={} --color=always ''${file}"
    }
  '';
}
