# Tools with no shell settings of their own
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    bashInteractive
    ccusage
    conftest
    deno
    difftastic
    exiftool
    gawk # used by the Q/QQ global aliases in ~/.zsh/30_aliases.zsh
    ghq
    git-open
    hcl2json
    imagemagick
    jsonfmt
    just
    mas
    mdbook
    mmv-go # itchyny/mmv; `mmv` in nixpkgs is a different tool
    pipx
    ripgrep
    rustup
    tree
    vhs # records terminal GIFs; brings its own ttyd and ffmpeg
    wget
  ];
}
