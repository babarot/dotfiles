#!/bin/bash
#
# File: battery.sh
# Created: 2013-10-06
# Modified: 2014-10-31

function battery()
{
    if ! which ioreg >/dev/null; then
        return 1
    fi
    if ! ioreg -n AppleSmartBattery | grep "Capacity" >/dev/null; then
        return 0
    fi

    local tmux_mode=0
    local percentage_mode=0
    local remaintime_mode=0

    while (( $# > 0 ))
    do
        case "$1" in
            -*)
                if [[ "$1" =~ 'h' ]]; then
                    echo "usage: battery.sh [-h][-t][-lp]"
                    return 0
                fi
                if [[ "$1" =~ 't' ]]; then
                    tmux_mode=1
                fi
                if [[ "$1" =~ 'p' ]]; then
                    percentage_mode=1
                fi
                if [[ "$1" =~ 'r' ]]; then
                    remaintime_mode=1
                fi
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    local max_capacity=$(ioreg -n AppleSmartBattery | awk '/MaxCapacity/{ print $5 }')
    local current_capacity=$(ioreg -n AppleSmartBattery | awk '/CurrentCapacity/{ print $5 }')
    local instant_time_to_empty=$(ioreg -n AppleSmartBattery | awk '/InstantTimeToEmpty/{ print $5 }')

    parcentage=$(ioreg -n AppleSmartBattery | \
        awk '/MaxCapacity/       { MAX=$5 }
             /CurrentCapacity/   { CURRENT=$5 }
             /InstantTimeToEmpty/{ REMAIN=$5 }
        END { printf("%5.2f%%\n", CURRENT/MAX*100) }'
    )
    remaintime=$(ioreg -n AppleSmartBattery | \
        awk '/MaxCapacity/       { MAX=$5 }
             /CurrentCapacity/   { CURRENT=$5 }
             /InstantTimeToEmpty/{ REMAIN=$5 }
        END { printf("%2dh%2dm\n", REMAIN/60, REMAIN%60) }'
    )

    local percentage=$(awk -v cur=$current_capacity -v max=$max_capacity 'BEGIN{ printf("%.2f%%\n", cur/max*100) }')
    local remaintime=$(awk -v remain=$instant_time_to_empty 'BEGIN{ printf("%dh%dm\n", remain/60, remain%60) }')

    if [ "$tmux_mode" == 1 ]; then
        if [ $(echo "$percentage" | awk -F. '{print $1}') -ge 10 ]; then
            echo "#[fg=blue]${percentage}#[default]"
        else
            echo "#[fg=red]${percentage}#[default]"
        fi
        return 0
    fi
    if [[ "$percentage_mode" == 1 && "$remaintime_mode" == 1 ]]; then
        echo "$percentage" "$remaintime"

    elif [[ "$percentage_mode" == 0 && "$remaintime_mode" == 0 ]]; then
        echo "$percentage" "$remaintime"

    elif [ "$percentage_mode" == 1 ]; then
        echo "$percentage"

    elif [ "$remaintime_mode" == 1 ]; then
        echo "$remaintime"
    fi
}

battery "$@"
