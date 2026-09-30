# GNU timeout only. macOS has no timeout, and agents reach for it, but the
# rest of coreutils stays BSD: agents know they run on macOS and write BSD
# syntax (`sed -i ''`, `stat -f`, `date -v`), which GNU tools would break.
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.runCommand "timeout" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.coreutils}/bin/timeout $out/bin/timeout
    '')
  ];
}
