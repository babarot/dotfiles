# GitHub Copilot CLI comes from the official installer (~/.local/bin/copilot),
# not nixpkgs: it downloads its own updates, which the read-only Nix store
# would hold back. Activation only installs it when missing, e.g. on a new
# Mac.
{ config, lib, ... }:
let
  bin = "${config.home.homeDirectory}/.local/bin";
in
{
  my.knownBins.".local/bin" = [ "copilot" ];

  # Activation has a minimal PATH; with ~/.local/bin on it the installer does
  # not offer to add a PATH line to a shell rc.
  home.activation.copilotCli = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "${bin}/copilot" ]]; then
      run /usr/bin/env PATH="${bin}:/usr/bin:/bin:/usr/sbin:/sbin" \
        /bin/bash -c 'curl -fsSL https://gh.io/copilot-install | bash' \
        || warnEcho "Copilot CLI: install failed; run: curl -fsSL https://gh.io/copilot-install | bash"
    fi
  '';

  # Global instructions and settings, linked to the repo like ~/.claude,
  # since Copilot writes settings.json itself (/config, /settings). Login and
  # trusted folders are in config.json, left out. includeCoAuthoredBy = false
  # keeps it from adding a Co-authored-by trailer to commits. force replaces
  # a settings.json Copilot made before this link existed.
  home.file = {
    ".copilot/copilot-instructions.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.my.repo}/home/.copilot/copilot-instructions.md";
    ".copilot/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.my.repo}/home/.copilot/settings.json";
      force = true;
    };
  };
}
