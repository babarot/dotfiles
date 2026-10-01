# GOPATH=$HOME, so `go install` puts binaries in ~/bin (on PATH in .zshenv)
{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.go
    # goimports only: the rest of gotools includes generic names (bundle,
    # stress, present, ...) that would shadow other commands on PATH
    (pkgs.runCommand "goimports" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.gotools}/bin/goimports $out/bin/goimports
    '')
  ];

  my.env.GOPATH = config.home.homeDirectory;
}
