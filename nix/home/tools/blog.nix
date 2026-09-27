# The binary itself is still installed outside Nix until it is published
# to the personal NUR repo
{ config, ... }:
{
  my.human.env = {
    BLOG_EDITOR = "nvim";
    BLOG_POST_DIR = "content/post";
    BLOG_ROOT = "${config.home.homeDirectory}/src/github.com/babarot/tellme.tokyo";
  };
}
