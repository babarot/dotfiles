# diffnav: a git diff pager with a file tree (`git diff | diffnav`).
{ pkgs, lib, ... }:
let
  # diffnav renders each file by running `delta` by name. delta goes on
  # diffnav's own PATH, not the user's, so it works without gh.nix (which
  # puts delta on PATH for gh-dash). Appended, so a delta already on PATH
  # still wins.
  diffnav = pkgs.symlinkJoin {
    name = "diffnav-with-delta";
    paths = [ pkgs.diffnav ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/diffnav --suffix PATH : ${lib.makeBinPath [ pkgs.delta ]}
    '';
  };
in
{
  home.packages = [ diffnav ];
}
