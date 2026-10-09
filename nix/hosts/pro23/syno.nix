# syno: find the Synology NAS on the network and check on it from the
# terminal. Published to babarot/nur-packages by GoReleaser, with its Agent
# Skill under share/skills so the skill matches the binary.
# Only on this Mac: the NAS is on the home network.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  syno = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.syno;
  skill = "${syno}/share/skills/syno";

  # What `/plugin install syno --marketplace babarot/syno` installs (the skill
  # and `syno mcp`), built from the package so it matches the binary. The
  # package does not ship the repo's .claude-plugin, and its plugin.json
  # names bare `syno`. No --allow-api: syno_api can send secrets from DSM's
  # settings to the AI provider.
  manifest = pkgs.writeText "plugin.json" (
    builtins.toJSON {
      name = "syno";
      inherit (syno) version;
      description = "Answer questions about a Synology NAS with syno: the syno skill and the syno mcp server";
      author.name = "babarot";
      homepage = "https://github.com/babarot/syno";
      mcpServers.syno = {
        command = lib.getExe syno;
        args = [ "mcp" ];
      };
    }
  );
  plugin = pkgs.runCommand "syno-claude-plugin" { } ''
    mkdir -p $out/.claude-plugin $out/skills
    cp ${manifest} $out/.claude-plugin/plugin.json
    cp -r ${skill} $out/skills/syno
  '';
in
{
  home.packages = [ syno ];

  home.file = {
    # A plugin directory under ~/.claude/skills loads in place as
    # syno@skills-dir, so it needs no marketplace or `claude mcp add`.
    ".claude/skills/syno".source = plugin;
    # Codex and others get only the skill; my.skills would also link it
    # into ~/.claude/skills, next to the plugin's copy.
    ".agents/skills/syno".source = skill;
  };
}
