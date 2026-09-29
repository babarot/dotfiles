{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;
in
{
  home.packages = [ pkgs.mise ];

  # Trust is recorded per path, so a fresh worktree starts untrusted and an
  # agent that cut it stops on the prompt. Trust my own repos and wherever
  # worktrees are cut from them, without naming each repo.
  xdg.configFile."mise/config.toml".text = ''
    [settings]
    trusted_config_paths = [
      "${home}/src/github.com/babarot",
      "${home}/.herdr/worktrees",
    ]
  '';

  # Agents get project versions through the shims on PATH (.zshenv);
  # activate additionally keeps PATH in sync for interactive use.
  my.human.init = ''
    eval "$(mise activate zsh)"
  '';
}
