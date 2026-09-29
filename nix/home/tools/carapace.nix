# carapace: zsh completions for commands that ship none on fpath (go, direnv,
# terraform, ...) or an outdated one (docker, whose own misses `docker
# compose` subcommands).
# Only the commands listed here use it; every other command keeps zsh's own
# completion, which `carapace _carapace zsh` would replace for all ~650
# commands it knows. Each file is generated at build time into
# share/zsh/site-functions, which nix-darwin puts on fpath; it calls
# `carapace` from PATH when completing. The files are named _carapace_<cmd>
# so they do not shadow zsh's own functions of the same name (_go).
{ pkgs, ... }:
let
  commands = [
    "brew" # Homebrew's own _brew is not on fpath
    "d2"
    "direnv"
    "docker"
    "docker-compose"
    "fzf"
    "ghostty"
    "go" # zsh's own _go covers gofmt and friends, not go itself
    "node"
    "terraform"
  ];
  completions =
    pkgs.runCommand "carapace-zsh-completions" { nativeBuildInputs = [ pkgs.carapace ]; }
      ''
        export HOME=$TMPDIR
        mkdir -p $out/share/zsh/site-functions
        for cmd in ${toString commands}; do
          carapace "$cmd" zsh > "$out/share/zsh/site-functions/_carapace_$cmd"
        done
      '';
in
{
  home.packages = [
    pkgs.carapace
    completions
  ];
}
