# gh-fleet: list one GitHub owner's clones with how far each is behind, what
# is not pushed and its worktrees; fetch, pull and remove merged worktrees
# from the list. Run as gh-fleet, and as gh fleet.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO: take the release binaries once gh-fleet releases with goreleaser;
  # until then it is built from a commit of main
  gh-fleet = pkgs.buildGoModule {
    pname = "gh-fleet";
    version = "0-unstable-2026-10-10";
    src = pkgs.fetchFromGitHub {
      owner = "babarot";
      repo = "gh-fleet";
      rev = "ebae3d535e3ed297636659781c21102cf9e55d08";
      hash = "sha256-IeERHLXlcOi20Z4yA907X5uh7VYxzyTuTlMf7pXnZuo=";
    };
    vendorHash = "sha256-l4V6UmJwU99vXJpTIzjaFpCUG8KRZL25PJuQgYwW6fk=";
    # Only the command; its packages' tests run in gh-fleet's own checkout
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    # c clones with gh; by store path, so it does not depend on gh.nix.
    # Suffixed, so a gh on PATH wins and gh fleet clones with the user's gh
    postInstall = ''
      wrapProgram $out/bin/gh-fleet --suffix PATH : ${lib.makeBinPath [ pkgs.gh ]}
    '';
  };

  toml = pkgs.formats.toml { };
in
{
  # config.toml as Nix, so other tools' files can add their commands to it
  # ([[actions]], [cleanup] worktree_remove) by store path. The file is
  # generated, so gh fleet does not write its commented template; every
  # setting is in its README.
  options.my.ghFleet = lib.mkOption {
    inherit (toml) type;
    default = { };
    description = "gh fleet's config.toml.";
  };

  config = {
    home.packages = [ gh-fleet ];
    xdg.dataFile."gh/extensions/gh-fleet/gh-fleet".source = "${gh-fleet}/bin/gh-fleet";
    xdg.configFile."gh-fleet/config.toml".source =
      toml.generate "gh-fleet-config.toml" config.my.ghFleet;
  };
}
