{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};

  # Not in nixpkgs and ships no flake; built from the release tag
  gh-news = pkgs.rustPlatform.buildRustPackage rec {
    pname = "gh-news";
    version = "0.18.0";
    src = pkgs.fetchFromGitHub {
      owner = "chmouel";
      repo = "gh-news";
      rev = "v${version}";
      hash = "sha256-FzOcusIiwo2FNxfeXjj1rY13jXZq9j3snI2NYmUQxaI=";
    };
    cargoHash = "sha256-rCIpKXfwin0p1zT+N3ZfPdNhzPIa2112rEJs7pZc4XE=";
    # Local changes, one patch per feature, applied in name order; each
    # patch's message says what it does. They are exported from a fork
    # branch, not edited here (docs/guides/maintenance.md)
    patches = lib.filter (lib.hasSuffix ".patch") (lib.filesystem.listFilesRecursive ./gh-news);
  };
in
{
  home.packages = [ pkgs.gh ];

  # Install extensions by linking their binaries where gh looks for them,
  # instead of programs.gh, which would make gh's config.yml read-only.
  xdg.dataFile = {
    "gh/extensions/gh-dash/gh-dash".source = "${pkgs.gh-dash}/bin/gh-dash";
    "gh/extensions/gh-infra/gh-infra".source = "${babarot.gh-infra}/bin/gh-infra";
    "gh/extensions/gh-md/gh-md".source = "${pkgs.gh-markdown-preview}/bin/gh-markdown-preview";
    "gh/extensions/gh-news/gh-news".source = "${gh-news}/bin/gh-news";
  };
}
