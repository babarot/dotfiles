# my.skills: Agent Skills that ship with a tool, linked for both Claude
# Code (~/.claude/skills) and Codex and others (~/.agents/skills), so an
# agent knows how to use a tool as soon as the tool is installed.
{ config, lib, ... }:
{
  options.my.skills = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = "Skill directories (containing SKILL.md) by skill name.";
  };

  config.home.file = lib.mkMerge (
    lib.mapAttrsToList (name: src: {
      ".claude/skills/${name}".source = src;
      ".agents/skills/${name}".source = src;
    }) config.my.skills
  );
}
