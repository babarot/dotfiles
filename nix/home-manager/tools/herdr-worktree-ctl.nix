# herdr-worktree-ctl: list herdr's worktrees with whether a space is open on
# each, its uncommitted changes, commits not in the default branch, the
# processes working in it and its last activity, and remove the ones picked
# with fzf. Closing a worktree space in herdr leaves the checkout behind.
# The Deno script and its tests sit beside this file; the tests run at build
# time, against real git repositories and a fake herdr, lsof, fzf and trash,
# so an edit that breaks them does not build.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.runCommand "herdr-worktree-ctl"
      {
        nativeBuildInputs = [
          pkgs.deno
          pkgs.git
          pkgs.makeWrapper
        ];
      }
      ''
        export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
        cp ${./herdr-worktree-ctl.ts} herdr-worktree-ctl.ts
        cp ${./herdr-worktree-ctl_test.ts} herdr-worktree-ctl_test.ts
        deno test --allow-all --no-lock herdr-worktree-ctl_test.ts

        # Prefixed, so the patched herdr and the fzf pinned here win; fzf
        # runs the preview on this PATH. git, lsof and trash are macOS's own
        install -Dm644 herdr-worktree-ctl.ts $out/share/herdr-worktree-ctl/herdr-worktree-ctl.ts
        makeWrapper ${lib.getExe pkgs.deno} $out/bin/herdr-worktree-ctl \
          --add-flags "run --no-lock --allow-run=git,herdr,lsof,fzf,trash --allow-read --allow-write --allow-env $out/share/herdr-worktree-ctl/herdr-worktree-ctl.ts" \
          --prefix PATH : ${
            lib.makeBinPath [
              config.my.herdr
              pkgs.fzf
            ]
          }
      ''
    )
  ];
}
