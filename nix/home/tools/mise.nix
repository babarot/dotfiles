{ pkgs, ... }:
{
  home.packages = [ pkgs.mise ];

  # Agents get project versions through the shims on PATH (.zshenv);
  # activate additionally keeps PATH in sync for interactive use.
  my.human.init = ''
    eval "$(mise activate zsh)"
  '';
}
