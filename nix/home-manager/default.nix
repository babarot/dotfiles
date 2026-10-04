# Every .nix file in ./tools holds one lifecycle, what is added and removed
# together: a single tool, a tool with companions, a <subject>.set.nix or a
# list ("Cohesion: one file, one lifecycle" in AGENTS.md). Packages and shell
# settings live together, so deleting the file removes both.
# Other files there are the tools' own scripts and patch directories, read
# by their .nix file. Tool files for one Mac only are in nix/hosts/<host>/,
# imported by mkHost in flake.nix.
{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./env.nix
    ./git.nix
    ./fork-patches.nix
    ./human.nix
    ./ai.nix
    ./skills.nix
    ./herdr-plugins.nix
    ./mas.nix
    ./stray-bins.nix
  ]
  ++ map (f: ./tools + "/${f}") (
    builtins.filter (f: builtins.match ".*\\.nix" f != null) (
      builtins.attrNames (builtins.readDir ./tools)
    )
  );

  home.stateVersion = "26.05";
}
