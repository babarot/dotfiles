#!/bin/bash
# Bash - Bourne-Again Shell
#
# @(#) stack.sh ver.0.1.0 2013.07.27
#
# Usage:
#   . ~/bin/lib/dsl/stack.sh
#
# Description:
#   A lib is a collection of implementations of behavior,
#   written in terms of a language, that has a well-defined
#   interface by which the behavior is invoked.
#   In particular by this program, a group of functions to operate
#   a stack implemented using sequence.
#
###########################################################################

declare -a S
declare -i S_PTR=0
declare -i S_MAX=${1:-10}

push() {
    if [ $S_PTR -ge $S_MAX ]; then
        return -1
    fi
    S[$((S_PTR++))]="$1"
    return 0
}

pop() {
    if [ $S_PTR -le 0 ]; then
        return -1
    fi
    echo ${S[$((--S_PTR))]}
    return 0
}

s_peek() {
    if [ $S_PTR -le 0 ]; then
        return -1
    fi
    echo ${S[$(($S_PTR - 1))]}
    return 0
}

s_print() {
    local i
    for ((i=0; i<$S_PTR; i++)) {
        printf "${S[i]} "
    }
    printf "\n"
    return 0
}

s_size() {
    echo $S_PTR
}

s_capacity() {
    echo $S_MAX
}
