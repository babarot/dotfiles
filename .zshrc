# zmodload zsh/zprof

# umask 022
# limit coredumpsize 0
# bindkey -d

# Return if zsh is called from Vim
# if [[ -n $VIMRUNTIME ]]; then
#     return 0
# fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
# if [[ -x ~/bin/tmuxx ]]; then
#     ~/bin/tmuxx
# fi

# if [[ -f ~/.zplug/init.zsh ]]; then
#     export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
#     source ~/.zplug/init.zsh
#
#     if ! zplug check --verbose; then
#         printf "Install? [y/N]: "
#         if read -q; then
#             echo; zplug install
#         fi
#         echo
#     fi
#     zplug load
# fi

# if [[ -f ~/.zshrc.local ]]; then
#     source ~/.zshrc.local
# fi

source <(antidote load)
# for f in ~/.zsh/*.zsh
# do
#     source $f
# done

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/vault vault

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
# [[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# # tabtab source for sls package
# # uninstall by removing these lines or running `tabtab uninstall sls`
# [[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# # tabtab source for slss package
# # uninstall by removing these lines or running `tabtab uninstall slss`
# [[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
