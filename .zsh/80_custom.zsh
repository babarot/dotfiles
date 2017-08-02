function pet-select() {
    BUFFER="$(pet search --query "$LBUFFER")"
    CURSOR=$#BUFFER
    zle redisplay
}

zle -N pet-select
bindkey '^s' pet-select

function prev-add() {
  local PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

gchange() {
    if ! type gcloud &>/dev/null; then
        echo "gcloud not found" >&2
        return 1
    fi
    gcloud config configurations activate $(gcloud config configurations list | fzf-tmux --reverse --header-lines=1 | awk '{print $1}')
}

# kchange() {
#     if ! type kubectl &>/dev/null; then
#         echo "kubectl not found" >&2
#         return 1
#     fi
#     go get github.com/bronze1man/yaml2json
#     kubectl config use-context $({ kubectl config view | yaml2json; echo } | jq -r '.clusters[].name' | fzf-tmux)
# }

docker-rmi() {
    docker images \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $3}' \
        | xargs docker rmi ${1+"$@"}
}

source <(kubectl completion zsh)
source <(kubectl completion zsh | sed 's/__start_kubectl kubectl/__start_kubectl kube/')
