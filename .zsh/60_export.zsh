# b4b4r07/emoji-cli
if is_linux; then
    export EMOJI_CLI_FILTER=peco
fi

pygmentize_if_available() {
    if ! has "pygmentize"; then
        return 1
    fi

    get_styles="from pygments.styles import get_all_styles
    styles = list(get_all_styles())
    print('\n'.join(styles))"
    styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )
    style=${${(M)styles:#${1:-default}}:-default}

    echo "$style"
}

pygmentize_style="$(pygmentize_if_available solarized)"
export LESS='-R -f -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
if has "pygmentize"; then
    export LESSOPEN="| pygmentize -O style=$pygmentize_style -f console256 -g %s"
fi

# jenegunn/fzf
export FZF_DEFAULT_OPTS='
--extended
--ansi
--multi
--bind=ctrl-u:page-up
--bind=ctrl-d:page-down
--bind=ctrl-z:toggle-all
'
