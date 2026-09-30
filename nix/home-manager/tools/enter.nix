# babarot/enter: show contextual info on Enter at an empty prompt.
# Published to babarot/nur-packages by GoReleaser.
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.enter ];

  # Binds ^M and adds a precmd hook, so it runs after plugins and ~/.zsh
  my.human.init = ''
    eval "$(enter --init-shell zsh)"
  '';
}
