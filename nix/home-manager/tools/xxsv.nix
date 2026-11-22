# xxsv: show a CSV, TSV or JSONL file as a table in the browser, kept up to
# date as the file changes. Published to babarot/nur-packages by GoReleaser.
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.xxsv ];
}
