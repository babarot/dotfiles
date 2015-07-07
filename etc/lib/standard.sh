#!/bin/bash
#
# @(#) "The shellscript library" $0 ver.0.1 (c)BABAROT
#
#
# Copyright (c) 2014 b4b4r07 a.k.a BABAROT
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###########################################################################

if [[ -f ./vital.sh ]]; then
    source ./vital.sh
fi

#==========================================================================
# Boolean
readonly TRUE=0
readonly FALSE=1

# Exit status
readonly SUCCESS=0
readonly FAILURE=2

# Flag
readonly ON='ON'
readonly OFF='OFF'

#==========================================================================

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }
function e_warning()  { echo -e " \033[1;34m‼\033[0m  $@"; }
function e_danger()   { echo -e " \033[1;34m⚡\033[0m  $@"; }
function e_heartful() { echo -e " \033[1;34m❤\033[0m  $@"; }

function e_black()   { echo -e "\e[30m$*\e[m"; }
function e_red()     { echo -e "\e[31m$*\e[m"; }
function e_green()   { echo -e "\e[32m$*\e[m"; }
function e_yellow()  { echo -e "\e[33m$*\e[m"; }
function e_blue()    { echo -e "\e[34m$*\e[m"; }
function e_magenta() { echo -e "\e[35m$*\e[m"; }
function e_cyan()    { echo -e "\e[36m$*\e[m"; }
function e_white()   { echo -e "\e[37m$*\e[m"; }

function abs_path()
{
    if [ -z "$1" ]; then
        return 1
    fi

    if [ `expr x"$1" : x'/'` -ne 0 ]; then
        local rel="$1"
    else
        local rel="$PWD/$1"
    fi

    local abs="/"
    local _IFS="$IFS"; IFS='/'

    for comp in $rel; do
        case "$comp" in
            '.' | '')
                continue
                ;;
            '..')
                abs=`dirname "$abs"`
                ;;
            *)
                [ "$abs" = "/" ] && abs="/$comp" || abs="$abs/$comp"
                ;;
        esac
    done
    echo "$abs"
    IFS="$_IFS"
}

function rel_path()
{
    if [ -z "$1" ]; then
        echo 'too few arguments' 1>&2
        return 1
    fi

    if [ `expr x"$1" : x'/'` -eq 0 ]; then
        echo "$1: not an absolute path" 1>&2
        return 1
    fi

    local org=`expr x"$PWD" : x'/\(.*\)'`
    local abs=`expr x"$1"   : x'/\(.*\)'`
    local rel="."
    local org1=""
    local abs1=""

    while true; do
        org1=`expr x"$org" : x'\([^/]*\)'`
        abs1=`expr x"$abs" : x'\([^/]*\)'`

        [ "$org1" != "$abs1" ] && break

        org=`expr x"$org" : x'[^/]*/\(.*\)'`
        abs=`expr x"$abs" : x'[^/]*/\(.*\)'`
    done

    if [ -n "$org" ]; then
        local _IFS="$IFS"; IFS='/'
        for c in $org; do
            rel="$rel/.."
        done
        IFS="$_IFS"
    fi

    if [ -n "$abs" ]; then
        rel="$rel/$abs"
    fi

    rel=`expr x"$rel" : x'\./\(.*\)'`
    echo "$rel"
    return 0
}

function calc() { awk "BEGIN{ print $* }"; }

function nonewline()
{
    if [ "$(echo -n)" = "-n" ]; then
        echo "${@:-> }\c"
    else
        echo -n "${@:-> }"
    fi
}

function pwf()
{
    if [[ -e "$PWD"/"$1" ]]; then
        printf '%s\n' "$PWD"/"$1"
    else
        return 1
    fi
}

