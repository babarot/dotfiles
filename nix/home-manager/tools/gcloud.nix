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
  # gcloud-change and gcloud-login are commands, not shell functions: they
  # change gcloud's own config and credentials, not the shell, so they can run
  # as scripts. Each lists what it runs in runtimeInputs, by store path;
  # nothing comes from fzf.nix or another file putting it on PATH.
  #
  # gcloud keeps one ADC file for all configurations, so activating a
  # configuration alone leaves ADC on the account and quota project of
  # whichever was logged in last. gcloud-login saves each configuration's ADC
  # under adc/<configuration>.json, and gcloud-change copies it back into
  # place. cp -p keeps the mtime, which gcloud-login counts the time left from.
  home.packages = [
    gcloud

    # gcloud-change: switch gcloud configurations with fzf, ADC included. With
    # no ADC saved for the configuration it only warns when the ADC in place
    # is another account's, since that file may be a login gcloud-login never
    # saw. Cancelling fzf ends it (errexit on the assignment) instead of
    # activating an empty name.
    (pkgs.writeShellApplication {
      name = "gcloud-change";
      runtimeInputs = [
        gcloud
        pkgs.fzf
        pkgs.jq
      ];
      text = ''
        dir=''${CLOUDSDK_CONFIG:-$HOME/.config/gcloud}
        adc=$dir/application_default_credentials.json

        name=$(gcloud config configurations list | fzf --reverse --header-lines=1 | awk '{print $1}')
        gcloud config configurations activate "$name"

        if [[ -f $dir/adc/$name.json ]]; then
          cp -p "$dir/adc/$name.json" "$adc"
          echo "adc: switched to $name's"
        elif [[ $(jq -r '.account // empty' "$adc" 2>/dev/null) != "$(gcloud config get account 2>/dev/null)" ]]; then
          echo "adc: not $name's account, run gcloud-login" >&2
        fi
      '';
    })

    # gcloud-login: log in again only for the credentials that have expired
    # or belong to another account than the active configuration's, then show
    # how long each login has left. The checks read stdin from /dev/null so a
    # reauth prompt fails fast instead of waiting on the terminal; each login
    # waits for the browser and, with errexit, stops gcloud-login if it fails
    # or is interrupted, so the next one never starts on top of it. The checks
    # can take a while, so gum shows a spinner to tell them apart from a hang;
    # the logins run bare because they print the URL and may ask for a code.
    #
    # Both logins name the configuration's account. gcloud then refuses
    # credentials for any other account picked in the browser; without it,
    # gcloud auth login writes whatever account was picked into the active
    # configuration. ADC records the account only when it is named, which is
    # what the check compares. The expired ADC is removed before logging in
    # because, given an account, gcloud skips the login whenever the file is
    # for that account, expired or not. gcloud auth login takes --force for
    # the same reason: given an account it has credentials for, it reuses them
    # instead of opening the browser, and refreshing them under Google's
    # session control asks for the password in the terminal.
    #
    # The time left is counted from the file each login writes:
    # credentials.db for gcloud and application_default_credentials.json for
    # ADC. A token refresh writes only access_tokens.db, so their mtime is
    # when the login happened. credentials.db is shared by every account, so
    # after a switch it shows the latest login of any account.
    (pkgs.writeShellApplication {
      name = "gcloud-login";
      runtimeInputs = [
        gcloud
        pkgs.gum
        pkgs.jq
      ];
      text = ''
        dir=''${CLOUDSDK_CONFIG:-$HOME/.config/gcloud}
        adc=$dir/application_default_credentials.json
        # One gcloud call for both: each takes seconds to start, and nothing
        # is printed until they return.
        active=$(gum spin --show-output --title "gcloud: reading configuration..." -- \
          gcloud config configurations list --filter=is_active=true --format='value(name,properties.core.account)' </dev/null)
        read -r name account <<<"$active"

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

        if [[ -z $account ]]; then
          echo "gcloud: no account set in configuration $name" >&2
          exit 1
        fi
        echo "configuration: $name ($account)"

        if gum spin --title "gcloud: checking..." -- gcloud auth print-access-token "$account" </dev/null; then
          echo "gcloud: ok"
        else
          echo "gcloud: expired, logging in (browser)..."
          gcloud auth login "$account" --force
        fi
        echo "  $(left "$dir/credentials.db")"

        if [[ $(jq -r '.account // empty' "$adc" 2>/dev/null) == "$account" ]] &&
          gum spin --title "adc: checking..." -- gcloud auth application-default print-access-token </dev/null; then
          echo "adc: ok"
        else
          echo "adc: expired or another account's, logging in (browser)..."
          rm -f "$adc"
          gcloud auth application-default login "$account"
        fi
        [[ -d $dir/adc ]] || mkdir -m 700 "$dir/adc"
        cp -p "$adc" "$dir/adc/$name.json"
        echo "  $(left "$adc")"
      '';
    })
  ];

  my.human.aliases.ohayo = "gcloud-login";
  my.human.aliases.gchan = "gcloud-change";
}
