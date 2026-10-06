# claude-image-view: a Claude Code mod that shows thumbnails of pasted
# images above the prompt instead of bare [Image #1] tags. The repository
# is the plugin itself (TypeScript hooks module, no build step).
{ inputs, ... }:
{
  # A plugin directory under ~/.claude/skills loads in place as
  # image-view@skills-dir, like claude-recall's, so flake.lock pins it and
  # no marketplace or enabledPlugins entry in settings.json is needed.
  home.file.".claude/skills/image-view".source = inputs.claude-image-view;

  # Claude Code turns terminal images off inside herdr, though herdr passes
  # the kitty graphics protocol through to Ghostty; this turns them back on.
  my.env.CLAUDE_CODE_FORCE_TERMINAL_IMAGES = "1";
}
