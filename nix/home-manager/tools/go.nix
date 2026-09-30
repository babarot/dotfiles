# GOPATH=$HOME, so `go install` puts binaries in ~/bin (on PATH in .zshenv)
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.go ];

  my.env.GOPATH = config.home.homeDirectory;
}
