# herdr-space-switch: pick one of herdr's spaces with fzf, the spaces on a
# repository's worktrees shown under it as in the sidebar, and switch to it;
# --git adds each checkout's git status and branch. The Deno script and its
# tests live in a gist (the herdr-space-switch input in flake.nix);
# `nix flake update herdr-space-switch` takes an edit. The tests run at build
# time, against real git repositories and a fake herdr and fzf, so an edit
# that breaks them does not build.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  herdr-space-switch =
    pkgs.runCommand "herdr-space-switch"
      {
        nativeBuildInputs = [
          pkgs.deno
          pkgs.git
          pkgs.makeWrapper
        ];
      }
      ''
        # The sandbox has no writable HOME, and deno caches under it
        export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
        deno test --allow-all --no-lock ${inputs.herdr-space-switch}/herdr-space-switch_test.ts

        # Prefixed, so this herdr and the fzf pinned here win; fzf runs the
        # preview and the reload on this PATH. git is macOS's own
        makeWrapper ${lib.getExe pkgs.deno} $out/bin/herdr-space-switch \
          --add-flags "run --no-lock --allow-run=herdr,fzf,git ${inputs.herdr-space-switch}/herdr-space-switch.ts" \
          --prefix PATH : ${
            lib.makeBinPath [
              config.my.herdr
              pkgs.fzf
            ]
          }
      '';
in
{
  home.packages = [ herdr-space-switch ];
}
