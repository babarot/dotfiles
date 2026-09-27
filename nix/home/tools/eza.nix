{ pkgs, ... }:
{
  home.packages = [ pkgs.eza ];

  # Colors for BSD ls and eza; LS_COLORS also colors zsh completion
  # (~/.zsh/70_zstyles.zsh)
  my.human.env = {
    LSCOLORS = "exfxcxdxbxegedabagacad";
    LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30";
  };

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
