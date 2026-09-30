# gomi: rm that moves files to the trash, for humans and AI agents alike.
# Agents take it for the rm they know: the flags are rm's, and a mistaken
# `rm -rf` can be restored with `gomi -b`. See my.ai in nix/home-manager/ai.nix.
{ lib, pkgs, ... }:
let
  # v1.6.5 lets files in $TMPDIR (/var/folders/.../T on macOS) be removed,
  # which mktemp cleanups rely on, and makes -f report files it could not
  # move instead of exiting 0. Drop this once nixpkgs has 1.6.5.
  gomi = pkgs.gomi.overrideAttrs (
    final: prev:
    lib.optionalAttrs (lib.versionOlder prev.version "1.6.5") {
      version = "1.6.5";
      src = prev.src.override {
        tag = "v${final.version}";
        hash = "sha256-SlPd4ahtJYwQpe4qtCuVPt/lJ1kFTlh9SX0ZVPjxURM=";
      };
    }
  );
in
{
  home.packages = [ gomi ];

  my.human.aliases.rm = "gomi";
  my.ai.aliases.rm = "gomi";
}
