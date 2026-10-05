# gist-ctl: count my gists by visibility, list them with their files, stars,
# comments and forks, and delete the ones no longer needed, picked with fzf
# with each gist previewed through bat. The Deno script and its tests live
# in a gist (the gist-ctl input in flake.nix); `nix flake update gist-ctl`
# takes an edit. The tests run at build time, against fake gh, fzf and bat,
# so an edit that breaks them does not build.
{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.runCommand "gist-ctl"
      {
        nativeBuildInputs = [
          pkgs.deno
          pkgs.makeWrapper
        ];
      }
      ''
        export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
        deno test --allow-all --no-lock ${inputs.gist-ctl}/gist-ctl_test.ts

        # Prefixed, so the gh, gum, fzf and bat pinned here win over any
        # other; fzf runs the preview, and with it gh and bat, on this PATH
        makeWrapper ${lib.getExe pkgs.deno} $out/bin/gist-ctl \
          --add-flags "run --no-lock --allow-run=gh,gum,fzf ${inputs.gist-ctl}/gist-ctl.ts" \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.gh
              pkgs.gum
              pkgs.fzf
              pkgs.bat
            ]
          }
      ''
    )
  ];
}
