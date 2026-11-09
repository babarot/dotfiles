# leaf: Markdown viewer in the terminal (RivoLink/leaf), a TUI with a file
# picker, live reload and Mermaid diagrams. Kept beside the other Markdown
# viewers: glow (packages.nix) for plain rendering in the terminal, and mo
# (mo.nix) in the browser. nixpkgs' leaf was a different tool (a system info
# fetcher, since removed), so it is built from the release tag.
#
# `leaf --update` replaces its own binary from GitHub releases; it cannot
# write to the store, so update it here instead.
{ pkgs, ... }:
let
  leaf = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "leaf";
    version = "1.29.2";

    src = pkgs.fetchFromGitHub {
      owner = "RivoLink";
      repo = "leaf";
      tag = finalAttrs.version;
      hash = "sha256-Qj5QfuoXmh+YH3+MrPKmTKjDPAYIOrewJf3LastPJQo=";
    };

    cargoHash = "sha256-eAPW1VhBEyrQBKeFniKD1RxCdy6p6teAVwnNRBWJ+BA=";

    # Fail in the build sandbox, not in leaf: one reads Cargo.toml's previous
    # version from git history, which the source tarball lacks; the other
    # walks a large tree under a time limit and hits the limit first
    checkFlags = [
      "--skip=tests::render_preview::preview_mode_only_before_shows_content"
      "--skip=tests::file_fuzzy::fuzzy_file_picker_reports_directory_limit_truncation"
    ];
  });
in
{
  home.packages = [ leaf ];
}
