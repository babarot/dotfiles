# main-drift: Claude Code hook that tells a session working in a git
# worktree when origin/main moved and touches the files its branch changed.
# The script is main-drift.sh; the hook is registered in
# home/.claude/settings.json (UserPromptSubmit and PreToolUse).
{ lib, pkgs, ... }:
{
  home.file.".claude/hooks/main-drift".source = lib.getExe (
    pkgs.writeShellApplication {
      name = "main-drift";
      runtimeInputs = [
        pkgs.coreutils
        # merge-tree --write-tree needs git 2.38; macOS ships an older one
        pkgs.git
        pkgs.jq
      ];
      text = builtins.readFile ./main-drift.sh;
    }
  );
}
