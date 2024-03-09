DEFAULT_USER=$USER


# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# # can change all these custom sources to conditionaly load them through zpromp.
# # the goal would be to make it so we can source this file only into server
test -e "${HOME}/.exports" && source ~/.exports
test -e "${HOME}/.aliases" && source ~/.aliases
# # test -e "${HOME}/.upstart_env" && source ~/.upstart_env

# export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# export PUPPETEER_EXECUTABLE_PATH="$(which chromium)"
# alias vim=nvim


# source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
# . /opt/homebrew/opt/asdf/libexec/asdf.sh



# # Load a few important annexes, without Turbo
# # (this is currently required for annexes)
# zinit light-mode for \
#     zdharma-continuum/zinit-annex-as-monitor \
#     zdharma-continuum/zinit-annex-bin-gem-node \
#     zdharma-continuum/zinit-annex-patch-dl \
#     zdharma-continuum/zinit-annex-rust

# # TODO: Needs Python2
# # zinit light tysonwolker/iterm-tab-colors

# # Add iterm shell intergrations if present
# # TODO: fix this, the iff isn't working right
# # if [[$TERM_PROGRAM=="iTerm.app"]]; then
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# # fi

# # Load a few important annexes, NO TURBO
# # (this is currently required for annexes)
# zinit light-mode for \
#     zdharma-continuum/z-a-patch-dl \
#     zdharma-continuum/z-a-as-monitor \
#     zdharma-continuum/z-a-bin-gem-node \
#     zdharma-continuum/z-a-submods

# zinit snippet OMZL::git.zsh
# zinit ice atload"unalias grv"
# zinit snippet OMZP::git


# # TODO: not working, find correct install for this
# # Scripts that are built at install (there's single default make target, "install",
# # and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# # `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
# zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
# zinit light tj/git-extras
# #


# zinit lucid for \
#  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
#     zdharma-continuum/fast-syntax-highlighting \
#  blockf \
#     zsh-users/zsh-completions \
#  atload"!_zsh_autosuggest_start" \
#     zsh-users/zsh-autosuggestions

# # must be after the above syntax/suggestion updating
# zinit light zdharma-continuum/history-search-multi-word


# zinit ice from"gh-r" as"program"




# # setup LS_COLORS
# # https://zdharma.org/zinit/wiki/LS_COLORS-explanation/
# # https://github.com/trapd00r/LS_COLORS
# zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
#     atpull'%atclone' pick"clrs.zsh" nocompile'!' \
#     atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
# zinit light trapd00r/LS_COLORS

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
# zinit light b4b4r07/httpstat
# #
# zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
# zinit light sharkdp/fd
# #
# zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
# zinit light sharkdp/bat

# # / stopped working and installed via brew install exa
# # zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa" ver"v0.9.0"
# # zinit light ogham/exa
# #
# #
# # # colortest
# #
# # sharkdp/pastel
# zinit ice as"command" from"gh-r" mv"pastel* -> pastel" pick"pastel/pastel"
# zinit light sharkdp/pastel
# #
# # zinit ice as"command" wait lucid \
# #     atinit"export PYTHONPATH=$ZPFX/lib/python3.7/site-packages/" \
# #     atclone"PYTHONPATH=$ZPFX/lib/python3.7/site-packages/ \
# #     python3 setup.py --quiet install --prefix $ZPFX" \
# #     atpull'%atclone' test'0' \
# #     pick"$ZPFX/bin/asciinema"
# # zinit load asciinema/asciinema

# # # Terminal GIPHY creator cast terminal
# zinit load asciinema/asciinema.git

# export PATH="/usr/local/sbin:$PATH"
# #
# ulimit -n 21504
# ulimit -c 2000
# ulimit -s 10000
# # trying  to install these unconfirmed
# zinit snippet OMZP::git
# zinit snippet OMZP::brew


# change-prompt-title() {
#   echo -ne "\e]1;${PWD##*/}\a"
# }
# add-zsh-hook chpwd change-prompt-title


# # exceptionally better mov command
autoload zmv

