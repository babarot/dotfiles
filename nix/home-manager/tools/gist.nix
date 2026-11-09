# babarot/gist: browse, edit and create my gists, as a TUI and a CLI.
# Published to babarot/nur-packages by GoReleaser. Its config is written by
# its first launch to ~/.config/gist/config.toml and is not tracked here.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};

  # gist reads the token gh keeps in the keychain by running `gh auth token`.
  # gh goes on gist's own PATH, so it works without gh.nix. Appended, so a gh
  # already on PATH still wins.
  gist = pkgs.symlinkJoin {
    name = "gist-with-gh";
    paths = [ babarot.gist ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/gist --suffix PATH : ${lib.makeBinPath [ pkgs.gh ]}
    '';
  };
in
{
  home.packages = [ gist ];

  # A release build checks GitHub for a newer release once a day; the version
  # is pinned in flake.lock, so the notice could only point at an update that
  # bypasses it
  my.env.GIST_NO_UPDATE_CHECK = "1";
}
