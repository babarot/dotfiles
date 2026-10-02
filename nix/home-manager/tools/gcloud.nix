{ pkgs, ... }:
let
  # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];
in
{
  # gchange and ohayo are commands, not shell functions: they change gcloud's
  # own config and credentials, not the shell, so they can run as scripts.
  # Each lists what it runs in runtimeInputs, by store path; nothing comes
  # from fzf.nix or another file putting it on PATH.
  home.packages = [
    gcloud

    # gchange: switch gcloud configurations with fzf. Cancelling fzf ends it
    # (errexit on the assignment) instead of activating an empty name.
    (pkgs.writeShellApplication {
      name = "gchange";
      runtimeInputs = [
        gcloud
        pkgs.fzf
      ];
      text = ''
        name=$(gcloud config configurations list | fzf --reverse --header-lines=1 | awk '{print $1}')
        gcloud config configurations activate "$name"
      '';
    })

    # ohayo: log in again only for the credentials that have expired. The
    # checks read stdin from /dev/null so a reauth prompt fails fast instead
    # of waiting on the terminal; each login waits for the browser and, with
    # errexit, stops ohayo if it fails or is interrupted, so the next one
    # never starts on top of it. The checks can take a while, so gum shows a
    # spinner to tell them apart from a hang; the logins run bare because
    # they print the URL and may ask for a code.
    (pkgs.writeShellApplication {
      name = "ohayo";
      runtimeInputs = [
        gcloud
        pkgs.gum
      ];
      text = ''
        if gum spin --title "gcloud: checking..." -- gcloud auth print-access-token </dev/null; then
          echo "gcloud: ok"
        else
          echo "gcloud: expired, logging in (browser)..."
          gcloud auth login
        fi
        if gum spin --title "adc: checking..." -- gcloud auth application-default print-access-token </dev/null; then
          echo "adc: ok"
        else
          echo "adc: expired, logging in (browser)..."
          gcloud auth application-default login
        fi
      '';
    })
  ];
}
