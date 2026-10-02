# Formatters and linters behind `nix fmt`, pinned by flake.lock.
# treefmt walks only files tracked by git, so ignored tool state under
# home/.config is never touched.
_: {
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix = {
      enable = true;
      # Modules here start with `{ ... }:`; `_:` is the same but less clear
      disabled-lints = [ "empty_pattern" ];
    };
    # *.sh and *.bash only; zsh files are not shfmt's language
    shfmt.enable = true;
  };
  # The hooks have no extension, so shfmt would skip them
  settings.formatter.shfmt.includes = [ ".githooks/*" ];
  settings.global.excludes = [ "*.lock" ];
}
