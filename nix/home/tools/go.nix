# GOPATH=$HOME is set in .zshenv, so `go install` puts binaries in ~/bin
{ pkgs, ... }:
{
  home.packages = [ pkgs.go ];
}
