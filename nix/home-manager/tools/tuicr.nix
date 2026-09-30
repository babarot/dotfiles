# tuicr: TUI for reviewing agent changes and passing the comments back.
# Its settings live in home/.config/tuicr/config.toml.
{ pkgs, ... }:
{
  home.packages = [ pkgs.tuicr ];

  # Not in the package; taken from the same release's source
  my.skills.tuicr = "${pkgs.tuicr.src}/skills/tuicr";
}
