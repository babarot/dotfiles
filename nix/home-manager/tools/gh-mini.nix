{ pkgs, ... }:
let
  # Not in nixpkgs or nur-packages; built from the release tag.
  # Go 1.27 because go.mod requires go >= 1.26.9 and nixpkgs' go is 1.26.8
  gh-mini = pkgs.buildGo127Module rec {
    pname = "gh-mini";
    version = "0.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "babarot";
      repo = "gh-mini";
      rev = "v${version}";
      hash = "sha256-aLJlNw5K7jjjsNDRs0219VJI+/HhFatqd7LrSe7n5/A=";
    };
    vendorHash = "sha256-WDN4xl/oJaPrE1wyz3aer6nBqeipnuQBAESIRu2gBec=";
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
