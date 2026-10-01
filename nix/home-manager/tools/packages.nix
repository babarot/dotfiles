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
    duckdb
    exiftool
    ffmpeg
    ghalint
    ghq
    git-open
    gum
    hcl2json
    hyperfine
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
    scc
    shellcheck
    shfmt
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
