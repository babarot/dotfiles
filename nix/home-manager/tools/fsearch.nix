# fsearch: whole-disk file search for macOS (fuzzy names, indexed content
# grep) backed by a daemon it starts on first use. Not the GTK app nixpkgs
# calls fsearch.
#
# The daemon is spawned from the store path, so it needs no `fsearch install`
# (which copies the binary to ~/.local/bin). Its index lives in
# ~/Library/Application Support/FSearch.
{ pkgs, ... }:
let
  fsearch = pkgs.rustPlatform.buildRustPackage {
    pname = "fsearch";
    # No release tags yet; pinned to a commit on main
    version = "0.1.0-unstable-2026-10-08";

    src = pkgs.fetchFromGitHub {
      owner = "noahdunnagan";
      repo = "fsearch";
      rev = "af9476d39ec98108552670adf6badbbd77331b0a";
      hash = "sha256-tYRW5gkKifJXxtWBtPDkyxbF+Cyfw4AQ4aBc2CRYFtM=";
    };

    cargoHash = "sha256-tKUzMdS3mul/BhdFldS7k/AHlf6Klo5NNaeM6+zErzQ=";
  };
in
{
  home.packages = [ fsearch ];
}
