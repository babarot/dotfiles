# herdr plugin that lays out every git worktree workspace herdr creates or
# opens (prefix+shift+g, the sidebar, `herdr worktree create`): Claude Code
# top left, reviewr top right, a zsh across the bottom. The script is
# herdr-worktree-layout.sh; reviewr's own auto_open is off so it opens once.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  layout = pkgs.writeShellApplication {
    name = "herdr-worktree-layout";
    runtimeInputs = [
      config.my.herdr
      pkgs.jq
    ];
    text = builtins.readFile ./herdr-worktree-layout.sh;
  };
  exe = lib.getExe layout;
in
{
  my.herdrPlugins."babarot.worktree-layout" = pkgs.writeTextDir "herdr-plugin.toml" ''
    id = "babarot.worktree-layout"
    name = "Worktree layout"
    version = "0.1.0"
    min_herdr_version = "0.9.0"
    description = "Lay out new worktree workspaces as Claude Code, reviewr and a shell."
    platforms = ["macos"]

    [[events]]
    on = "worktree.created"
    command = ["${exe}"]

    [[events]]
    on = "worktree.opened"
    command = ["${exe}"]
  '';
}
