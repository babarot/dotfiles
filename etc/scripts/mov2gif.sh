#!/bin/bash

set -e

from=${1:?mov file is required}
to=${2:-outout.gif}

ffmpeg -i ${from} -pix_fmt rgb8 -r 10 ${to}
gifsicle -O3 ${to} -o ${to}
