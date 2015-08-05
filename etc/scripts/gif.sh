#!/bin/bash

mov_file="$1"

if [ -z "$mov_file" -o ! -f "$mov_file" ]; then
    exit 1
fi

fps_rate="${2:-10}"
gif_file="$(dirname $mov_file)"/out.gif

ffmpeg -i "$mov_file" -s 600x400 -pix_fmt rgb24 -r "$fps_rate" -f gif - | gifsicle --optimize=3 --delay=3 >"$gif_file"
