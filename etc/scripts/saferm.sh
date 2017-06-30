set -e
set -u

declare trash_root=~/.rmtrash
declare trash=$trash_root/$(date '+%Y/%m/%d')
declare log=$trash_root/rmlog

Safety_rm()
{
    local -i error=0

    mkdir -p $trash 2>/dev/null

    local file
    for file in "$@"
    do
        if [[ -e $file ]]; then
            local to="$trash/$(basename $file).$(date '+%H_%M_%S')"

            if /bin/mv -f $file $to; then
                local abspath="$(cd $(dirname $file) && pwd)/$(basename $file)"
                printf "%s %s %s %s\n" $(date '+%Y-%m-%d %H:%M:%S') "$abspath" "$to" >>$log
            else
                echo "$file: could not move to trash" >&2
                error=1
            fi
        else
            echo "$file: not exist" >&2
            error=1
        fi
    done

    if [ "$error" = 1 ]; then
        return 1
    fi
}

tac_func()
{
    `which ex` -s "${1}" <<-EOF
    g/^/mo0
    %p
EOF
}

Safety_rm_b_option()
{
    if expr "$1" : '^[0-9]$' >/dev/null; then
        cp $(awk '{print $4,$3}' $log | tail -n "$1" | head -n 1)
    else
        max=$(
        for i in $(awk '{print $3}' $log |sed "s $HOME ~ g")
        do
            echo "${#i}"
        done | sort -nr -u | head -n 1)

        if type peco >/dev/null 2>&1; then
            echo $(tac_func $log | sed "s $HOME ~ g" | awk '{ printf("%-'$max's %s\n",$3,$4) }' | peco) | awk '{print $2,$1}'
        else
            printf "%-${max}s %s\n" $(sed "s $HOME ~ g" $log | awk '{print $3,$4}')
        fi
    fi
}

main()
{
    local -i argc=0
    local -a argv=()

    while (($# > 0))
    do
        case "$1" in
            -*)
                if [[ "$1" =~ h ]]; then
                    echo "usage: rm [-h][-b] file..."
                    echo "  -h    Show this help"
                    echo "  -b    back"
                    return 0
                fi
                if [[ "$1" =~ b ]]; then
                    Safety_rm_b_option "${2:-list}"
                    return 0
                fi
                shift
                ;;
            *)
                ((++argc))
                argv=(${argv[@]:-} "$1")
                shift
                ;;
        esac
    done

    Safety_rm "${argv[@]}"
}
main "$@"
