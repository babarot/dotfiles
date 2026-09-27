# babarot/agent-skills for agents that read ~/.agents/skills (Codex, ...).
# Claude Code gets the same skills from the plugin marketplace instead.
# Each skill directory is linked on its own, so the folder stays open to
# skills from elsewhere. Update with `nix flake update agent-skills`.
{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.agentSkills;
  skillsOf =
    scope:
    let
      dir = "${inputs.agent-skills}/plugins/${scope}/skills";
    in
    lib.mapAttrs' (
      name: _: lib.nameValuePair ".agents/skills/${name}" { source = "${dir}/${name}"; }
    ) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir));
in
{
  options.my.agentSkills.scopes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "core" ];
    description = "Plugins of babarot/agent-skills whose skills are linked into ~/.agents/skills.";
  };

  config.home.file = lib.mkMerge (map skillsOf cfg.scopes);
}
