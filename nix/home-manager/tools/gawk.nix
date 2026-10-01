# GNU awk under its own name only: pkgs.gawk also ships bin/awk, which
# would shadow BSD's awk that agents expect (see AGENTS.md)
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.runCommand "gawk" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.gawk}/bin/gawk $out/bin/gawk
    '')
  ];

  # Extract the first "quoted" string of each line: without quotes (Q) or with (QQ)
  my.human.globalAliases = {
    Q = "| gawk 'match($0, /\"(.*?)\"/, a) {print a[1]}'";
    QQ = "| gawk 'match($0, /(\".*?\")/, a) {print a[1]}'";
  };
}