# # export FZF_CTRL_R_OPTS="
# #   --preview 'echo {}' --preview-window up:3:hidden:wrap
# #   --bind 'ctrl-/:toggle-preview'
# #   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
# #   --color header:italic
# #   --header 'Press CTRL-Y to copy command into clipboard'"


# eval "$(direnv hook zsh)"

export PATH="${PATH}:${HOME}/.krew/bin"

# export FZF_BASE="/Users/djdaniels/.local/share/zinit/plugins/junegunn---fzf/fzf/"


# Fig pre block. Keep at the top of this file.
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# oh-my-zsh
function omzPlugin() {
  zinit ice lucid $2
  zinit snippet OMZP::$1
}

function omzLib() {
  zinit wait'!' lucid for OMZL::$1
}

### Update ZINIT
zinit self-update
# zinit update --all --parallel --quiet

# OH-MY-ZSH libs
omzLib functions.zsh
omzLib completion.zsh
omzLib correction.zsh
omzLib directories.zsh
omzLib git.zsh
omzLib grep.zsh
omzLib history.zsh
omzLib key-bindings.zsh
omzLib completion.zsh
omzLib termsupport.zsh

## OH-MY-ZSH plugins
# MacOS
if [[ `uname` == "Darwin" ]]; then
    zinit ice lucid macos pick"(music|spotify)"
    # zinit ice lucid macos
    zinit snippet OMZP::macos
fi
# system
omzPlugin iterm2
omzPlugin ssh-agent
omzPlugin sudo
omzPlugin cp
omzPlugin rsync wait"1"
omzPlugin gpg-agent
# git
omzPlugin git
omzPlugin github wait"1"
# node
omzPlugin node wait"1"
omzPlugin yarn wait"1"
# omzPlugin nvm wait"1"
# python
omzPlugin python wait"1"
omzPlugin pyenv wait"1"
# omzPlugin pipenv wait"1"
# java
omzPlugin jenv wait"1"
# ruby
# omzPlugin rvm wait"1"
# docker
# omzPlugin docker wait"1"
omzPlugin docker-machine wait"1"
# zstyle ':omz:plugins:docker' legacy-completion yes

# httpie
# omzPlugin httpie wait"1"
# zsh
omzPlugin z
# omzPlugin fasd
omzPlugin fzf
omzPlugin asdf wait"1"
omzPlugin command-not-found wait"1"
omzPlugin common-aliases
omzPlugin compleat wait"1"
omzPlugin colorize wait"1"
# omzPlugin per-directory-history wait"1"
##

### PLUGINS

# git-extras
zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zinit light tj/git-extras

# direnv
zinit ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh"
zinit light direnv/direnv

zinit load asciinema/asciinema.git

zinit snippet OMZP::colored-man-pages
# zinit ice as"completion"

zinit load agkozak/zsh-z

zinit ice as"program" pick"init.zsh" wait"2" lucid 
zinit ice nocompile'!' wait'!0' pick'enhancd.plugin.zsh' atinit"zicompinit; zicdreplay"
zinit ice pick'enhancd.plugin.zsh' atinit"zicompinit; zicdreplay"
zinit light b4b4r07/enhancd
# export ENHANCD_FILTER="fzf --height 40%:fzf"
export ENHANCD_FILTER="fzf --preview='exa --tree --group-directories-first --git-ignore --level 1 {}'"

# diff-so-fancy
zinit ice as"program" pick"bin/git-dsf" wait"2" lucid
zinit light zdharma-continuum/zsh-diff-so-fancy

# pyenv
zplugin lucid as'command' pick'bin/pyenv' atinit'export PYENV_ROOT="$PWD"' \
    atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
    atpull"%atclone" src"zpyenv.zsh" nocompile'!' for \
        pyenv/pyenv

# nvm
if ! [ -f .nvmrc ]; then export NVM_NO_USE=true; zinit ice wait"0" lucid; fi
export NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

# better-npm
zinit ice wait"1" lucid
zinit light lukechilds/zsh-better-npm-completion

