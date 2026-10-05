# japanese-tech-writing: an Agent Skill with rules for writing Japanese
# technical prose, published as a gist (Unlicense). Fetched at a fixed gist
# revision rather than copied into home/skills, which is for my own skills.
{ pkgs, ... }:
let
  skill = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d/raw/8f2d57610a73efc97d743c9b0b0ecb1002e09fa4/SKILL.md";
    hash = "sha256-rTUODm9WMP2U2KuYpq7hlAU7AJb9yUTCPicdbfoJ7mg=";
  };
in
{
  my.skills.japanese-tech-writing = pkgs.runCommand "japanese-tech-writing-skill" { } ''
    mkdir $out
    cp ${skill} $out/SKILL.md
  '';
}
