# gh-desk: review and merge the pull requests that reach you (`gh desk`).
# Published to babarot/nur-packages by gh-desk's release workflow. Its config
# is hand-written in home/.config/gh-desk/config.toml.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};

  # The config gives Claude claude-recall's MCP server by the name `recall`,
  # since a hand-written config cannot hold store paths. recall goes on
  # gh-desk's own PATH, so it works without claude-recall.nix. Appended, so a
  # recall already on PATH still wins. claude itself is run by name: it is
  # the official installer's (claude-code.nix), not a Nix package.
  gh-desk = pkgs.symlinkJoin {
    name = "gh-desk-with-recall";
    paths = [ babarot.gh-desk ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/gh-desk --suffix PATH : ${lib.makeBinPath [ babarot.claude-recall ]}
    '';
  };
in
{
  # Run as gh-desk, and as gh desk by linking it where gh looks for extensions
  home.packages = [ gh-desk ];
  xdg.dataFile."gh/extensions/gh-desk/gh-desk".source = "${gh-desk}/bin/gh-desk";
}
