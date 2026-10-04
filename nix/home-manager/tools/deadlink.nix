# deadlink [dir...]: remove the broken symlinks in each directory ($HOME
# by default), asking before each one
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "deadlink";
      text = ''
        # Help message
        if [ "''${1-}" = "-h" ] || [ "''${1-}" = "--help" ]; then
            echo "usage: deadlink [dir(s)]" 1>&2
            echo "  Remove the broken symlinks within the directory given as arugment" 1>&2
            echo "  If an argument is ommited, it defaults to the \$HOME(home directory)" 1>&2
            exit
        fi

        # You may pass multiple directory arguments.
        for arg in "''${@:-$HOME}"
        do
            # Remove the hidden files and the regular files
            for f in "$arg"/.??* "$arg"/*
            do
                # -L: check for a symlink; -h is the same flag
                # -e: check for a validation of symlink;
                #     -a flag is deprecated
                #    ref to http://stackoverflow.com/questions/321348/bash-if-a-vs-e-option
                if [ -L "$f" ] && ! [ -e "$f" ]; then
                    # verbose and interactive; a link rm cannot remove does
                    # not stop the others
                    command rm -vi "$f" || true
                fi
            done
        done
      '';
    })
  ];
}
