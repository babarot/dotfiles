# my.gitConfig: git settings that belong to a tool (its pager, a diff
# alias), written in the tool's file next to its package, with store paths.
# Rendered into ~/.config/git/tools.gitconfig, which home/.gitconfig
# includes; deleting the tool's file drops its settings, and git ignores
# an include whose file is empty or gone.
{ config, lib, ... }:
{
  options.my.gitConfig = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    default = { };
    description = "git config by section, e.g. { pager.log = \"...\"; }.";
  };

  config.xdg.configFile."git/tools.gitconfig".text = lib.generators.toGitINI config.my.gitConfig;
}
