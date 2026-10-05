# deadlink [dir...]: remove the broken symlinks in each directory ($HOME
# by default), asking before each one. The script lives in a gist (the
# deadlink input in flake.nix); `nix flake update deadlink` takes an edit
{ inputs, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "deadlink";
      text = builtins.readFile "${inputs.deadlink}/deadlink";
    })
  ];
}