function trim()
{
    if ! is_osx; then
        return 1
    fi

    if (($# == 0)); then
        # cat -
        # cat <&0
        # cat /dev/stdin
        cat <&0
    elif (($# > 0)); then
        echo $*
    fi | tr -d '\n' | pbcopy
}

# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
# and Zshized by b4b4r07
function setdiff()
{
    is_zsh && setopt localoptions SH_WORD_SPLIT

    local debug skip a b
    if [[ "$1" == 1 ]]; then debug=1; shift; fi
    if [[ -n "$1" ]]; then
        local setdiffA setdiffB setdiffC
        setdiffA=($1); setdiffB=($2)
    fi
    setdiffC=()
    for a in "${setdiffA[@]}"; do
        skip=
        for b in "${setdiffB[@]}"; do
            [[ "$a" == "$b" ]] && skip=1 && break
        done
        [[ -n "$skip" ]] || setdiffC=("${setdiffC[@]}" "$a")
    done
    [[ -n "$debug" ]] && for a in setdiffA setdiffB setdiffC; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
done
[[ -n "$1" ]] && echo "${setdiffC[@]}"
}

# For testing.
function assert()
{
    local success modes equals actual expected
    modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
    actual="$("$@")"
    [[ "$actual" == "$expected" ]] && success=1 || success=0
    ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\""
}

#**************************************************************************
# Determine whether there is a pipe connection
# @param
# @return Returns 1 if there is a pipe connection,
#         otherwise it returns a non-zero.
#**************************************************************************
function is_pipe()
{
    if [ -p /dev/stdin ]; then
        #if [ -p /dev/fd/0  ]; then
        #if [ -p /proc/self/fd/0 ]; then
        #if [ -t 0 ]; then
        # echo a | is_pipe
        return 0
    elif [ -p /dev/stdout ]; then
        # is_pipe | cat
        return 0
    else
        # is_pipe (Only!)
        return 1
    fi
}

#**************************************************************************
# Determine whether or not the number
# @param $1 string
# @return Return 0 if it was the numbers, otherwise return 1
#**************************************************************************
function strlen()
{
    local length=`echo "$1" | wc -c | sed -e 's/ *//'`
    echo `expr $length - 1`
}

#**************************************************************************
# Determine whether the string length is 0
# @param $1 string
# @return Return 0 if the string length was 0, otherwise return non-0.
#**************************************************************************
function is_null()
{
    if [ $# -eq 0 ]; then
        cat <&0
    else
        echo "$1"
    fi | grep -E '^$' >/dev/null 2>&1
    if [ $? -eq $SUCCESS ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

#**************************************************************************
# Determine whether the string length is composed of 0 or blank only
# @param $1 string
# @return Return 0 if the string length is composed of 0 or blank only,
#         otherwise return non-0.
#**************************************************************************
function is_empty()
{
    if [ $# -eq 0 ]; then
        cat <&0
    else
        echo "$1"
    fi | grep -E "^[$_BLANK_]*$" >/dev/null 2>&1
    if [ $? -eq $SUCCESS ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

#**************************************************************************
# Determine whether or not the number
# @param $1 string
# @return Return 0 if it was the numbers, otherwise return 1
#**************************************************************************
function is_num()
{
    expr "$1" \* 1 >/dev/null 2>&1
    if [ $? -ge 2 ]; then
        return 1
    else
        return 0
    fi
}

function is_num2()
{
    [ "$1" -eq 0 ] 2>/dev/null
    if [ $? -ge 2 ]; then
        # $1 is a NOT a valid integer.
        return 1
    else
        # $1 is a valid integer.
        return 0
    fi
}

function is_numeric()
{
    if [ $# -eq 0 ]; then
        cat <&0
    else
        echo "$1"
    fi | grep -E '^[0-9]+$' >/dev/null 2>&1
    if [ $? -eq $SUCCESS ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

#**************************************************************************
# Convert lowercase to uppercase
# @param $1 filename
# @return return non-0 if patam error, otherwise return 0
#**************************************************************************
function UpperCase()
{
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            return $FAILURE
        fi
    else
        return $FAILURE
    fi | tr '[a-z]' '[A-Z]'

    return $SUCCESS
}

#**************************************************************************
# Convert uppercase to lowercase
# @param $1 filename
# @return return non-0 if patam error, otherwise return 0
#**************************************************************************
function LowerCase()
{
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            return $FAILURE
        fi
    else
        return $FAILURE
    fi | tr '[A-Z]' '[a-z]'

    return $SUCCESS
}

#**************************************************************************
# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
# @param path...
# @return return non-0 if patam error, otherwise return 0
#**************************************************************************
function path_remove()
{
    if (($# == 0)); then
        return 1
    fi
    local arg path

    path=":$PATH:"
    for arg in "$@"
    do
        path="${path//:$arg:/:}"
    done
    path="${path%:}"
    path="${path#:}"

    echo "$path"
    return 0
}

unique() {
    awk '!a[$0]++' "${1:--}"
}

reverse() {
    awk '
    BEGIN {
        sort_exe = "sort -t \"\034\" -nr"
    }
    
    {
        printf("%d\034%s\n", NR, $0) |& sort_exe;
    }
    
    END {
        close(sort_exe, "to");
    
        while ((sort_exe |& getline var) > 0) {
            split(var, arr, /\034/);
    
            print arr[2];
        }
        close(sort_exe);
    }' ${@+"$@"}
}

die() {
    echo "$1" 1>&2
    exit 1
}

readlinkf() {
    TARGET_FILE="$1"

    builtin cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`

    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET_FILE" ]
    do
        TARGET_FILE=`readlink $TARGET_FILE`
        cd `dirname $TARGET_FILE`
        TARGET_FILE=`basename $TARGET_FILE`
    done

    # Compute the canonicalized name by finding the physical path 
    # for the directory we're in and appending the target file.
    PHYS_DIR=`pwd -P`
    RESULT=$PHYS_DIR/$TARGET_FILE
    echo $RESULT
}
