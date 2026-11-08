# stack-diagram: caru-ini's Agent Skill (MIT) that draws architecture
# diagrams with official logos as self-contained HTML, PNG or TSX. Fetched
# at a release tag instead of `npx skills add`. Its scripts write only to
# the working directory and ~/.config/stack-diagram, so the read-only store
# path is fine. Read the new SKILL.md before bumping the tag: it reaches the
# agent as instructions.
{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "caru-ini";
    repo = "stack-diagram";
    tag = "v0.4.0";
    hash = "sha256-VUOxIsW0XabuaZA8HxEICuHx2RJKgpdoYlvCaDzmxUM=";
  };
in
{
  my.skills.stack-diagram = "${src}/skills/stack-diagram";
}
