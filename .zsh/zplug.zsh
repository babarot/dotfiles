# vim:ft=zplug

has_plugin() {
    (( $+functions[zplug] )) || return 1
    zplug check "${1:?too few arguments}"
    return $status
}

# Local loading
zplug "zplug/zplug"

zplug "~/.modules", \
    from:local, \
    nice:1, \
    use:"*.sh"

zplug "~/.zsh", \
    from:local, \
    nice:2, \
    use:"<->_*.zsh"

zplug "b4b4r07/zsh-gomi", \
    as:command, \
    use:bin/gomi

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

zplug "motemen/ghq", \
    as:command, \
    from:gh-r, \
    rename-to:ghq

zplug "b4b4r07/ls.zsh", \
    as:command, \
    use:bin/ls

zplug "b4b4r07/emoji-cli", \
    if:'(( $+commands[jq] ))', \
    on:"junegunn/fzf-bin"

zplug "b4b4r07/enhancd", \
    use:init.sh

zplug "glidenote/hub-zsh-completion"

zplug "b4b4r07/zsh-vimode-visual", \
    use:"*.sh"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-syntax-highlighting", \
    nice:19

zplug "b4b4r07/peco-tmux.sh", \
    as:command, \
    use:'*.sh', \
    rename-to:'peco-tmux'

zplug "philovivero/distribution", \
    as:command, \
    use:distribution, \
    if:'(( $+commands[perl] ))'

zplug "mitmproxy/mitmproxy", \
    as:command, \
    hook-build:"sudo python ./setup.py install"

zplug "fujiwara/nssh", \
    as:command, \
    from:gh-r, \
    rename-to:"nssh", \
    frozen:1

zplug "wg/wrk", \
    as:command, \
    hook-build:"make"

zplug "reorx/httpstat", \
    as:command, \
    use:'httpstat.py', \
    if:'(( $+commands[python] ))', \
    rename-to:'httpstat'

zplug "jhawthorn/fzy", \
    as:command, \
    hook-build:"make && sudo make install"

zplug "takuya/f5a6fb560dc357835122", \
    as:command, \
    from:gist, \
    use:'node2bash.js', \
    rename-to:'node2bash'

zplug 'Code-Hex/battery', as:command, from:gh-r
