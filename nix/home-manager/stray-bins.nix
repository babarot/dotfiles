# my.knownBins: commands that something outside Nix puts in a directory on
# PATH on purpose, by directory under ~. Each switch lists every other
# command in those directories as a warning: curl | sh installers and
# `npm install -g` write to ~/.local/bin, and `go install` to ~/go/bin,
# where nothing in this repo would show them. Nothing is removed; a stray
# command is moved into Nix or deleted by hand.
#
#   my.knownBins.".local/bin" = [ "claude" ];
{ config, lib, ... }:
let
  dirs = config.my.knownBins;
in
{
  options.my.knownBins = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    default = { };
    description = "Commands expected in each directory (relative to ~) that is checked for strays.";
  };

  # Activation has a minimal PATH, so only bash builtins below
  config.home.activation.strayBins = lib.mkIf (dirs != { }) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatStrings (
        lib.mapAttrsToList (dir: known: ''
          (
            shopt -s nullglob dotglob
            strays=()
            for f in "$HOME/${dir}"/*; do
              case "''${f##*/}" in
                ${lib.concatMapStringsSep "|" lib.escapeShellArg ([ "" ] ++ known)}) ;;
                *) strays+=("''${f##*/}") ;;
              esac
            done
            if (( ''${#strays[@]} )); then
              warnEcho "~/${dir} has commands no file in dotfiles declares: ''${strays[*]}"
              warnEcho "Move them into Nix or delete them; expected ones go in my.knownBins.\"${dir}\""
            fi
          )
        '') dirs
      )
    )
  );
}
