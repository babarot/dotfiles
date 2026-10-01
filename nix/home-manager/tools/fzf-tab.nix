{ pkgs, ... }:
{
  home.packages = [ pkgs.fzf ];

  my.human.plugins.fzf-tab = {
    src = pkgs.zsh-fzf-tab;
    file = "share/fzf-tab/fzf-tab.plugin.zsh";
    order = 600;
    init = ''
      zstyle ':fzf-tab:complete:vim:*' query-string input
      zstyle ':fzf-tab:*' fzf-command
      zstyle ':fzf-tab:*' popup-min-size 50 8
      zstyle ':fzf-tab:*' fzf-min-height 8
      zstyle ':fzf-tab:*' fzf-pad 4
      # fzf-tab replaces zsh's completion menu
      zstyle ':completion:*' menu no
    '';
  };
}
