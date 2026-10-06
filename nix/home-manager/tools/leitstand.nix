# leitstand: a Claude Code mod that lists background agents and shells,
# disk space and context usage above the prompt; /stand toggles it. The
# repository is the plugin itself (TypeScript hooks module, no build step).
# It runs only macOS's df and afplay.
{ inputs, ... }:
{
  # Loaded in place from ~/.claude/skills as leitstand@skills-dir, like
  # claude-image-view, so flake.lock pins it.
  home.file.".claude/skills/leitstand".source = inputs.leitstand;
}
