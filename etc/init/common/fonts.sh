#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

powerline_fonts_dir="$DOTPATH"/etc/config/fonts/powerline

find_command="find \"$powerline_fonts_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

case "$(get_os)" in
    osx)
        font_dir="$HOME"/Library/Fonts
        ;;

    linux)
        font_dir="$HOME"/.fonts
        mkdir -p $font_dir
        ;;

    *)
        log_fail "error: this script is only supported osx and linux"
        exit 1
        ;;

esac

log_echo "Installing fonts"
eval $find_command | xargs -0 -I % cp "%" "$font_dir/"

if has "fc-cache"; then
    log_echo "Resetting font cache"
    fc-cache -f $font_dir
fi

log_pass "Fonts installed successfully"

