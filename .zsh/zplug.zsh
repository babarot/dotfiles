# vim:ft=zplug

has_plugin() {
    (( $+functions[zplug] )) || return 1
    zplug check "${1:?too few arguments}"
    return $status
}

# Local loading
zplug "zplug/zplug"

zplug "~/.modules", from:local, use:"*.sh"

zplug "~/.zsh", from:local, use:"<->_*.zsh", ignore:'40*'

zplug "b4b4r07/zsh-gomi", as:command, use:bin/gomi

zplug "b4b4r07/ssh-keyreg", as:command, use:bin

zplug "mrowa44/emojify", as:command

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

zplug "fujiwara/nssh", \
    as:command, \
    from:gh-r, \
    rename-to:"nssh", \
    frozen:1

zplug "tcnksm/ghr", \
    as:command, \
    from:gh-r

zplug "b4b4r07/gdate", \
    as:command, \
    from:gh-r

zplug "b4b4r07/emoji-cli", on:"junegunn/fzf-bin", if:'(( $+commands[jq] ))'

zplug "b4b4r07/enhancd", use:init.sh

zplug "glidenote/hub-zsh-completion"

zplug "b4b4r07/zsh-vimode-visual", use:"*.sh"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "philovivero/distribution", \
    as:command, \
    use:distribution, \
    if:'(( $+commands[perl] ))'

zplug "mitmproxy/mitmproxy", \
    as:command, \
    hook-build:"sudo python ./setup.py install"

zplug "wg/wrk", \
    as:command, \
    hook-build:"make"

zplug "reorx/httpstat", \
    as:command, \
    use:'httpstat.py', \
    rename-to:'httpstat', \
    if:'(( $+commands[python] ))'

zplug "jhawthorn/fzy", \
    as:command, \
    hook-build:"make && sudo make install"

zplug "b4b4r07/git-open", as:command, at:patch-1

zplug "b4b4r07/d66f7c8f32a0b5724eabbdc95ad921cf", from:gist

zplug "b4b4r07/open-link.sh", as:command, use:'*.bash', rename-to:'ol'

zplug "mattn/jvgrep", as:command, from:gh-r

zplug "b4b4r07/ultimate", as:theme

if zplug check "b4b4r07/ultimate"; then
    zstyle ':ultimate:prompt:path' mode 'shortpath'
fi

zplug 'b4b4r07/zplug-doctor', lazy:yes, use:zplug-doctor

zplug 'Valodim/zsh-curl-completion'
