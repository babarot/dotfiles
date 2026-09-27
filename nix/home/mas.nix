# my.masApps: Mac App Store apps to have installed, as { name = id; }.
# Each switch installs the missing ones with `mas`. Versions and updates are
# left to the App Store; apps not listed here are never removed.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.masApps;
  mas = "${pkgs.mas}/bin/mas";
in
{
  options.my.masApps = lib.mkOption {
    type = lib.types.attrsOf lib.types.ints.positive;
    default = { };
    example = {
      Magnet = 441258766;
    };
  };

  config = lib.mkIf (cfg != { }) {
    # Activation runs with a minimal PATH (no awk/grep), so stick to bash
    home.activation.masApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      installed=" "
      while read -r id _; do installed+="$id "; done < <(${mas} list 2>/dev/null)
      ${lib.concatStrings (
        lib.mapAttrsToList (name: id: ''
          if [[ $installed != *" ${toString id} "* ]]; then
            run ${mas} install ${toString id} \
              || warnEcho "mas: could not install ${name} (${toString id}); sign in to the App Store and switch again"
          fi
        '') cfg
      )}
    '';
  };
}
