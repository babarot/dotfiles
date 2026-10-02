# my.skills: Agent Skills that ship with a tool, linked for both Claude
# Code (~/.claude/skills) and Codex and others (~/.agents/skills), so an
# agent knows how to use a tool as soon as the tool is installed.
#
# home/skills/<name> holds my own skills on trial: a shortcut around the
# release flow of babarot/agent-skills. They link to the repo, not the Nix
# store, so edits apply without a switch (a new skill still needs one).
# Once a skill settles, move it to babarot/agent-skills.
{ config, lib, ... }:
let
  inherit (config.my) repo;
  trial = ../../home/skills;
in
{
  options.my.skills = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = "Skill directories (containing SKILL.md) by skill name.";
  };

  config.my.skills = lib.mapAttrs (
    name: _: config.lib.file.mkOutOfStoreSymlink "${repo}/home/skills/${name}"
  ) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir trial));

  config.home.file = lib.mkMerge (
    lib.mapAttrsToList (name: src: {
      ".claude/skills/${name}".source = src;
      ".agents/skills/${name}".source = src;
    }) config.my.skills
  );
}
