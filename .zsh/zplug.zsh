# vim:ft=zplug

ZPLUG_SUDO_PASSWORD=
ZPLUG_PROTOCOL=ssh

zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "~/.zsh", from:local, use:"<->_*.zsh"

zplug "b4b4r07/emoji-cli", on:"junegunn/fzf-bin", if:'(( $+commands[jq] ))'
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-vimode-visual", use:"*.zsh", defer:3
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "glidenote/hub-zsh-completion"
zplug 'Valodim/zsh-curl-completion'

zplug 'b4b4r07/epoch-cat', \
    as:command, \
    hook-build:'go get -d && go build'

zplug "stedolan/jq", \
    as:command, \
    from:gh-r, \
    rename-to:jq

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

zplug "mattn/jvgrep", as:command, from:gh-r

zplug "reorx/httpstat", \
    as:command, \
    use:'(httpstat).py', \
    rename-to:'$1', \
    if:'(( $+commands[python] ))'

zplug 'kouzoh/mercari', \
    as:command, \
    use:'b4b4r07/(*).sh', \
    rename-to:'$1'

zplug "jhawthorn/fzy", \
    as:command, \
    hook-build:"make && sudo make install"

zplug "b4b4r07/git-open", as:command, at:patch-1
zplug "b4b4r07/open-link.sh", as:command, use:'(*).bash', rename-to:'$1'
zplug "b4b4r07/zsh-gomi", as:command, use:bin/gomi
zplug "b4b4r07/ssh-keyreg", as:command, use:bin
zplug "mrowa44/emojify", as:command
zplug 'b4b4r07/copy', as:command, use:'(*).sh', rename-to:'$1'

zplug "b4b4r07/ultimate", as:theme

if zplug check "b4b4r07/ultimate"; then
    zstyle ':ultimate:prompt:path' mode 'shortpath'
fi

zplug 'b4b4r07/zplug-doctor', lazy:yes
zplug 'b4b4r07/zplug-cd', lazy:yes
zplug 'b4b4r07/zplug-rm', lazy:yes

zplug 'b4b4r07/tmux-powertools', \
    ignore:init.zsh, \
    hook-load:'tmux-loader'

zplug 'b4b4r07/git-powertools', \
    as:command, \
    use:'bin/*'

zplug 'b4b4r07/zls', lazy:yes
zplug 'b4b4r07/fpath-editor', lazy:yes

zplug 'andialbrecht/sqlparse', \
    as:command, \
    hook-build:'python setup.py install'

zplug 'dtan4/ghrls', \
    as:command, \
    hook-build:'go get -d && go build'

zplug 'tianon/gosleep', \
    as:command, \
    hook-build:'go get -d ./src/gosleep/... && go build ./src/gosleep/...'

zplug 'b4b4r07/fzf-powertools', \
    as:command, \
    use:'re'

zplug 'b4b4r07/git-switch', \
    as:command, \
    use:'(*).sh', \
    rename-to:'$1'

zplug 'mutantcornholio/prok', \
    as:command, \
    use:'(*).sh', \
    rename-to:'$1'

zplug 'b4b4r07/ltsv.sh', \
    as:command, \
    use:'(ltsv).sh', \
    rename-to:'$1'
