#!/bin/bash

trap 'rm -f $gif_file' ERR

if ! type "ffmpeg" &>/dev/null; then
    echo "ffmpeg: not found" 1>&2
    exit 1
fi

if ! type "gifsicle" &>/dev/null; then
    echo "gifsicle: not found" 1>&2
    exit 1
fi

while (($# > 0))
do
    case "$1" in
        -h|--help)
            echo "${0##*/} [OPTIONS] file" 1>&2
            echo "  make gif file from mov file" 1>&2
            echo "" 1>&2
            echo "  OPTIONS:" 1>&2
            echo "    -h, --help  show this help" 1>&2
            echo "    -s, --size  specify gif file size e.g., 600x400" 1>&2
            echo "    -r, --rate  frame rate per second" 1>&2
            exit 1
            ;;
        -f|--force)
            is_force=1
            ;;
        -r|--rate)
            if [[ $2 =~ ^[0-9]+$ ]]; then
                rate="$2"; shift
            else
                echo "$2: invalid argument" 1>&2
                exit 1
            fi
            ;;
        -s|--size)
            if [[ $2 =~ ^[0-9]+x[0-9]+$ ]]; then
                size="$2"; shift
            else
                echo "$2: invalid argument" 1>&2
                exit 1
            fi
            ;;
        *)
            mov_file="${mov_file:-$1}"
            ;;
    esac

    shift
done

if [ -z "$mov_file" ]; then
    echo "too few arguments" 1>&2
    exit 1
fi

if [ ! -f "$mov_file" ]; then
    echo "$mov_file: no such file or directory" 1>&2
    exit 1
fi

out_file="$(basename "$mov_file")"
gif_file="$(dirname "$mov_file")/${out_file%.*}.gif"

if [ -f "$gif_file" ] && [ ${is_force:-0} -ne 1 ]; then
    echo "$gif_file: already exists" 1>&2
    exit 1
fi

ffmpeg -i "$mov_file" -s "${size:-600x400}" -pix_fmt rgb24 -r "${rate:-10}" -f gif - | gifsicle --optimize=3 --delay=3 >"$gif_file"
if [ $? -eq 0 ] && [ -f "$gif_file" ]; then
    success="Created $gif_file, successfully"
    echo "$success"
    if type "terminal-notifier" &>/dev/null; then
        terminal-notifier -message "$success" -title "${0##*/}"
    fi
fi
