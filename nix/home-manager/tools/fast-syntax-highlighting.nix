{ pkgs, ... }:
{
  my.human.plugins.fast-syntax-highlighting = {
    src = pkgs.zsh-fast-syntax-highlighting;
    file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
    # It wraps only the widgets that exist when it loads, so it comes after
    # everything that defines them. ~/.zsh/20_bindkeys.zsh replaces
    # self-insert with url-quote-magic: loaded before it, nothing is
    # highlighted while typing. Plugins defining widgets say `before` it
    after = [ "zsh-local" ];
  };
}
