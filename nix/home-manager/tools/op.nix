# op [target...]: open targets with macOS's open, the current directory
# when none is given, or the one piped in
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "op";
      text = ''
        if ! type open &>/dev/null; then
            exit 1
        fi

        if [[ -p /dev/stdin ]]; then
            open "$(cat <&0)" "$@"
        else
            if [[ -z ''${1-} ]]; then
                open .
            else
                open "$@"
            fi
        fi
      '';
    })
  ];
}
