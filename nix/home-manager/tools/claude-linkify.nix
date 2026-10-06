# claude-linkify: my Claude Code mod that makes bare URLs and GitHub
# references (#123, owner/repo#123) in replies clickable. The repository
# is the plugin itself (TypeScript hooks module, no build step).
{ inputs, ... }:
{
  # Loaded in place from ~/.claude/skills as linkify@skills-dir, like
  # claude-image-view, so flake.lock pins it.
  home.file.".claude/skills/linkify".source = inputs.claude-linkify;
}
