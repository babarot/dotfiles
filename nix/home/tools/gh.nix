{ pkgs, ... }:
{
  home.packages = [ pkgs.gh ];

  # Install extensions by linking their binaries where gh looks for them,
  # instead of programs.gh, which would make gh's config.yml read-only.
  xdg.dataFile."gh/extensions/gh-md/gh-md".source =
    "${pkgs.gh-markdown-preview}/bin/gh-markdown-preview";
}
