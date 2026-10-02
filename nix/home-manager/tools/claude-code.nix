# Claude Code user settings, shared by every Mac. Linked straight to the
# files in home/.claude/ of this repo, not the Nix store, because Claude Code
# writes to settings.json itself (/config, plugins, permissions); its
# edits show up as git diffs here.
#
# Claude Code itself updates itself, so it comes from the official
# installer (~/.local/bin/claude), not nixpkgs; activation only installs it
# when missing, e.g. on a new Mac.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  dir = "${config.my.repo}/home/.claude";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dir}/${file}";
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.file = {
    # statusLine in settings.json runs this path. Published to
    # babarot/nur-packages by c-c-statusline's release workflow; its
    # `upgrade` subcommand cannot replace a Nix store binary.
    ".claude/c-c-statusline".source = "${babarot.c-c-statusline}/bin/c-c-statusline";
    ".claude/settings.json".source = link "settings.json";
    ".claude/keybindings.json".source = link "keybindings.json";
    ".claude/statusline.yaml".source = link "statusline.yaml";
    ".claude/CLAUDE.md".source = link "CLAUDE.md";
  };

  home.activation.claudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.local/bin/claude" ]]; then
      # Activation has a minimal PATH; the installer needs curl, shasum, sed
      # and friends from macOS. With ~/.local/bin already on PATH it does not
      # append a PATH line to the shell rc files in this repo.
      run /usr/bin/env PATH="$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
        /bin/bash -c 'curl -fsSL https://claude.ai/install.sh | bash' \
        || warnEcho "Claude Code: install failed; run: curl -fsSL https://claude.ai/install.sh | bash"
    fi
  '';
}
