# A current bash for scripts that run `#!/usr/bin/env bash`. Only bash is
# linked: bashInteractive also ships bin/sh, which would come before
# macOS's /bin/sh on PATH.
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.runCommand "bash" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.bashInteractive}/bin/bash $out/bin/bash
    '')
  ];
}
