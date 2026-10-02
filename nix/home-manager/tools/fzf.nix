{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.fzf ];

  my.human.env = {
    FZF_DEFAULT_COMMAND = "fd --type f";
    FZF_DEFAULT_OPTS = lib.concatStringsSep " " [
      "--height 75% --multi --layout=reverse --margin=0,1"
      "--bind ctrl-f:page-down,ctrl-b:page-up,ctrl-/:toggle-preview"
      "--bind pgdn:preview-page-down,pgup:preview-page-up"
      ''--marker="+" --pointer="▶" --prompt="❯ "''
      ''--no-separator --scrollbar="█"''
      "--color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479"
      "--color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692"
      "--color prompt:#87afff,pointer:#ff5189,marker:#f09479"
    ];
  };

  my.human.globalAliases.F = "$(fzf)";

  # Kill processes picked with fzf (tab selects several, enter kills them,
  # ctrl-r reloads); an argument is the initial query: `pskill astro`
  my.human.init = ''
    pskill() {
      ps -ef | fzf -m \
        --query="''${1:-}" \
        --bind 'ctrl-r:reload(ps -ef),enter:execute(kill {+2})+clear-selection+reload(ps -ef)' \
        --header 'TAB: select, ENTER: kill, CTRL-R: reload' \
        --header-lines=1 \
        --height=50
    }
  '';
}
