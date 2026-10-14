# herdr-remote: watch, approve and answer herdr's agents from a phone.
# https://github.com/dcolinmorgan/herdr-remote
#
#   phone ── herdr.<domain> (Worker, static web/) ─┐
#        └── relay.<domain> ── Cloudflare Tunnel ──┴─ relay on 127.0.0.1:8375 ── herdr
#
# Both hostnames sit behind one Cloudflare Access app, set up in the
# dashboard; the relay also wants its token. A host file turns it on
# (nix/hosts/pro23/herdr-remote.nix). Not from here, by design:
#
#   ~/.config/herdr-remote/secrets.env  HERDR_RELAY_TOKEN, mode 0600 (git-ignored)
#   ~/.config/herdr-remote/tunnel.env   TUNNEL_ID of the named tunnel
#   ~/.cloudflared/<TUNNEL_ID>.json     the tunnel's credentials
#
# The relay skips its Origin check whenever a token is set, so
# HERDR_TRUSTED_ORIGINS alone does not keep other sites out; a WAF rule on
# the relay's hostname does. upstream's install-service.sh is not used: it
# writes the plists by hand and runs the relay with `uv run`, which fetches
# its dependencies from PyPI at start. herdr-push is not used either: it
# sends no token, and on the relay's own Mac the bundled plugin below does
# its job over UDP.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.herdrRemote;
  home = config.home.homeDirectory;
  configDir = "${config.xdg.configHome}/herdr-remote";
  logDir = "${home}/Library/Logs/herdr-remote";
  port = 8375;

  src = pkgs.fetchFromGitHub {
    owner = "dcolinmorgan";
    repo = "herdr-remote";
    rev = "692342486e24b216df4bd0b240eca74075a3593a";
    hash = "sha256-9Wt3/nkuWSe4N9HR/BLdfwpbuWyHRoXRjNO3KoR0viI=";
  };

  # The relay's PEP 723 dependencies, from nixpkgs instead of uv
  python = pkgs.python3.withPackages (ps: [
    ps.websockets
    ps.zeroconf
    ps.pywebpush
    ps.py-vapid
  ]);

  relay = pkgs.writeShellApplication {
    name = "herdr-remote-relay";
    text = ''
      secrets=${lib.escapeShellArg "${configDir}/secrets.env"}
      # The token is what stands between the tunnel and the terminals, so
      # refuse to start without it rather than run open
      if [[ ! -r $secrets || $(/usr/bin/stat -f %Lp "$secrets") != 600 ]]; then
        echo "herdr-remote: $secrets must exist with mode 0600" >&2
        exit 1
      fi
      set -a
      # shellcheck disable=SC1090
      . "$secrets"
      set +a
      if [[ ''${#HERDR_RELAY_TOKEN} -lt 32 ]]; then
        echo "herdr-remote: HERDR_RELAY_TOKEN in $secrets is missing or short" >&2
        exit 1
      fi
      exec ${lib.getExe python} ${src}/relay/herdr_relay.py
    '';
  };

  # The bundled plugin pushes agent status changes to the relay over UDP
  # (127.0.0.1:8376) as they happen, instead of waiting for its 2s poll
  plugin = pkgs.runCommand "herdr-remote-plugin" { } ''
    mkdir $out
    cp ${src}/relay/on_event.py $out/
    substitute ${src}/relay/herdr-plugin.toml $out/herdr-plugin.toml \
      --replace-fail '["uv", "run", "--script", "on_event.py"]' '["${lib.getExe pkgs.python3}", "on_event.py"]'
  '';

  tunnelConfig = (pkgs.formats.yaml { }).generate "herdr-remote-tunnel.yml" {
    ingress = [
      {
        hostname = cfg.relayHost;
        service = "http://127.0.0.1:${toString port}";
      }
      { service = "http_status:404"; }
    ];
  };

  tunnel = pkgs.writeShellApplication {
    name = "herdr-remote-tunnel";
    text = ''
      env_file=${lib.escapeShellArg "${configDir}/tunnel.env"}
      # shellcheck disable=SC1090
      . "$env_file"
      if [[ ! ''${TUNNEL_ID:-} =~ ^[0-9a-f-]{36}$ ]]; then
        echo "herdr-remote: TUNNEL_ID in $env_file is missing or not a UUID" >&2
        exit 1
      fi
      exec ${lib.getExe pkgs.cloudflared} tunnel --no-autoupdate \
        --config ${tunnelConfig} \
        --credentials-file "$HOME/.cloudflared/$TUNNEL_ID.json" \
        run "$TUNNEL_ID"
    '';
  };

  # web/ as a Worker with static assets. workers.dev and preview URLs are
  # off, so the app is reachable only on webHost, behind Access. The CSP is
  # the one the relay sends with the app, with connect-src narrowed to it.
  web = pkgs.runCommand "herdr-remote-web" { } ''
    cp -r ${src}/web $out
    chmod u+w $out
    cat > $out/_headers <<'EOF'
    /*
      Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self' wss://${cfg.relayHost} https://${cfg.relayHost}; object-src 'none'; base-uri 'none'; frame-ancestors 'none'
      Referrer-Policy: no-referrer
      X-Content-Type-Options: nosniff
    EOF
  '';
  wranglerConfig = pkgs.writeText "wrangler.json" (
    builtins.toJSON {
      name = "herdr-remote";
      compatibility_date = "2026-10-01";
      assets.directory = "./web";
      workers_dev = false;
      preview_urls = false;
      routes = [
        {
          pattern = cfg.webHost;
          custom_domain = true;
        }
      ];
    }
  );
  # Run by hand after `wrangler login`; wrangler writes into the folder it
  # runs in, so it runs in a copy, not in the store
  deployWeb = pkgs.writeShellApplication {
    name = "herdr-remote-deploy-web";
    runtimeInputs = [ pkgs.wrangler ];
    text = ''
      dir=$(mktemp -d)
      trap 'rm -rf "$dir"' EXIT
      cp -r ${web} "$dir/web"
      cp ${wranglerConfig} "$dir/wrangler.json"
      cd "$dir"
      WRANGLER_SEND_METRICS=false wrangler deploy "$@"
    '';
  };
in
{
  options.my.herdrRemote = {
    enable = lib.mkEnableOption "the herdr-remote relay and its herdr plugin";
    tunnel = lib.mkEnableOption "the Cloudflare Tunnel to the relay (turn on only once Access guards relayHost)";
    relayHost = lib.mkOption {
      type = lib.types.str;
      description = "Hostname the tunnel serves the relay on.";
    };
    webHost = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of the web app (a Worker custom domain).";
    };
  };

  config = lib.mkIf cfg.enable {
    my.herdrPlugins."herdr-remote.relay" = plugin;

    home.packages = [ deployWeb ];

    launchd.agents.herdr-remote-relay = {
      enable = true;
      config = {
        ProgramArguments = [ (lib.getExe relay) ];
        EnvironmentVariables = {
          HERDR_RELAY_HOST = "127.0.0.1";
          HERDR_RELAY_PORT = toString port;
          HERDR_TRUSTED_ORIGINS = "https://${cfg.webHost}";
          HERDR_BIN = lib.getExe config.my.herdr;
          HERDR_LOG_DIR = logDir;
        };
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 5;
        StandardOutPath = "${logDir}/relay-stdout.log";
        StandardErrorPath = "${logDir}/relay-stderr.log";
      };
    };

    launchd.agents.herdr-remote-tunnel = lib.mkIf cfg.tunnel {
      enable = true;
      config = {
        ProgramArguments = [ (lib.getExe tunnel) ];
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 10;
        StandardOutPath = "${logDir}/tunnel-stdout.log";
        StandardErrorPath = "${logDir}/tunnel-stderr.log";
      };
    };
  };
}
