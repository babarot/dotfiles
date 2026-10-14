# claude-recap: look back on daily work across GitHub, Claude Code, Slack,
# Notion and Google Calendar (`recap`). Built from source by the repository's
# own flake while it is private; once public, it can come from
# babarot/nur-packages like claude-recall.
#
# `recap schedule install` points launchd at the recap on PATH, so it keeps
# working across updates.
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.claude-recap.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
