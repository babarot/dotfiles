{ pkgs, ... }:
{
  # mikefarah/yq; `yq` in nixpkgs is the Python jq wrapper
  home.packages = [ pkgs.yq-go ];

  my.human.globalAliases.Y = "| yq -C | less -F";
}
