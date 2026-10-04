# `go install` writes to GOBIN (~/go/bin), at the end of PATH via my.path,
# so tools installed there (go.nvim's included) never shadow the Nix ones.
# GOPATH stays $HOME for the module cache and sources.
{ config, pkgs, ... }:
let
  gobin = "${config.home.homeDirectory}/go/bin";
in
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
  my.env.GOBIN = gobin;
  my.path = [ gobin ];
  # Checked for commands nothing declares; files that go install on purpose
  # add their names
  my.knownBins."go/bin" = [ ];
}
