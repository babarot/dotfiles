log=~/.cdlog

cd() {
    makelog "refresh"

    if [ -d "$1" ]; then
        builtin cd "$1"
    else
        interface "$1"
    fi &&
    makelog "assemble"
}

exists() {
    type "$1" >/dev/null
    return $?
}

interface() {
    if ! exists "peco"; then
        builtin cd "$1"
        return 0
    fi

    if [[ -z "$1" ]]; then
        target=$(
            {
                exists "ghq" && ghq list -p
                cat "$log"
                echo "$HOME"
            } | reverse2 | unique | peco
        )
        [[ -n "$target" ]] && builtin cd "$target"
    else
        if [[ "$1" = "-" ]]; then
            builtin cd "$(tail "$log" | head -9 | tail -1)" && return 0
        fi

        c=$(count "$1")
        if [[ "$c" -eq 0 ]]; then
            echo "$1: no such file or directory"
            return 1
        elif [[ "$c" -eq 1 ]]; then
            builtin cd $(narrow "$1")
        else
            builtin cd $(narrow "$1"| peco)
        fi
    fi
    return 0
}

unique() {
    awk '!a[$0]++' "${1:--}"
}

list() {
    {
        reverse $log
        exists "ghq" && ghq list -p
    } | unique
}

narrow() {
    list | awk '/\/.?'"$1"'[^\/]*$/{print $0}'
}

count() {
    narrow "$1" | grep -c ""
}

reverse() {
    ex -s "$1" <<-EOF
g/^/mo0
%p
EOF
}

enumrate() {
    touch "$log"

    file=$(
    for ((i=1; i<${#PWD}+1; i++))
    do
        if [[ ${PWD:0:$i+1} =~ /$ ]]; then
            echo ${PWD:0:$i}
        fi
    done
    find $PWD -maxdepth 1 -type d | grep -v "\/\."
    )
    echo "${file[@]}"
}

refresh() {
    touch "$log"

    while read line
    do
        [ -d "$line" ] && echo $line
    done <"$log"
}

makelog() {
    $1 >/tmp/log.$$
    rm "$log"
    mv /tmp/log.$$ "$log"
}

assemble() {
    enumrate
    cat "$log"
    pwd
}

reverse2() {
    perl -e 'print reverse <>'
}
