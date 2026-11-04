# gh-mini: a small, local GitHub for a directory of Markdown (`gh mini`).
# Published to babarot/nur-packages by GoReleaser.
{ inputs, pkgs, ... }:
let
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Run as gh-mini, and as gh mini by linking it where gh looks for extensions
  home.packages = [ babarot.gh-mini ];
  xdg.dataFile."gh/extensions/gh-mini/gh-mini".source = "${babarot.gh-mini}/bin/gh-mini";
}
