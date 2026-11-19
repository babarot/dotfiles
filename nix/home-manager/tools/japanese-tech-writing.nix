# japanese-tech-writing: my own Agent Skill, the base for plain, readable
# Japanese technical documents; skills for a medium (blog, issue, PR) add
# their style on top of it. Rewritten from k16shikano's skill of the same
# name (Unlicense) for documents in general rather than books.
#
# It is mine, yet kept in a secret gist instead of home/skills: it is
# written in Japanese, and this repo stays in English. The gist holds
# SKILL.md and the files it reads (the replacement table), so it is
# fetched whole as a git repository at a fixed revision: an edit to the
# gist reaches the agents only after rev and hash here are bumped.
#
# The writing skills of babarot/agent-skills use it to proofread Japanese
# prose, so agent-skills.nix imports this file. Read the new SKILL.md
# before bumping the revision: it reaches those skills as instructions.
{ pkgs, ... }:
{
  my.skills.japanese-tech-writing = pkgs.fetchgit {
    url = "https://gist.github.com/57294a12591a40c761c23771acd26ed1.git";
    rev = "be83b9a7399ffec57ac95441d0f17c03c775711a";
    hash = "sha256-Rb/SyFPpTQ4R2zEBtdQGM3BTXPOkcFKxANfgbAyJeWY=";
  };
}