# tab-title
zinit ice wait"1" lucid
zinit light trystan2k/zsh-tab-title
ZSH_TAB_TITLE_ONLY_FOLDER=true
# ZSH_TAB_TITLE_ADDITIONAL_TERMS='alacritty'


# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:40%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

zinit ice wait"1" lucid
zinit light wookayin/fzf-fasd

# navi
zinit ice wait"1" lucid
zinit light denisidoro/navi

# thefuck
zinit ice wait"1" lucid
zinit light laggardkernel/zsh-thefuck

# # Autosuggestions & fast-syntax-highlighting
# zinit ice wait lucid atinit"zpcompinit; zpcdreplay"
# zinit light z-shell/F-Sy-H
# unset 'FAST_HIGHLIGHT[chroma-whatis]' 'FAST_HIGHLIGHT[chroma-man]'

zinit light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' \
    sindresorhus/pure \
  pick"zsh-lazyload.zsh" \
    qoomon/zsh-lazyload \
  pick"kubectl.zsh" \
    superbrothers/zsh-kubectl-prompt \


zinit lucid has'docker' for \
  as'completion' is-snippet \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \


zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      z-shell/F-Sy-H \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# zsh-autosuggestions
# zinit ice wait lucid atload"_zsh_autosuggest_start"
# zinit light zsh-users/zsh-autosuggestions

# This is a clean-room implementation of the Fish shell's history search feature
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# zdharma-continuum/history-search-multi-word. ctrl + r
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word

zstyle -e ':completion:*:*:ssh:*:my-accounts' users-hosts \
  '[[ -f ~/.ssh/config && $key = hosts ]] && key=my_hosts reply=()'

zstyle ':completion:*' menu select=1
# Fuzzy matching of completions
# https://grml.org/zsh/zsh-lovers.html
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Have the completion system announce what it is completing
zstyle ':completion:*' format 'Completing %d'

# In menu-style completion, give a status bar
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

zstyle :compinstall filename '~/.zshrc'


autoload -Uz compinit
compinit
zinit cdreplay # <- execute compdefs provided by rest of plugins
zinit cdlist # look at gathered compdefs


### OH-MY-ZSH carry-over
autoload -Uz is-at-least
# ls colors
autoload -U colors && colors

### ENVIRONMENT VARIABLES
# export BAT_CONFIG_PATH=~/bat.conf
export LSCOLORS="Gxfxcxdxbxegedabagacad"

### Homebrew requires this
export PATH="/usr/local/sbin:$PATH"
export PATH="~/bin:$PATH"

# Set Default EDITOR to neovim
EDITOR='nvim'

### ALIASES
alias cat=ccat
alias vim=nvim

### UNALIAS
# unalias rails `sc` for saucelabs
# unalias sc

### ZSH Settings
[[ -n "$WINDOW" ]] && SCREEN_NO="%B$WINDOW%b " || SCREEN_NO=""




setopt appendhistory autocd extendedglob notify
setopt promptsubst


setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
# setopt auto_cd
setopt multios
setopt prompt_subst
unsetopt correct_all
setopt interactive_comments # allow comments in interactive shells

ZSH_AUTOSUGGEST_USE_ASYNC=true
MATCH_PREV_CM=true
COMPLETION_WAITING_DOTS="true"
ENABLE_CORRECTION="true"

# 1Password
OP_BIOMETRIC_UNLOCK_ENABLED=true

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# n
# export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Bun
# [ -s "/Users/taykhan/.bun/_bun" ] && source "/Users/taykhan/.bun/_bun"
# export BUN_INSTALL="/Users/taykhan/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
# export PNPM_HOME="/Users/taykhan/Library/pnpm"
# export PATH="$PNPM_HOME:$PATH"

# tabtab source for packages
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

### CLEAR
# clear

# eval "$(kubectl completion zsh)"
source <(kubectl completion zsh)
# Set the kubectl completion code for zsh[1] to autoload on startup, doesnt work without
kubectl completion zsh > "${fpath[1]}/_kubectl" 
source <(helm completion zsh)
helm completion zsh > "${fpath[1]}/_helm" 

zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
# [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
