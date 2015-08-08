#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

if ! has "ffmpeg"; then
    die "requires: ffmpeg"
    exit 1
fi

if ! has "gifsicle"; then
    die "requires: gifsicle"
    exit 1
fi

mov_file="$1"

if [ -z "$mov_file" -o ! -f "$mov_file" ]; then
    exit 1
fi

fps_rate="${2:-10}"
gif_file="$(dirname $mov_file)"/out.gif

if [ -f "$gif_file" ]; then
    die "$gif_file: already exists"
    exit 1
fi

ffmpeg -i "$mov_file" -s 600x400 -pix_fmt rgb24 -r "$fps_rate" -f gif - | gifsicle --optimize=3 --delay=3 >"$gif_file"
