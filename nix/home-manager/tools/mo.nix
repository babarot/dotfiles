# mo: Markdown viewer in the browser (k1LoW/mo). nixpkgs' mo is a
# different tool (a mustache renderer), so it is built from the release tag
{ lib, pkgs, ... }:
let
  mo = pkgs.buildGoModule (finalAttrs: {
    pname = "mo";
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "k1LoW";
      repo = "mo";
      tag = "v${finalAttrs.version}";
      hash = "sha256-lEngCTFi9FkKMw8dHbf0+A15/SKHyadY8iA4ji+JMhs=";
    };
    vendorHash = "sha256-EMmDN42gl/OFxSsuTIImN0oUa/W9gv2OMYRVm5kArS0=";
    # Local changes, one patch per feature, applied in name order; each
    # patch's message says what it does. They are exported from a fork
    # branch, not edited here (docs/guides/maintenance.md)
    patches = lib.filter (lib.hasSuffix ".patch") (lib.filesystem.listFilesRecursive ./mo);

    # The frontend is built with pnpm and embedded into the binary
    pnpmRoot = "internal/frontend";
    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        patches
        ;
      pnpm = pkgs.pnpm_10;
      fetcherVersion = 4;
      # The lockfile is in the frontend directory, but the patches apply
      # from the top of the source
      postPatch = "cd ${finalAttrs.pnpmRoot}";
      hash = "sha256-jDE/I7DieGHO/P/tCmQFPL5A6Xt1VhFwvOZxTVK2ptM=";
    };
    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.pnpm_10
      pkgs.pnpmConfigHook
    ];
    # The Go module fetch needs none of the frontend
    overrideModAttrs = old: {
      nativeBuildInputs = lib.remove pkgs.pnpmConfigHook old.nativeBuildInputs;
      preBuild = "";
    };
    # Not `pnpm run build`: package.json pins a Node version for its
    # scripts (executionEnv), which pnpm would download
    preBuild = ''
      pushd internal/frontend
      node_modules/.bin/tsc
      node_modules/.bin/vite build
      popd
    '';

    ldflags = [
      "-s"
      "-w"
    ];
    env.CGO_ENABLED = 0;
  });
in
{
  home.packages = [ mo ];
}
