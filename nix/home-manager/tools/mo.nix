# mo: Markdown viewer in the browser (k1LoW/mo). nixpkgs' mo is a
# different tool (a mustache renderer), so it is built from the release tag
{
  config,
  lib,
  pkgs,
  ...
}:
let
  mo = pkgs.buildGoModule (finalAttrs: {
    pname = "mo";
    version = "1.6.9";
    src = pkgs.fetchFromGitHub {
      owner = "k1LoW";
      repo = "mo";
      tag = "v${finalAttrs.version}";
      hash = "sha256-BXGMjybhKZzw+yae478EP2j3cKw/ZbJMrW342W8ZCmY=";
    };
    vendorHash = "sha256-v1EfsHryyLfv9/ZzVazSMFySio62upqsB33eLV6LZZU=";
    inherit (config.my.forkPatches.mo) patches;

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
      hash = "sha256-FjVAGkxXmykGMEdB9FWEEWg6hnxUXLjARLEI23s2EZ4=";
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

  # Local changes, one patch per feature; each patch's message says what it
  # does. They are exported from a fork branch, not edited here
  # (docs/guides/maintenance.md). The Go tests run in the build; check the
  # frontend on the branch with the pnpm its package.json names, and commit
  # the lockfile `pnpm install` rewrites when a patch changes dependencies:
  #   cd internal/frontend
  #   nix shell 'nixpkgs#pnpm_10' -c sh -c 'pnpm install --frozen-lockfile && pnpm run fmt:check && pnpm exec tsc --noEmit && pnpm run lint && pnpm test'
  my.forkPatches.mo = {
    inherit (mo) src;
    dir = ./mo;
  };
}
