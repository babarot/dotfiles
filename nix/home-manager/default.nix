# Every .nix file in ./tools is one unit of adding and removing: a single
# tool, a tool with companions, a <subject>.set.nix or a list ("One file,
# one unit" in AGENTS.md). Packages and shell settings live together, so
# deleting the file removes both.
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
  ]
  ++ map (f: ./tools + "/${f}") (
    builtins.filter (f: builtins.match ".*\\.nix" f != null) (
      builtins.attrNames (builtins.readDir ./tools)
    )
  );

  home.stateVersion = "26.05";
}
