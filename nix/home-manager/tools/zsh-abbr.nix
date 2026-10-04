# License is CC BY-NC-SA 4.0 (unfree in nixpkgs)
{ pkgs, ... }:
{
  my.human.plugins.zsh-abbr = {
    src = pkgs.zsh-abbr;
    file = "share/zsh/zsh-abbr/zsh-abbr.zsh";
    # After ~/.zsh/20_bindkeys.zsh: abbr binds space in the keymap
    # `bindkey -v` selects. Before fast-syntax-highlighting, which wraps
    # only the widgets that exist when it loads: abbr redefines space and
    # accept-line, which would otherwise not update the highlighting
    after = [ "zsh-local" ];
    before = [ "fast-syntax-highlighting" ];
    # Abbreviations are declared here with --session, so zsh-abbr never
    # saves them to ~/.config/zsh-abbr/user-abbreviations, where one removed
    # from Nix would live on. Use --session in other tools' files too.
    init = ''
      abbr --session --quiet cf=conftest
      abbr --session --quiet "d c"="docker compose"
    '';
  };
}
