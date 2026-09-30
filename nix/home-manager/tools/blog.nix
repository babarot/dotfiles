{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.blog
    pkgs.hugo
  ];

  my.human.env = {
    BLOG_EDITOR = "nvim";
    BLOG_POST_DIR = "content/post";
    BLOG_ROOT = "${config.home.homeDirectory}/src/github.com/babarot/tellme.tokyo";
  };
}
