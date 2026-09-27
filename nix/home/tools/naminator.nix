{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.naminator ];

  my.human.aliases.naminator = "naminator --group-by-date --group-by-ext --clean";
}
