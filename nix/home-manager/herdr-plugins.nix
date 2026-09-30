# my.herdrPlugins: herdr plugins built by Nix, registered with
# `herdr plugin link` on every switch. link never builds or writes into the
# plugin dir (config and state live under ~/.config/herdr/plugins/config and
# ~/.local/state/herdr/plugins), so a read-only store path works, and linking
# the same id again replaces the old store path in ~/.config/herdr/plugins.json.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  herdr = "${pkgs.herdr}/bin/herdr";
  jq = "${pkgs.jq}/bin/jq";
  plugins = config.my.herdrPlugins;
in
{
  options.my.herdrPlugins = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = { };
    description = "herdr plugin dirs (containing herdr-plugin.toml) by plugin id.";
  };

  config.home.activation.herdrPlugins = lib.mkIf (plugins != { }) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStrings (
        lib.mapAttrsToList (id: pkg: ''
          run ${herdr} plugin link ${pkg} >/dev/null \
            || warnEcho "herdr: linking the plugin ${id} failed"
        '') plugins
      )}
      # Unregister store-linked plugins that were dropped from my.herdrPlugins;
      # plugins installed or linked by hand are left alone.
      registry="$HOME/.config/herdr/plugins.json"
      if [[ -f $registry ]]; then
        while IFS= read -r id; do
          case " ${lib.concatStringsSep " " (lib.attrNames plugins)} " in
            *" $id "*) ;;
            *) run ${herdr} plugin unlink "$id" >/dev/null \
                 || warnEcho "herdr: unlinking the plugin $id failed" ;;
          esac
        done < <(${jq} -r '.[] | select(.plugin_root | startswith("/nix/store/")) | .plugin_id' "$registry")
      fi
    ''
  );
}
