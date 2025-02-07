typeset -gx -U path
path=( \
    ~/protecht_devspace/dotfiles-2024/bin \
    ~/.local/bin \
    /usr/local/bin(N-/) \
    ~/bin(N-/) \
    ~/.zplug/bin(N-/) \
    ~/.tmux/bin(N-/) \
    /usr/local/go/bin \
    "$path[@]" \
)

# set fpath before compinit
typeset -gx -U fpath
fpath=( \
    ~/.zsh/Completion(N-/) \
    ~/.zsh/functions(N-/) \
    ~/.zsh/plugins/zsh-completions(N-/) \
    /usr/local/share/zsh/site-functions(N-/) \
    $fpath \
)

# . "$HOME/.cargo/env"
