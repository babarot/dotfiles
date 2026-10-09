# syno: find the Synology NAS on the network and check on it from the
# terminal. Published to babarot/nur-packages by GoReleaser, with its Agent
# Skill under share/skills so the skill matches the binary.
# Only on this Mac: the NAS is on the home network.
{ inputs, pkgs, ... }:
let
  syno = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.syno;
in
{
  home.packages = [ syno ];

  my.skills.syno = "${syno}/share/skills/syno";
}
