has_plugin() {
    (( $+functions[zplug] )) || return 1
    zplug check "${1:?too few arguments}"
    return $status
}

# Local loading
zplug "zplug/zplug"

# local plugin
zplug "/Users/b4b4r07/.modules", \
    from:local, \
    nice:1, \
    use:"*.sh"
zplug "~/.zsh", \
    from:local, \
    nice:2, \
    use:"<->_*.zsh"

# commands
zplug "b4b4r07/zgit", \
    as:command, \
    use:bin, \
    on:"junegunn/fzf-bin"
zplug "b4b4r07/zsh-gomi", \
    as:command, \
    use:bin/gomi
zplug "b4b4r07/http_code", \
    as:command, \
    use:bin
zplug "b4b4r07/ssh-keyreg", \
    as:command, \
    use:bin
zplug "mrowa44/emojify", \
    as:command
zplug "stedolan/jq", \
    as:command, \
    from:gh-r, \
    frozen:1
zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    rename-to:"fzf", \
    frozen:1
zplug "monochromegane/the_platinum_searcher", \
    as:command, \
    from:gh-r, \
    rename-to:"pt", \
    frozen:1
zplug "peco/peco", \
    as:command, \
    from:gh-r, \
    frozen:1
zplug "Jxck/dotfiles", \
    as:command, \
    use:bin/l
zplug "so-fancy/diff-so-fancy", \
    as:command, \
    use:diff-so-fancy

# plugins
zplug "b4b4r07/emoji-cli", \
    if:'(( $+commands[jq] ))', \
    on:"junegunn/fzf-bin"
zplug "b4b4r07/enhancd", \
    use:init.sh
zplug "zsh-users/zaw"
zplug "mollifier/zload"
zplug "glidenote/hub-zsh-completion"
zplug "b4b4r07/zsh-vimode-visual", \
    use:"*.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", \
    nice:19

zplug "~/enhancd", \
    use:init.sh, \
    from:local
