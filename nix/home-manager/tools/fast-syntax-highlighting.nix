{ pkgs, ... }:
{
  my.human.plugins.fast-syntax-highlighting = {
    src = pkgs.zsh-fast-syntax-highlighting;
    file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
    order = 500;
  };
}
