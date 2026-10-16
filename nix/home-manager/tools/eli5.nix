# eli5: an Agent Skill (Apache-2.0) that explains a topic as if to someone
# who knows nothing about it, as an HTML artifact with big pictures and few
# words. It runs only when invoked (/eli5 <topic>). Picked alone from
# anthropics/claude-plugins-community, which has no releases, so it is
# fetched at a fixed commit; read the diff before bumping rev.
{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-community";
    rev = "06ec7b6a0a82bdc4bec44bd82d4368c42f20d7c1";
    hash = "sha256-tHCAXZmHANA0gTQ8KO+DPAzapX5I+Ok1q1+COD720+A=";
  };
in
{
  my.skills.eli5 = "${src}/eli5/skills/eli5";
}
