{ pkgs, ... }:
{
  home.packages = [ pkgs.jq ];

  my.human.globalAliases = {
    J = "| jq -C . | less -F";
    JQ = "| jq -C .";
    JL = "| jq -C . | less -R -X";
  };
}
