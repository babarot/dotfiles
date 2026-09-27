{ pkgs, ... }:
{
  my.human.plugins.history-search-multi-word = {
    src = pkgs.zsh-history-search-multi-word;
    file = "share/zsh/zsh-history-search-multi-word/history-search-multi-word.plugin.zsh";
    order = 200;
  };
}
