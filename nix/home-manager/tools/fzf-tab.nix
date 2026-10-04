{ lib, pkgs, ... }:
{
  my.human.plugins.fzf-tab = {
    src = pkgs.zsh-fzf-tab;
    file = "share/fzf-tab/fzf-tab.plugin.zsh";
    # After compinit (in .zshrc, before human.zsh) and before plugins that
    # wrap widgets, as fzf-tab's README asks
    before = [ "fast-syntax-highlighting" ];
    init = ''
      zstyle ':fzf-tab:complete:vim:*' query-string input
      # fzf from the store, so it does not depend on fzf.nix putting fzf on PATH
      zstyle ':fzf-tab:*' fzf-command ${lib.getExe pkgs.fzf}
      zstyle ':fzf-tab:*' popup-min-size 50 8
      zstyle ':fzf-tab:*' fzf-min-height 8
      zstyle ':fzf-tab:*' fzf-pad 4
      # fzf-tab replaces zsh's completion menu
      zstyle ':completion:*' menu no
    '';
  };
}
