# claude-recall: archive and search past coding agent sessions (`recall`).
# Published to babarot/nur-packages by claude-recall's release workflow,
# with its Claude Code plugin (MCP server, SessionEnd import hook, /recall
# skill) under share/claude-plugin.
{ inputs, pkgs, ... }:
let
  claude-recall = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.claude-recall;
  plugin = "${claude-recall}/share/claude-plugin/claude-recall";
in
{
  home.packages = [ claude-recall ];

  home.file = {
    # A plugin directory under ~/.claude/skills loads in place as
    # claude-recall@skills-dir, so the plugin always matches the binary and
    # needs no marketplace, `claude mcp add` or hook in settings.json.
    ".claude/skills/claude-recall".source = plugin;
    # Codex and others get only the skill; my.skills would also link it
    # into ~/.claude/skills, next to the plugin's copy.
    ".agents/skills/recall".source = "${plugin}/skills/recall";
  };
}
