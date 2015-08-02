#!/bin/bash

ffmpeg -i "${1:-in.mov}" -s 600x400 -pix_fmt rgb24 -r "${2:-10}" -f gif - | gifsicle --optimize=3 --delay=3 >"$(dirname ${1:-in.mov})"/out.gif
