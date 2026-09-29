# Not in nixpkgs; built from crit's own flake (see flake.nix inputs)
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.crit.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # What `crit install claude-code` would write, taken from the pinned source
  # so the skills match the binary. /crit makes the agent run crit itself and
  # wait for Finish Review, so every round's comments reach it directly.
  my.skills = {
    crit = "${inputs.crit}/integrations/claude-code/skills/crit";
    crit-cli = "${inputs.crit}/integrations/claude-code/skills/crit-cli";
    crit-story = "${inputs.crit}/integrations/claude-code/skills/crit-story";
  };
}
