{ pkgs, ... }:
{
  my.human.plugins.history-search-multi-word = {
    src = pkgs.zsh-history-search-multi-word;
    file = "share/zsh/zsh-history-search-multi-word/history-search-multi-word.plugin.zsh";
    # Defines its widgets for fast-syntax-highlighting to wrap, so the line
    # is highlighted after ^R picks an entry. Its ^R goes into the main
    # keymap, already viins when it loads (zsh starts in viins because
    # EDITOR=nvim), so `bindkey -v` in ~/.zsh does not need to come first
    before = [ "fast-syntax-highlighting" ];
  };
}
