{ pkgs, ... }:
let
  # Not in nixpkgs or nur-packages; built from the release tag
  gh-mini = pkgs.buildGoModule rec {
    pname = "gh-mini";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "babarot";
      repo = "gh-mini";
      rev = "v${version}";
      hash = "sha256-R6ESJP/XPJ0CRWlW6kc76WX+by4NvJupoeAy47oCIcU=";
    };
    vendorHash = "sha256-hvYLa50fpM2RzoBaHHZnXxq96k08NV8fnTrcI2lr4B8=";
    # Only the command; internal/lexers tests read chroma's lexer files, which
    # the vendored modules do not carry
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];
  };
in
{
  # Run as gh-mini, and as gh mini by linking it where gh looks for extensions
  home.packages = [ gh-mini ];
  xdg.dataFile."gh/extensions/gh-mini/gh-mini".source = "${gh-mini}/bin/gh-mini";
}
