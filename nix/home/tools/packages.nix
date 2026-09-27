# Tools with no shell settings of their own
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    conftest
    difftastic
    ghq
    git-open
    hcl2json
    jsonfmt
    mmv-go # itchyny/mmv; `mmv` in nixpkgs is a different tool
    ripgrep
  ];
}
