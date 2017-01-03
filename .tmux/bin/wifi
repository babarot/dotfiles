#!/bin/bash
#
# @(#) wifi v0.2.0 2015-09-24
#
# usage:
#   wifi [-h|--help]
#
# description:
#   show the wifi information (strength, bandwidth, SSID)
#
######################################################################

# Use: Put something this in your .tmux.conf file
# set-option -g status-right: '#(wifi -c tmux)'
#
# ▁▂▃▅▇

# . "$DOTPATH"/etc/lib/vital.sh

# if ! is_osx; then
#     echo "wifi: require OS X" 1>&2
#     exit 1
# fi

# Check arguments
# for arg in "$@"
# do
#     # Check if arguments have help option
#     if [[ "$arg" =~ ^"-h"|"--help"$ ]]; then
#         cat 1>&2 <<-'EOH'
# usage: wifi [-h|--help]
#     show the wifi information (strength, bandwidth, SSID)
# EOH
#         exit 1
#     fi
# done

# airport command is executable file
#
# Usage:
#   Search information about Wi-Fi by using airport command
#   airport command has this options
#    -c[<arg>] --channel=[<arg>]    Set arbitrary channel on the card
#    -z        --disassociate       Disassociate from any network
#    -I        --getinfo            Print current wireless status, e.g. signal info, BSSID, port type etc.
#    -s[<arg>] --scan=[<arg>]       Perform a wireless broadcast scan.
#                                      Will perform a directed scan if the optional <arg> is provided
#    -x        --xml                Print info as XML
#    -P        --psk                Create PSK from specified pass phrase and SSID.
#                                      The following additional arguments must be specified with this command:
#                                     --password=<arg>  Specify a WPA password
#                                     --ssid=<arg>      Specify SSID when creating a PSK
#    -h        --help               Show this help
#
airport_path="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# Check if airport is available
if [[ ! -x $airport_path ]]; then
    echo "$airport_path: not found" 1>&2
    exit 1
fi

# The Unicode Block Elements
# | Unicode | Block |           Name             |    Note    |
# |:-------:|:-----:|:--------------------------:|:----------:|
# |  2580   |  ▀    | UPPER HALF BLOCK           |            |
# |  2581   |  ▁    | LOWER ONE EIGHTH BLOCK     |            |
# |  2582   |  ▂    | LOWER ONE QUARTER BLOCK    |            |
# |  2583   |  ▃    | LOWER THREE EIGHTHS BLOCK  |            |
# |  2584   |  ▄    | LOWER HALF BLOCK           |            |
# |  2585   |  ▅    | LOWER FIVE EIGHTHS BLOCK   |            |
# |  2586   |  ▆    | LOWER THREE QUARTERS BLOCK |            |
# |  2587   |  ▇    | LOWER SEVEN EIGHTHS BLOCK  |            |
# |  2588   |  █    | FULL BLOCK                 | →25A0(■)   |
# |  2589   |  ▉    | LEFT SEVEN EIGHTHS BLOCK   |            |
# |  258A   |  ▊    | LEFT THREE QUARTERS BLOCK  |            |
# |  258B   |  ▋    | LEFT FIVE EIGHTHS BLOCK    |            |
# |  258C   |  ▌    | LEFT HALF BLOCK            |            |
# |  258D   |  ▍    | LEFT THREE EIGHTHS BLOCK   |            |
# |  258E   |  ▎    | LEFT ONE QUARTER BLOCK     |            |
# |  258F   |  ▏    | LEFT ONE EIGHTH BLOCK      |            |
# |  2590   |  ▐    | RIGHT HALF BLOCK           |            |
#
signals=(▂ ▅ ▇)

# Get the wifi information and then set it to an info array
info=( $(eval "$airport_path" --getinfo | grep -E "^ *(agrCtlRSSI|state|lastTxRate|SSID):" | awk '{print $2}') )
if [[ ${#info[@]} -eq 0 ]]; then
    echo "offline"
    exit 1
fi

# cut out a needed information from the info
# reference: http://osxdaily.com/2007/01/18/airport-the-little-known-command-line-wireless-utility/
rssi="${info[0]}"   # strength of wifi wave
stat="${info[1]}"   # whether wifi is available
rate="${info[2]}"   # bandwidth of wifi wave
ssid="${info[3]}"   # wifi ssid name

# Determine the signal from rssi of wifi
signal=""
for ((j = 0; j < "${#signals[@]}"; j++))
do
    # reference of strength (rssi)
    #  -20　Excellent
    #  -30　Excellent
    #  -40　Excellent
    #  -50　Excellent
    #  -60　better
    #  -70　good
    #  -80　not good
    #  -90　bad
    # -100　bad
    if ((  $j == 0 && $rssi > -100 )) ||
        (( $j == 1 && $rssi > -80  )) ||
        (( $j == 2 && $rssi > -50  )); then
        # make signal
        signal="${signal}${signals[$j]} "
    else
        signal="${signal}  "
    fi
done

# If the wifi rate (wifi bandwidth) is unavailable,
if [ "$rate" = 0 ]; then
    echo "no_wifi"
    exit 1
fi

# Outputs wifi
#   example: "fun-wifi 351Mbs ▂ ▅   "
echo -e "${ssid} ${rate}Mbs ${signal}"
