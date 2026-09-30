# Startup banner for interactive human shells (colors come from .zshrc)
{ ... }:
{
  my.human.init = ''
    printf "\n''${fg_bold[cyan]} ''${SHELL} ''${fg_bold[red]}''${ZSH_VERSION}''${reset_color}\n\n"
  '';
}
