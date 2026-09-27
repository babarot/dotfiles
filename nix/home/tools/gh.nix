{ inputs, pkgs, ... }:
let
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [ pkgs.gh ];

  # Install extensions by linking their binaries where gh looks for them,
  # instead of programs.gh, which would make gh's config.yml read-only.
  xdg.dataFile = {
    "gh/extensions/gh-md/gh-md".source = "${pkgs.gh-markdown-preview}/bin/gh-markdown-preview";
    "gh/extensions/gh-infra/gh-infra".source = "${babarot.gh-infra}/bin/gh-infra";
  };
}
