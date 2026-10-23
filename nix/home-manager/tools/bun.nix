# bun: the JavaScript runtime my CLIs and helper scripts are written for.
{ lib, pkgs, ... }:
let
  # v1.4.4 updates the root certificates Bun embeds to NSS 3.131.1, which
  # distrusts the roots behind the leaked eMudhra intermediates
  # (https://emudhra.we-have-a-problem.com/). Bun reads its own copy, not the
  # Nix CA bundle, so the blacklist in darwin.nix does not cover it. Drop this
  # once nixpkgs has 1.4.4.
  bun = pkgs.bun.overrideAttrs (
    final: prev:
    lib.optionalAttrs (lib.versionOlder prev.version "1.4.4") {
      version = "1.4.4";
      passthru = prev.passthru // {
        sources = prev.passthru.sources // {
          aarch64-darwin = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-darwin-aarch64.zip";
            hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
          };
        };
      };
    }
  );
in
{
  home.packages = [ bun ];
}
