# gomi: rm that moves files to the trash, for humans and AI agents alike.
# Agents take it for the rm they know: the flags are rm's, and a mistaken
# `rm -rf` can be restored with `gomi -b`. See my.ai in nix/home-manager/ai.nix.
{ lib, pkgs, ... }:
let
  # v1.6.5 lets files in $TMPDIR (/var/folders/.../T on macOS) be removed,
  # which mktemp cleanups rely on, and makes -f report files it could not
  # move instead of exiting 0. Drop this once nixpkgs has 1.6.5.
  gomi = pkgs.gomi.overrideAttrs (
    final: prev:
    lib.optionalAttrs (lib.versionOlder prev.version "1.6.5") {
      version = "1.6.5";
      src = prev.src.override {
        tag = "v${final.version}";
        hash = "sha256-SlPd4ahtJYwQpe4qtCuVPt/lJ1kFTlh9SX0ZVPjxURM=";
      };
    }
  );
  # The preview of a directory, by store path: gomi does not depend on
  # eza.nix putting eza on PATH
  eza = lib.getExe pkgs.eza;
in
{
  home.packages = [ gomi ];

  my.human.aliases.rm = "gomi";
  my.ai.aliases.rm = "gomi";

  # Generated rather than linked from the repo, so it can hold store paths;
  # it is rarely edited
  xdg.configFile."gomi/config.yaml".text = ''
    core:
      trash:
        strategy: auto
        home_fallback: true
        forbidden_paths:
          - $HOME/.local/share/Trash
          - $HOME/.trash
          - $XDG_DATA_HOME/Trash
          - /tmp/Trash
          - /var/tmp/Trash
          - $HOME/.gomi
          - /
          - /etc
          - /usr
          - /var
          - /bin
          - /sbin
          - /lib
          - /lib64

      restore:
        confirm: true
        verbose: true

      permanent_delete:
        enable: true

    ui:
      density: spacious # or compact
      preview:
        syntax_highlight: true
        colorscheme: nord  # https://xyproto.github.io/splash/docs/index.html
        directory_command: ${eza} -T -L 2 --color=always --icons=always
      style:
        deletion_dialog: "#FF007F" # "#F93769", "#FE7E39"
        list_view:
          cursor: "#AD58B4"   # purple
          selected: "#5FB458" # green
          indent_on_select: false
          filter_match: "#5FB458"
          filter_prompt: "#5FB458"
        detail_view:
          border: "#F0F0F0"
          info_pane:
            deleted_from:
              fg: "#EEEEEE"
              bg: "#1C1C1C"
            deleted_at:
              fg: "#EEEEEE"
              bg: "#1C1C1C"
          preview_pane:
            border: "#3C3C3C"
            size:
              fg: "#EEEEDD"
              bg: "#3C3C3C"
            scroll:
              fg: "#EEEEDD"
              bg: "#3C3C3C"
      exit_message: bye!
      paginator_type: dots

    history:
      include:
        within_days: 100
      exclude:
        files:
        - .DS_Store
        - "oil:"  # oil.nvim
        patterns:
        # - "^CH.*"
        globs:
        # - "*.go"
        size:
          min: 0KB
          max: 13GB

    logging:
      enabled: true
      level: debug
      rotation:
        max_size: 10MB
        max_files: 3
  '';
}
