#!/bin/bash
# Bash - Bourne-Again Shell
#
# @(#) queue.sh ver.0.1.0 2013.07.27
#
# Usage:
#   . ~/bin/lib/dsl/queue.sh
#
# Description:
#   A lib is a collection of implementations of behavior,
#   written in terms of a language, that has a well-defined
#   interface by which the behavior is invoked.
#   In particular by this program, a group of functions to operate
#   a circular queue implemented using sequence.
#
###########################################################################

declare -a Q
declare -i Q_MAX=${1:-10}
declare -i Q_NUM=Q_FRONT=Q_REAR=0

enqueue() {
    if [ $Q_NUM -ge $Q_MAX ]; then
        echo "job is full"
        return -1
    else
        let Q_NUM++
        Q[$((Q_REAR++))]="$1"
        if [ $Q_REAR -eq $Q_MAX ]; then
            Q_REAR=0
        fi
        return 0
    fi
}

dequeue() {
    if [ $Q_NUM -le 0 ]; then
        echo "job is empty"
        return -1
    else
        let Q_NUM--
        echo ${Q[$((Q_FRONT++))]}
        if [ $Q_FRONT -eq $Q_MAX ]; then
            Q_FRONT=0
        fi
        return 0
    fi
}

q_peek () {
    echo ${Q[$Q_FRONT]}
}

q_print() {
    local i
    for ((i=$Q_FRONT; i<$Q_REAR; i++)) {
        printf "${Q[i]} "
    }
    printf "\n"
}

q_echo() {
    local i
    for ((i=0; i<$Q_NUM; i++)) {
        printf "${Q[$(((i + $Q_FRONT) % $Q_MAX))]} "
    }
    printf "\n"
}

q_size() {
    echo $Q_NUM
}

q_capacity() {
    echo $Q_MAX
}
