# carapace: zsh completions for commands that ship none (terraform) or an
# outdated one (docker, whose own misses `docker compose` subcommands).
# Only the commands listed here use it; every other command keeps zsh's own
# completion, which `carapace _carapace zsh` would replace for all ~650
# commands it knows. Each file is generated at build time into
# share/zsh/site-functions, which nix-darwin puts on fpath; it calls
# `carapace` from PATH when completing.
{ pkgs, ... }:
let
  commands = [
    "docker"
    "docker-compose"
    "terraform"
  ];
  completions = pkgs.runCommand "carapace-zsh-completions" { nativeBuildInputs = [ pkgs.carapace ]; } ''
    export HOME=$TMPDIR
    mkdir -p $out/share/zsh/site-functions
    for cmd in ${toString commands}; do
      carapace "$cmd" zsh > "$out/share/zsh/site-functions/_$cmd"
    done
  '';
in
{
  home.packages = [
    pkgs.carapace
    completions
  ];
}
