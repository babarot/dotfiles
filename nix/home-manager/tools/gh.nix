{
  config,
  inputs,
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
    inherit (config.my.forkPatches.gh-news) patches;
  };
in
{
  home.packages = [ pkgs.gh ];

  # Local changes, one patch per feature; each patch's message says what it
  # does. They are exported from a fork branch, not edited here
  # (docs/guides/maintenance.md). Check the branch with a throwaway Rust
  # toolchain:
  #   nix shell 'nixpkgs#cargo' 'nixpkgs#rustc' 'nixpkgs#clippy' 'nixpkgs#rustfmt' \
  #     -c sh -c 'cargo fmt --check && cargo clippy --all-targets && cargo test'
  my.forkPatches.gh-news = {
    inherit (gh-news) src;
    dir = ./gh-news;
  };

  # Install extensions by linking their binaries where gh looks for them,
  # instead of programs.gh, which would make gh's config.yml read-only.
  xdg.dataFile = {
    "gh/extensions/gh-dash/gh-dash".source = "${pkgs.gh-dash}/bin/gh-dash";
    "gh/extensions/gh-infra/gh-infra".source = "${babarot.gh-infra}/bin/gh-infra";
    "gh/extensions/gh-md/gh-md".source = "${pkgs.gh-markdown-preview}/bin/gh-markdown-preview";
    "gh/extensions/gh-news/gh-news".source = "${gh-news}/bin/gh-news";
  };
}
