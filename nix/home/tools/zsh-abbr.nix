# License is CC BY-NC-SA 4.0 (unfree in nixpkgs); allowed in nix/darwin.nix
{ pkgs, ... }:
{
  my.human.plugins.zsh-abbr = {
    src = pkgs.zsh-abbr;
    file = "share/zsh/zsh-abbr/zsh-abbr.zsh";
    # After ~/.zsh/20_bindkeys.zsh: abbr binds space in the keymap
    # `bindkey -v` selects
    order = 6000;
    init = ''
      abbr --quiet tf=terraform
      abbr --quiet cf=conftest
      abbr --quiet "d c"="docker compose"
    '';
  };
}
