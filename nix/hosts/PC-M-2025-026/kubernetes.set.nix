# Set: tools for working with Kubernetes clusters, on the work Mac only.
# A new Kubernetes tool goes in this file, not in a file of its own; see
# "Cohesion: one file, one lifecycle" in AGENTS.md for what makes a set.
{ config, pkgs, ... }:
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
