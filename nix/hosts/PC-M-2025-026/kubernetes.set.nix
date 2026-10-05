# Set: tools for working with Kubernetes clusters, on the work Mac only.
# A new Kubernetes tool goes in this file, not in a file of its own; see
# "Cohesion: one file, one lifecycle" in AGENTS.md for what makes a set.
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
in
{
  home.packages = with pkgs; [
    helmfile
    kail
    krew
    kubectl
    kubectl-view-secret
    kubectx
    kubetail
    kubeval
    kustomize

    # kubectx/kubens as kubectl plugins (`kubectl ctx`, `kubectl ns`)
    (runCommand "kubectl-ctx-ns" { } ''
      mkdir -p $out/bin
      ln -s ${kubectx}/bin/kubectx $out/bin/kubectl-ctx
      ln -s ${kubectx}/bin/kubens $out/bin/kubectl-ns
    '')
  ];

  # krew installs kubectl plugins here as kubectl-* commands
  my.path = [ "${config.home.homeDirectory}/.krew/bin" ];

  my.human.plugins.zsh-abbr.init = ''
    abbr --session --quiet k=kubectl
  '';
}
