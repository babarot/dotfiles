{ ... }:
{
  # programs.zsh is off, so hook direnv in ourselves
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  my.human.init = ''
    eval "$(direnv hook zsh)"
  '';
}
