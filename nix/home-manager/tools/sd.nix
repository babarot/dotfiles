{ pkgs, ... }:
{
  home.packages = [ pkgs.sd ];

  # replace <pattern> [<replacement>]: git grep, then sd over the matches
  my.human.init = ''
    replace() {
      case "''${#}" in
        0) echo "too few arguments" >&2; return 1 ;;
        1) git grep "''${1}" ;;
        2) git grep -l "''${1}" | xargs -I% sd "''${1}" "''${2}" % ;;
        *)
          arg1="''${@:''${#@}-1:1}"
          arg2="''${@:''${#@}:1}"
          args="''${@:0:''${#@}-1}"
          git grep -l "''${args[@]}" "''${arg1}" | xargs -I% sd "''${arg1}" "''${arg2}" %
          ;;
      esac
    }
  '';
}
