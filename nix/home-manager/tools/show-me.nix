# show-me: HumanLayer's Agent Skill (MIT) that draws the current topic as
# pseudocode, call or file trees, Mermaid or diffs of those. It runs only
# when invoked (/show-me, $show-me). Picked alone from humanlayer/skills,
# which has no releases, so it is fetched at a fixed commit; read the diff
# before bumping rev.
{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "humanlayer";
    repo = "skills";
    rev = "653b6411c1f70c275a18e37673b042ff99f67ceb";
    hash = "sha256-W3dFEdIi4sz4CAZvaj1xjtN7xTRebF/WHOTQYCIe2Xo=";
  };
in
{
  my.skills.show-me = "${src}/plugins/show-me/skills/show-me";
}
