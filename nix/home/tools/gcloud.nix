{ pkgs, ... }:
{
  home.packages = [
    # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];

  # Switch gcloud configurations with fzf
  my.human.init = ''
    gchange() {
      gcloud config configurations activate "$(gcloud config configurations list | fzf-tmux --reverse --header-lines=1 | awk '{print $1}')"
    }
  '';
}
