# FinderSearch: a Finder-like file browser with fuzzy filename search by
# fsearch, which the app bundles. Not in nixpkgs or Homebrew, and it does
# not self-update, so it is repackaged from the release DMG here and comes
# into ~/Applications/Home Manager Apps like the apps in apps.nix.
#
# Only on this Mac: the app is ad-hoc signed and not notarized. Searching
# protected folders needs Full Disk Access, which is granted again after
# each version change, since an ad-hoc signature changes with the binary.
{ pkgs, ... }:
let
  findersearch = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "findersearch";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "https://github.com/zeusinsight/FinderSearch/releases/download/v${finalAttrs.version}/FinderSearch-${finalAttrs.version}-AppleSilicon.dmg";
      hash = "sha256-syqadP4VBg0o0F3RK9S/8Gr8/JYP0Bz8jtzUR8xfOyU=";
    };

    # undmg cannot read this DMG. 7zz extracts extended attributes as
    # files named <file>:com.apple.*, which break the sealed resources.
    nativeBuildInputs = [ pkgs._7zz ];
    unpackPhase = ''
      7zz x -snld "$src" FinderSearch.app
      find FinderSearch.app -name '*:com.apple.*' -delete
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R FinderSearch.app "$out/Applications/"
    '';

    # Fixup would rewrite the binaries and break the ad-hoc signature.
    dontFixup = true;

    meta = {
      homepage = "https://github.com/zeusinsight/FinderSearch";
      license = pkgs.lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    };
  });
in
{
  home.packages = [ findersearch ];
}
