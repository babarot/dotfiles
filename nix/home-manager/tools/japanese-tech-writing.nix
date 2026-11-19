# japanese-tech-writing: my own Agent Skill, the base for plain, readable
# Japanese technical documents; skills for a medium (blog, issue, PR) add
# their style on top of it. Rewritten from k16shikano's skill of the same
# name (Unlicense) for documents in general rather than books.
#
# It is mine, yet kept in a secret gist instead of home/skills: it is
# written in Japanese, and this repo stays in English. Fetched at a fixed
# gist revision, so an edit to the gist reaches the agents only after the
# revision and hash here are bumped.
#
# The writing skills of babarot/agent-skills use it to proofread Japanese
# prose, so agent-skills.nix imports this file. Read the new SKILL.md
# before bumping the revision: it reaches those skills as instructions.
{ pkgs, ... }:
let
  skill = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/babarot/57294a12591a40c761c23771acd26ed1/raw/a7d4a5ce623015f6726e0cd1022bc2ee3e6bad5a/SKILL.md";
    hash = "sha256-QjC3EWt8QLWTAGCkWNHUTYBMvyYuIvZf0vnUQ8lZrbk=";
  };
in
{
  my.skills.japanese-tech-writing = pkgs.runCommand "japanese-tech-writing-skill" { } ''
    mkdir $out
    cp ${skill} $out/SKILL.md
  '';
}
