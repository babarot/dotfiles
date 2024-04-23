search_files_by_name() {
    rg --files | fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:70% --query="$1"
}

search_for_text_in_files() {
    local search_path=$1
    rg --column --line-number --with-filename --no-heading --color=always \
        --case-sensitive --word-regexp \
        --glob '!**/(.git|node_modules)/**' --glob '!**/(yarn\.lock)' \
        "$2" "$search_path" | fzf --ansi \
        --preview 'echo {} | awk -F: '\''{start=$2-10; if(start<0) start=0; end=$2+10; print "--style=numbers --color=always --decorations=always --line-range "start":"end" --highlight-line "$2" "$1}'\'' | xargs bat'
}
