# GUI apps without settings of their own here. home-manager copies them to
# ~/Applications/Home Manager Apps. They do not self-update; `nix flake
# update` brings new versions.
#
# Apps that must self-update or install system components (1Password,
# Google Chrome, Docker, Parallels, Logi Options+, ...) are installed by
# their vendors instead.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    appcleaner
    hidden-bar
    iina
    numi
    obsidian
    qlmarkdown # Quick Look for Markdown
    spotify
    tableplus
  ];
}
