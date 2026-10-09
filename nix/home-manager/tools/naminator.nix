{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # naminator runs exiftool by name to read EXIF dates. It goes on naminator's
  # own PATH, not the user's, so exiftool is removed with this file.
  naminator = pkgs.symlinkJoin {
    name = "naminator-with-exiftool";
    paths = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.naminator ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/naminator --suffix PATH : ${lib.makeBinPath [ pkgs.exiftool ]}
    '';
  };
in
{
  home.packages = [ naminator ];

  my.human.aliases.naminator = "naminator --group-by-date --group-by-ext --clean";
}
