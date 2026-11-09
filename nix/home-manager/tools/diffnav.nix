# diffnav: a git diff pager with a file tree (`git diff | diffnav`).
# nixpkgs' diffnav already puts delta on its own PATH (it renders each file
# by running `delta` by name), so it works without gh.nix.
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.diffnav ];

  # `git -P diff` (or `git -c pager.diff=less diff`) for the plain diff
  my.gitConfig.pager.diff = lib.getExe pkgs.diffnav;
}
