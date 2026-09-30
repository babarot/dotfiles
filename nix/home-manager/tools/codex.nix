{ pkgs, ... }:
{
  home.packages = [ pkgs.codex ];

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
