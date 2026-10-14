# Codex comes from the official installer (~/.local/bin/codex), not
# nixpkgs, so it can follow the latest release instead of waiting for a
# flake update; activation only installs it when missing, e.g. on a new
# Mac. Unlike Claude Code it does not update itself (it only offers an
# update at startup), so a launchd agent runs `codex update` daily.
{ config, lib, ... }:
let
  bin = "${config.home.homeDirectory}/.local/bin";
  # Without it the installer asks on /dev/tty, which a switch has, whether to
  # start Codex now. Activation and launchd have a minimal PATH; the
  # installer needs curl, shasum, tar and friends from macOS. With
  # ~/.local/bin already on PATH it does not add a PATH line to a shell rc.
  env = "CODEX_NON_INTERACTIVE=1 PATH=${bin}:/usr/bin:/bin:/usr/sbin:/sbin";
in
{
  # The installer's link and the helper it installs next to it
  my.knownBins.".local/bin" = [
    "codex"
    "codex-code-mode-host"
  ];

  home.activation.codex = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "${bin}/codex" ]]; then
      run /usr/bin/env ${env} \
        /bin/sh -c 'curl -fsSL https://chatgpt.com/codex/install.sh | sh' \
        || warnEcho "Codex: install failed; run: curl -fsSL https://chatgpt.com/codex/install.sh | sh"
    fi
  '';

  launchd.agents.codex-update = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''[ -x "${bin}/codex" ] || exit 0; exec /usr/bin/env ${env} "${bin}/codex" update''
      ];
      RunAtLoad = true;
      StartCalendarInterval = [
        {
          Hour = 9;
          Minute = 0;
        }
      ];
      StandardOutPath = "${config.xdg.stateHome}/codex-update.log";
      StandardErrorPath = "${config.xdg.stateHome}/codex-update.log";
    };
  };

  # codex runs inside the Seatbelt sandbox and cannot read the Keychain,
  # so gh fails to fetch its token and gets 401. Pass the token via env
  # only when launching codex. Network access itself is enabled by
  # [sandbox_workspace_write] network_access = true in ~/.codex/config.toml.
  my.human.init = ''
    codex() {
      if [[ -z $GH_TOKEN ]] && (( $+commands[gh] )); then
        GH_TOKEN="$(command gh auth token 2>/dev/null)" command codex "$@"
      else
        command codex "$@"
      fi
    }
  '';
}
