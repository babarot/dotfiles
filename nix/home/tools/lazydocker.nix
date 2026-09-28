# lazydocker: TUI for docker and docker compose projects.
# Its settings live in home/.config/lazydocker/config.yml; it reads
# $XDG_CONFIG_HOME/lazydocker instead of ~/Library/Application Support
# as long as ~/Library/Application Support/jesseduffield/lazydocker does not exist.
{ pkgs, ... }:
{
  home.packages = [ pkgs.lazydocker ];

  my.human.aliases.lzd = "lazydocker";
}
