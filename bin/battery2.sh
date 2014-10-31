#!/bin/bash
# File: battery.sh
# Data: 2013-10-06

# Normal Colors {{{2
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC="\033[m"               # Color Reset
CR="$(echo -ne '\r')"
LF="$(echo -ne '\n')"
TAB="$(echo -ne '\t')"
ESC="$(echo -ne '\033')"
#}}}

function battery()
{
    if ! which ioreg >/dev/null; then
        return 1
    fi

    if ! ioreg -n AppleSmartBattery | grep "Capacity" >/dev/null; then
        return 0
    fi

    reslut=$(ioreg -n AppleSmartBattery | \
        awk '/MaxCapacity/{ MAX=$5 }
        /CurrentCapacity/{ CURRENT=$5 }
        /InstantTimeToEmpty/{ REMAIN=$5 }
        END { printf("%5.2f%% %2dh%2dm\n", CURRENT/MAX*100, REMAIN/60, REMAIN%60) }'
    )
    #echo -e "${BRed}${reslut}${NC}"
    remain_perc=$(echo "${reslut}" | awk '{print $1}')
    remain_time=$(echo "${reslut}" | awk '{print $2}')

    if [ $(echo "$remain_perc" | awk -F. '{print $1}') -ge 10 ]; then
        echo "#[fg=blue]${remain_perc}#[default]"
    else
        echo "#[fg=red]${remain_perc}#[default]"
    fi
}

battery "$@"
