# babarot/agent-skills for agents that read ~/.agents/skills (Codex, ...).
# Claude Code gets the same skills from the plugin marketplace instead,
# updated on its own through autoUpdate in home/.claude/settings.json.
# Each skill directory is linked on its own, so the folder stays open to
# skills from elsewhere. Update with `nix flake update agent-skills`.
#
# ~/.agents/skills is flat, unlike Claude Code's plugin:skill names, and
# core and work share some skill names (create-issue, create-pr). Skills
# of scopes other than core are linked as <scope>-<name> so they do not
# clash.
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
      link = name: if scope == "core" then name else "${scope}-${name}";
    in
    lib.mapAttrs' (
      name: _: lib.nameValuePair ".agents/skills/${link name}" { source = "${dir}/${name}"; }
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
