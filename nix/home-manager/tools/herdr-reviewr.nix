# herdr-reviewr: herdr plugin that shows an agent's diff in a pane beside it
# and sends line comments back. Also works as a plain CLI outside herdr.
# Its settings live in home/.config/herdr/plugins/config/persiyanov.reviewr/config.toml.
{ pkgs, ... }:
let
  herdr-reviewr = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "herdr-reviewr";
    version = "0.39.0";

    src = pkgs.fetchFromGitHub {
      owner = "persiyanov";
      repo = "herdr-reviewr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-QD+hqFt1zpzGiJELJwwyJy4s6ASbIdOYnsw2S1qIaHs=";
    };

    cargoHash = "sha256-0r3IaTblNPhquK0Swj/yEESYGOEOYTDlTLHHGmtE3h0=";

    # The tests drive git and herdr
    doCheck = false;

    # The plugin root is $out: the manifest runs $HERDR_PLUGIN_ROOT/bin/herdr-reviewr
    # and the scripts in herdr/
    postInstall = ''
      cp herdr-plugin.toml $out/
      cp -r herdr $out/
    '';
  });
in
{
  home.packages = [ herdr-reviewr ];

  # The CLI outside herdr, under the name the plugin goes by
  my.human.aliases.reviewr = "herdr-reviewr";

  my.herdrPlugins."persiyanov.reviewr" = herdr-reviewr;

  # The plugin's pane.sh links its binary into ~/.local/bin on every action
  # (a "stable launch path" for layouts), re-pointing it at the plugin root
  # herdr has now. It duplicates the one above, so it is harmless; once this
  # file is gone, the stray-bins warning names the leftover link to delete.
  my.knownBins.".local/bin" = [ "herdr-reviewr" ];
}
