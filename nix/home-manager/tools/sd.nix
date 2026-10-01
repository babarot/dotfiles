{ pkgs, ... }:
{
  home.packages = [ pkgs.sd ];

  # replace <pattern> [<replacement> [<pathspec>...]]: git grep, then sd
  # over the matching files (same as home/bin/git-replace)
  my.human.init = ''
    replace() {
      case "''${#}" in
        0) echo "too few arguments" >&2; return 1 ;;
        1) git grep "''${1}" ;;
        *)
          local from="''${1}" to="''${2}"
          shift 2
          git grep -l "$from" -- "$@" | xargs -I% sd "$from" "$to" %
          ;;
      esac
    }
  '';
}
