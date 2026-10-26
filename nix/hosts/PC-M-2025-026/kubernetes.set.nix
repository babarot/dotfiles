# Set: tools for working with Kubernetes clusters, on the work Mac only.
# A new Kubernetes tool goes in this file, not in a file of its own; see
# "One file, one lifecycle" in docs/reference/where-things-go.md for what
# makes a set.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # kubectx and kubens look up fzf on PATH for their interactive picker.
  # Wrapped so the picker does not depend on fzf.nix putting fzf there;
  # suffix, so an fzf earlier on PATH still wins.
  kubectx = pkgs.symlinkJoin {
    name = "kubectx-with-fzf";
    paths = [ pkgs.kubectx ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in kubectx kubens; do
        wrapProgram $out/bin/$bin --suffix PATH : ${lib.makeBinPath [ pkgs.fzf ]}
      done
    '';
  };

  # helm with the plugins helmfile needs (helm-diff for `helmfile diff`)
  helm = pkgs.wrapHelm pkgs.kubernetes-helm {
    plugins = [ pkgs.kubernetes-helmPlugins.helm-diff ];
  };

  # helmfile runs helm from PATH and reads its plugins from HELM_PLUGINS.
  # Wrapped so it finds this helm and its plugins; suffix, so a helm earlier
  # on PATH still wins. nixpkgs' helmfile-wrapped only sets HELM_PLUGINS, to
  # an empty plugin set.
  helmfile = pkgs.symlinkJoin {
    name = "helmfile-with-helm";
    paths = [ pkgs.helmfile ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/helmfile \
        --set-default HELM_PLUGINS ${helm.pluginsDir} \
        --suffix PATH : ${lib.makeBinPath [ helm ]}
    '';
  };

  # Radar: a Kubernetes UI in the browser (skyhook-io/radar). Not in
  # nixpkgs, so it is built from the release tag. The binary is
  # kubectl-radar (a kubectl plugin); `radar` is linked to it, as the
  # official installers do
  radar = pkgs.buildGoModule (finalAttrs: {
    pname = "radar";
    version = "1.16.0";
    src = pkgs.fetchFromGitHub {
      owner = "skyhook-io";
      repo = "radar";
      tag = "v${finalAttrs.version}";
      hash = "sha256-IEbND2Nj8JBcQ6p0sLY8wacDX8riZO+0r1/v2rKDZvY=";
    };
    vendorHash = "sha256-HvZCb/h9Cckc//k6uam06aIH9sLOEGhs8Dgz/N2pDFs=";
    subPackages = [ "cmd/explorer" ];

    # The frontend is built with npm (workspaces at the top of the source)
    # and embedded into the binary from internal/static/dist
    npmDeps = pkgs.fetchNpmDeps {
      inherit (finalAttrs) src;
      name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
      hash = "sha256-NZ/Iv+lzBAWlKcf2tVA9ad9sUUGLJJNIitn09pumiGU=";
    };
    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.npmHooks.npmConfigHook
    ];
    # The Go module fetch needs none of the frontend
    overrideModAttrs = old: {
      nativeBuildInputs = lib.remove pkgs.npmHooks.npmConfigHook old.nativeBuildInputs;
      preBuild = "";
    };
    preBuild = ''
      npm --workspace web run build
      rm -rf internal/static/dist
      mkdir -p internal/static/dist
      cp -r web/dist/* internal/static/dist/
    '';

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];
    env.CGO_ENABLED = 0;
    # The tests need a cluster or a browser for parts of them
    doCheck = false;

    postInstall = ''
      mv $out/bin/explorer $out/bin/kubectl-radar
      ln -s kubectl-radar $out/bin/radar
    '';
  });

  # Radar only ever talks to the cluster as a read-only identity: both
  # commands are wrapped to read radarKubeconfig, which impersonates a
  # read-only Google service account, so neither the UI nor its MCP server
  # can write whatever the kubeconfig in ~/.kube/config may do. Radar has no
  # switch of its own that blocks every write (--disable-exec only hides the
  # terminal button). If the file is missing Radar fails to start, rather
  # than falling back to ~/.kube/config. A --kubeconfig given on the command
  # line still wins, as the last flag does.
  # --disable-local-terminal: the host shell is not Kubernetes, so the
  # read-only identity does not limit it.
  radarKubeconfig = "${config.home.homeDirectory}/.kube/radar.yaml";
  radarReadonly = pkgs.symlinkJoin {
    name = "radar-readonly";
    paths = [ radar ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in kubectl-radar radar; do
        wrapProgram $out/bin/$bin \
          --add-flags "--kubeconfig ${radarKubeconfig} --disable-local-terminal"
      done
    '';
  };

  # Writes radarKubeconfig from contexts in ~/.kube/config, with the GKE
  # auth plugin set to impersonate the given service account. The account
  # and the contexts are passed when it is run, so work names stay out of
  # this public repo:
  #   radar-kubeconfig <service-account-email> <context>...
  # Every context must use an exec plugin (gke-gcloud-auth-plugin): any other
  # credential would ignore the impersonation and keep its own rights.
  radarKubeconfigGen = pkgs.writeShellApplication {
    name = "radar-kubeconfig";
    runtimeInputs = [
      pkgs.kubectl
      pkgs.jq
    ];
    text = ''
      if [ $# -lt 2 ]; then
        echo "usage: radar-kubeconfig <service-account-email> <context>..." >&2
        exit 2
      fi
      sa=$1
      shift
      keep=$(printf '%s\n' "$@" | jq -R . | jq -s .)
      out=${radarKubeconfig}

      config=$(kubectl config view --raw -o json | jq --arg sa "$sa" --argjson keep "$keep" '
        (.contexts | map(select(.name as $n | $keep | index($n)))) as $ctx
        | ($ctx | map(.name)) as $found
        | ($keep - $found) as $missing
        | if ($missing | length) > 0 then error("no such context: \($missing | join(", "))") else . end
        | ($ctx | map(.context.user)) as $users
        | ($ctx | map(.context.cluster)) as $clusters
        | (.users | map(select(.name as $n | $users | index($n)))) as $us
        | ($us | map(select(.user.exec == null) | .name)) as $noexec
        | if ($noexec | length) > 0 then error("not an exec plugin user: \($noexec | join(", "))") else . end
        | {
            apiVersion: "v1",
            kind: "Config",
            "current-context": $keep[0],
            contexts: $ctx,
            clusters: (.clusters | map(select(.name as $n | $clusters | index($n)))),
            users: ($us | map(.user.exec.env = ((.user.exec.env // []) + [{name: "CLOUDSDK_AUTH_IMPERSONATE_SERVICE_ACCOUNT", value: $sa}])))
          }')

      umask 077
      mkdir -p "$(dirname "$out")"
      printf '%s\n' "$config" > "$out.tmp"
      mv "$out.tmp" "$out"
      echo "wrote $out" >&2
      KUBECONFIG=$out kubectl auth whoami
    '';
  };

  # A Claude Code plugin with Radar's MCP server, the read-only endpoint
  # (no write tools listed). A plugin directory under ~/.claude/skills loads
  # in place, so it needs no `claude mcp add`. Radar has to be running for
  # the server to connect.
  radarPlugin = pkgs.writeTextDir ".claude-plugin/plugin.json" (
    builtins.toJSON {
      name = "radar";
      inherit (radar) version;
      description = "Inspect Kubernetes clusters through a running Radar, read-only";
      homepage = "https://github.com/skyhook-io/radar";
      mcpServers.radar = {
        type = "http";
        url = "http://127.0.0.1:9280/mcp-readonly";
      };
    }
  );
in
{
  home.packages = with pkgs; [
    helm
    helmfile
    kail
    krew
    kubectl
    kubectl-view-secret
    kubectx
    kubetail
    kubeval
    kustomize
    radarKubeconfigGen
    radarReadonly

    # kubectx/kubens as kubectl plugins (`kubectl ctx`, `kubectl ns`)
    (runCommand "kubectl-ctx-ns" { } ''
      mkdir -p $out/bin
      ln -s ${kubectx}/bin/kubectx $out/bin/kubectl-ctx
      ln -s ${kubectx}/bin/kubens $out/bin/kubectl-ns
    '')
  ];

  # krew installs kubectl plugins here as kubectl-* commands
  my.path = [ "${config.home.homeDirectory}/.krew/bin" ];

  home.file.".claude/skills/radar".source = radarPlugin;

  my.human.plugins.zsh-abbr.init = ''
    abbr --session --quiet k=kubectl
  '';
}
