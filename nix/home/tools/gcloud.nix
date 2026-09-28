{ pkgs, ... }:
{
  home.packages = [
    # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];

  # gchange: switch gcloud configurations with fzf
  # ga: log in again only for the credentials that have expired. The checks
  # read stdin from /dev/null so a reauth prompt fails fast instead of waiting
  # on the terminal; each login waits for the browser and stops ga if it fails
  # or is interrupted, so the next one never starts on top of it.
  my.human.init = ''
    gchange() {
      gcloud config configurations activate "$(gcloud config configurations list | fzf-tmux --reverse --header-lines=1 | awk '{print $1}')"
    }

    ga() {
      if gcloud auth print-access-token </dev/null >/dev/null 2>&1; then
        echo "gcloud: ok"
      else
        gcloud auth login || return
      fi
      if gcloud auth application-default print-access-token </dev/null >/dev/null 2>&1; then
        echo "adc: ok"
      else
        gcloud auth application-default login || return
      fi
    }
  '';
}
