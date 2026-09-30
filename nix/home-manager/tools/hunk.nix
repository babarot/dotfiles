# hunk: diff viewer an agent can drive and comment in with its hunk-review skill.
# Its settings live in home/.config/hunk/config.toml.
{ pkgs, ... }:
{
  home.packages = [ pkgs.hunk ];

  my.skills.hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
}
