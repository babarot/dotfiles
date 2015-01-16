# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }
function e_warning()  { echo -e " \033[1;34m‼\033[0m  $@"; }
function e_danger()   { echo -e " \033[1;34m⚡\033[0m  $@"; }
function e_heartful() { echo -e " \033[1;34m❤\033[0m  $@"; }

# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
function path_remove()
{
    local arg path
    path=":$PATH:"
    for arg in "$@"; do path="${path//:$arg:/:}"; done
    path="${path%:}"
    path="${path#:}"
    echo "$path"
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
    if [[ -n $1 ]]; then
        echo $*
    else
        # equal `cat -`
        cat /dev/stdin
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

