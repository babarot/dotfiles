{ pkgs, ... }:
let
  # gke-gcloud-auth-plugin lets kubectl authenticate to GKE clusters
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];

  # How long a login lasts before Google asks for it again. Google exposes
  # no API for the time left, so gcloud-login counts it from when each
  # credential file was last written.
  sessionHours = 16;
in
{
  # gchange and gcloud-login are commands, not shell functions: they change
  # gcloud's own config and credentials, not the shell, so they can run as
  # scripts. Each lists what it runs in runtimeInputs, by store path; nothing
  # comes from fzf.nix or another file putting it on PATH.
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

    # gcloud-login: log in again only for the credentials that have expired,
    # then show how long each login has left. The checks read stdin from
    # /dev/null so a reauth prompt fails fast instead of waiting on the
    # terminal; each login waits for the browser and, with errexit, stops
    # gcloud-login if it fails or is interrupted, so the next one never starts
    # on top of it. The checks can take a while, so gum shows a spinner to
    # tell them apart from a hang; the logins run bare because they print the
    # URL and may ask for a code.
    #
    # The time left is counted from the file each login writes:
    # credentials.db for gcloud and application_default_credentials.json for
    # ADC. A token refresh writes only access_tokens.db, so their mtime is
    # when the login happened.
    (pkgs.writeShellApplication {
      name = "gcloud-login";
      runtimeInputs = [
        gcloud
        pkgs.gum
      ];
      text = ''
        dir=''${CLOUDSDK_CONFIG:-$HOME/.config/gcloud}

        left() {
          local start end rest
          start=$(stat -f %m "$1")
          end=$((start + ${toString sessionHours} * 3600))
          rest=$((end - $(date +%s)))
          if ((rest > 0)); then
            printf '%dh%02dm left, until %s' $((rest / 3600)) $((rest % 3600 / 60)) "$(date -r "$end" '+%m/%d %H:%M')"
          else
            printf 'session should have ended at %s' "$(date -r "$end" '+%m/%d %H:%M')"
          fi
        }

        if gum spin --title "gcloud: checking..." -- gcloud auth print-access-token </dev/null; then
          echo "gcloud: ok"
        else
          echo "gcloud: expired, logging in (browser)..."
          gcloud auth login
        fi
        echo "  $(left "$dir/credentials.db")"

        if gum spin --title "adc: checking..." -- gcloud auth application-default print-access-token </dev/null; then
          echo "adc: ok"
        else
          echo "adc: expired, logging in (browser)..."
          gcloud auth application-default login
        fi
        echo "  $(left "$dir/application_default_credentials.json")"
      '';
    })
  ];

  my.human.aliases.ohayo = "gcloud-login";
}
