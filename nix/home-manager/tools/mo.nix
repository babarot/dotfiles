# babarot/mo: a fork of k1LoW/mo with personal changes (babarot/main
# branch), published to babarot/nur-packages by GoReleaser
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.mo ];
}
