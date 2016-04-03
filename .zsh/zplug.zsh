has_plugin() {
    (( $+functions[zplug] )) || return 1
    zplug check "${1:?too few arguments}"
    return $status
}

# Local loading
zplug "b4b4r07/zplug"

# local plugin
zplug "~/.modules", \
    from:local, \
    nice:1, \
    of:"*.sh"
zplug "~/.zsh", \
    from:local, \
    nice:2, \
    of:"<->_*.zsh"

# commands
zplug "b4b4r07/zgit", \
    as:command, \
    of:bin, \
    on:"junegunn/fzf-bin"
zplug "b4b4r07/zsh-gomi", \
    as:command, \
    of:bin/gomi
zplug "b4b4r07/http_code", \
    as:command, \
    of:bin
zplug "b4b4r07/ssh-keyreg", \
    as:command, \
    of:bin
zplug "mrowa44/emojify", \
    as:command
zplug "stedolan/jq", \
    as:command, \
    from:gh-r, \
    frozen:1
zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    file:"fzf", \
    frozen:1
zplug "peco/peco", \
    as:command, \
    from:gh-r, \
    frozen:1
zplug "Jxck/dotfiles", \
    as:command, \
    of:bin/l
zplug "so-fancy/diff-so-fancy", \
    as:command, \
    of:diff-so-fancy

# plugins
zplug "b4b4r07/emoji-cli", \
    if:'(( $+commands[jq] ))', \
    on:"junegunn/fzf-bin"
zplug "b4b4r07/enhancd", \
    of:enhancd.sh
zplug "zsh-users/zaw"
zplug "mollifier/zload"
zplug "glidenote/hub-zsh-completion"
zplug "b4b4r07/zsh-vimode-visual", \
    of:"*.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", \
    nice:19
