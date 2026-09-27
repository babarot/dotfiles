# Claude Code user settings, shared by every Mac. Linked straight to the
# files in claude/ of this repo, not the Nix store, because Claude Code
# writes to settings.json itself (/config, plugins, permissions); its
# edits show up as git diffs here.
#
# Claude Code itself is installed by its own installer (~/.local/bin).
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  dir = "${config.home.homeDirectory}/src/github.com/babarot/dotfiles/claude";
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
}
