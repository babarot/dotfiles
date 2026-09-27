{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];

  my.human.env.EDITOR = "nvim";
  my.human.aliases = {
    vim = "nvim";
    vi = "command vim";
  };
}
