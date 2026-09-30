# GNU awk under its own name; `awk` stays BSD's (see AGENTS.md)
{ pkgs, ... }:
{
  home.packages = [ pkgs.gawk ];

  # Extract the first "quoted" string of each line: without quotes (Q) or with (QQ)
  my.human.globalAliases = {
    Q = "| gawk 'match($0, /\"(.*?)\"/, a) {print a[1]}'";
    QQ = "| gawk 'match($0, /(\".*?\")/, a) {print a[1]}'";
  };
}
