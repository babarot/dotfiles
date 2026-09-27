{ pkgs, ... }:
{
  home.packages = [
    # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];
}
