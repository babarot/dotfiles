#!/bin/bash

stock=~/data/fukushima/$(date +%Y/%m/%d)

if [ ! -d "$stock" ]; then
    mkdir -p "$stock"
fi

curl -L http://i.buoy.jp/pkodg/fukushima.txt >"$stock"/fukushima_$(date +%H%M%S).txt
