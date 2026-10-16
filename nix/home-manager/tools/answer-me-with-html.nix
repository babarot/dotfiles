# answer-me-with-html: an Agent Skill that answers with a one-page HTML
# explainer (MIT). The agent writes a Markdown draft and the CLI bundled in
# the skill (scripts/am.mjs, run with a bare node from the agent's PATH, as
# in security-audit.nix) lays it out. Pages and config go to
# ~/.answer-me-with-html.
#
# Installed as a skill on its own rather than the Claude Code plugin, so
# Codex gets the same version; the plugin's /answer-me-with-html:config is
# `/answer-me-with-html config` here. The skill's own `update` runs npx
# skills or git pull, which does not apply: bump the tag, reading the diff.
#
# Disabled with mkIf false: it did not fit in use (home/skills/explain-me is
# tried instead). Kept so it can come back by dropping the mkIf.
{ pkgs, lib, ... }:
let
  version = "0.5.0";
  src = pkgs.fetchFromGitHub {
    owner = "QingYunA";
    repo = "answer-me-with-html";
    tag = "v${version}";
    hash = "sha256-vo2YMSe2u2adIelBPzOfJNEO1VF9nBCFkMR3AzpS6/Q=";
  };
in
lib.mkIf false {
  my.skills.answer-me-with-html = "${src}/skills/answer-me-with-html";

  # The CLI checks GitHub for a new version once a week; the version is
  # pinned here, so the notice could only point at an update that bypasses it
  my.env.AM_NO_UPDATE_CHECK = "1";
}
