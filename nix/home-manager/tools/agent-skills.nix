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
#
# Some of those skills run tools that agent-skills defines itself, in
# nix/writing-tools of that repo; they are installed here for Claude Code
# and Codex alike. What they are and how the skills use them stays in the
# private repo. A skill checks for its tool before using it, so removing
# this file only stops those skills, and nothing else here names the tools.
#
# The writing skills also proofread Japanese prose with the
# japanese-tech-writing skill, so it is imported here: agent-skills brings
# it along wherever it is installed. A skill skips that step when the skill
# is missing, so the import states the dependency rather than guards it.
{
  config,
  inputs,
  lib,
  pkgs,
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
  # also loaded from tools/ like every module there; the module system
  # reads a path once, so naming it here only records the dependency
  imports = [ ./japanese-tech-writing.nix ];

  options.my.agentSkills.scopes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "core" ];
    description = "Plugins of babarot/agent-skills whose skills are linked into ~/.agents/skills.";
  };

  config = {
    home.file = lib.mkMerge (map skillsOf cfg.scopes);
    home.packages = [ (pkgs.callPackage "${inputs.agent-skills}/nix/writing-tools" { }) ];
  };
}
