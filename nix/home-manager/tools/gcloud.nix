{ pkgs, ... }:
{
  home.packages = [
    # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];

  # gchange: switch gcloud configurations with fzf
  # ohayo: log in again only for the credentials that have expired. The checks
  # read stdin from /dev/null so a reauth prompt fails fast instead of waiting
  # on the terminal; each login waits for the browser and stops ohayo if it fails
  # or is interrupted, so the next one never starts on top of it. The checks
  # can take a while, so gum shows a spinner to tell them apart from a hang;
  # the logins run bare because they print the URL and may ask for a code.
  my.human.init = ''
    gchange() {
      gcloud config configurations activate "$(gcloud config configurations list | fzf --reverse --header-lines=1 | awk '{print $1}')"
    }

    ohayo() {
      if gum spin --title "gcloud: checking..." -- gcloud auth print-access-token </dev/null; then
        echo "gcloud: ok"
      else
        echo "gcloud: expired, logging in (browser)..."
        gcloud auth login || return
      fi
      if gum spin --title "adc: checking..." -- gcloud auth application-default print-access-token </dev/null; then
        echo "adc: ok"
      else
        echo "adc: expired, logging in (browser)..."
        gcloud auth application-default login || return
      fi
    }
  '';
}
