{ pkgs, ... }:
{
  home.packages = [ pkgs.bat ];

  my.human.env = {
    BAT_PAGER = "less -RF";
    BAT_STYLE = "numbers,changes";
    BAT_THEME = "DarkNeon";
  };

  my.human.init = ''
    bat-theme() {
      local file=$1
      if [[ -z $file ]]; then
        file=$(fzf)
      fi
      bat --list-themes | fzf --preview="bat --theme={} --color=always ''${file}"
    }
  '';
}
