# repo-cleanup: count my GitHub repositories by state and visibility, list
# the ones still exposed (public, not archived) with their open PRs, issues
# and alerts, and archive them or make them private, picked with fzf. The
# Deno script and its tests live in a gist (the repo-cleanup input in
# flake.nix); `nix flake update repo-cleanup` takes an edit. The tests run
# at build time, against fake gh and fzf, so an edit that breaks them does
# not build.
{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.runCommand "repo-cleanup"
      {
        nativeBuildInputs = [
          pkgs.deno
          pkgs.makeWrapper
        ];
      }
      ''
        export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
        deno test --allow-all --no-lock ${inputs.repo-cleanup}/repo-cleanup_test.ts

        # Prefixed, so the gh, gum and fzf pinned here win over any other
        makeWrapper ${lib.getExe pkgs.deno} $out/bin/repo-cleanup \
          --add-flags "run --no-lock --allow-run=gh,gum,fzf ${inputs.repo-cleanup}/repo-cleanup.ts" \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.gh
              pkgs.gum
              pkgs.fzf
            ]
          }
      ''
    )
  ];
}
