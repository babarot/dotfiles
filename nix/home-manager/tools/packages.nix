# Tools with no shell settings of their own
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    actionlint
    ast-grep
    bashInteractive
    ccusage
    conftest
    d2
    deno
    difftastic
    exiftool
    ffmpeg
    ghalint
    ghq
    git-open
    gotools # goimports and friends
    gum
    hcl2json
    imagemagick
    jsonfmt
    just
    mas
    mdbook
    mmv-go # itchyny/mmv; `mmv` in nixpkgs is a different tool
    nodejs # default node; project versions come from mise
    pipx
    pnpm # follows each project's packageManager version
    postgresql # for psql
    ripgrep
    supabase-cli
    tree
    turso-cli
    uv
    vhs # records terminal GIFs; brings its own ttyd and ffmpeg
    viddy
    watch
    wget
  ];
}
