# Essentials {{{1
if [[ "${has_starting:=0}" == 1 ]]; then
    exit
fi
has_starting=1

# Initial {{{1
export SHELL_PLATFORM='unknown'

ostype() { echo $OSTYPE | tr '[A-Z]' '[a-z]'; }
case "$(ostype)" in
    *'linux'*)  SHELL_PLATFORM='linux' ;;
    *'darwin'*) SHELL_PLATFORM='osx'   ;;
    *'bsd'*)    SHELL_PLATFORM='bsd'   ;;
esac

is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx()   { [[ $SHELL_PLATFORM == 'osx' ]]; }
is_bsd()   { [[ $SHELL_PLATFORM == 'bsd' || $SHELL_PLATFORM == 'osx' ]]; }

is_exist() { type "$1" >/dev/null 2>&1; return $?; }
is_exists() {
    if [[ "${1[1,1]}" =~ "/" ]]; then
        if [[ -e "$1" ]]; then
            return 0
        fi
    else
        if type "$1" >/dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}
is_login_shell() { [[ "$SHLVL" == 1 ]]; }

export ZSH_PLUGUINS_DIR=~/.zsh/plugins
function has_plugin() { [[ -d ~/.zsh/plugins/"$1" ]]; }

umask 022
limit coredumpsize 0

# NOTE: set fpath before compinit
fpath=($HOME/.zsh/Completion(N-/) $fpath)
fpath=($HOME/.zsh/functions/*(N-/) $fpath)

# Mac homebrew
if is_osx; then
    fpath=(/usr/local/share/zsh/site-functions(N-/) $fpath)
fi

autoload -Uz add-zsh-hook
autoload -Uz compinit
compinit

# Environment variables {{{1
# Language
export LANGUAGE="en_US.UTF-8"
#export LANGUAGE="ja_JP.eucJP"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# environment variables
export OS=$(uname | awk '{print tolower($1)}')
export BIN="$HOME/bin"
export PATH=$BIN:$PATH
export PATH=/usr/local/vim/build/7.4/vim74/src:$PATH
export PYTHONSTARTUP=~/.pythonrc.py

# Colors
autoload -Uz colors
colors

# Correct
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# Plugins
if has_plugin 'favdir'; then
    export FAVDIR_HOME=~/Dropbox/.favdir
fi

# Color {{{2
# Normal Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC="\033[m"               # Color Reset
CR="$(echo -ne '\r')"
LF="$(echo -ne '\n')"
TAB="$(echo -ne '\t')"
ESC="$(echo -ne '\033')"

# EDITOR {{{2
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# PAGER {{{2
export PAGER=less
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
#export LESS='-f -N -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Settings for Tmux {{{1
function is_screen_running() { [ ! -z "$WINDOW" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmuxx_func()
{
    # attach to an existing tmux session, or create one if none exist
    # also set up access to the system clipboard from within tmux when possible
    #
    # e.g.
    # https://gist.github.com/1462391
    # https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard

    #if ! type tmux >/dev/null 2>&1; then
    if ! is_exists 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
    fi

    #if [ -n "$TMUX" ]; then
    if is_tmux_runnning; then
        echo "Error: tmux session has been already attached" 2>&1
        return 1
    fi

    if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux attach && echo "$(tmux -V) attached session "
    else
        #if [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null) ) ]]; then
        if is_osx && is_exist 'reattach-to-user-namespace'; then
            # on OS X force tmux's default command to spawn a shell in the user's namespace
            tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l /bin/zsh"'))
            #tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            tmux -f <(echo "$tmux_config") new-session \; if "test -f ~/tmux_session" "source-file ~/tmux_session" && echo "$(tmux -V) created new session supported OS X"
        else
            tmux new-session && echo "tmux created new session"
        fi
    fi
}

if ! is_screen_or_tmux_running && shell_has_started_interactively && ! is_ssh_running; then
    #if type tmux >/dev/null 2>&1; then
    if is_exist 'tmux'; then
        if type tmuxx >/dev/null 2>&1; then
            (SHELL=/bin/zsh; tmuxx;)
            #elif type tmuxx_func >/dev/null 2>&1; then
        elif is_exist 'tmuxx_func'; then
            tmuxx_func
            #elif type tmux >/dev/null 2>&1; then
            #    if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
            #        tmux attach && echo "tmux attached session "
            #    else
            #        tmux new-session && echo "tmux created new session"
            #    fi
        fi
        #elif type screen >/dev/null 2>&1; then
    elif is_exist 'screen'; then
        screen -rx || screen -D -RR
    fi
fi
#}}}

# Startup zsh {{{1
#
function zsh_at_startup()
{
    :
    if is_tmux_runnning; then
        DISPLAY="$TMUX"
        tmux_pane_and_window=$(tmux display -p '#I-#P')
        if is_exist 'cowsay'; then
            #cowsay -f ghostbusters "The tmux is running"
            cowsay -f ghostbusters "This is on tmux."
            #            cowsay -n -f ghostbusters <<-EOC
            #ooooooooooooo ooo        ooooo ooooo     ooo ooooooo  ooooo    
            #8'   888   \`8 \`88.       .888' \`888'     \`8'  \`8888    d8'
            #     888       888b     d'888   888       8     Y888..8P       
            #     888       8 Y88. .P  888   888       8      \`8888'       
            #     888       8  \`888'   888   888       8     .8PY888.      
            #     888       8    Y     888   \`88.    .8'    d8'  \`888b    
            #    o888o     o8o        o888o    \`YbodP'    o888o  o88888o   
            #EOC
        else
            echo "${BRed} _____ __  __ _   ___  __ ${NC}"
            echo "${BRed}|_   _|  \/  | | | \ \/ / ${NC}"
            echo "${BRed}  | | | |\/| | | | |\  /  ${NC}"
            echo "${BRed}  | | | |  | | |_| |/  \  ${NC}"
            echo "${BRed}  |_| |_|  |_|\___//_/\_\ ${NC}"
        fi
    fi

    ### Complete Messages
    echo -e "\n${BCyan}This is ZSH ${BRed}${ZSH_VERSION}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"
    #echo "Loading .zshrc completed!! (ZDOTDIR=${ZDOTDIR})"

    # Loads the file except executable one.
    test -d $BIN || mkdir -p $BIN
    if [ -d $BIN ]; then
        for f in $(echo "$BIN"/*.sh)
        do
            if [ ! -x "$f" ]; then
                source "$f" && echo " loaded $f"
            fi
            unset f
        done
        echo ""
    fi

    if [ -d ~/.zsh/plugins ];false; then
        local plugin
        local -a plugins
        #plugins=( $(find ~/.zsh/plugins -maxdepth 2 -type f -name "*sh") )
        plugins=($(find ~/.zsh/plugins -maxdepth 2 -type f \( -name "*.sh" -or -name "*.bash" -or -name "*.zsh" \) -print))

        for plugin in "${plugins[@]}"
        do
            if [ ! -x "$plugin" ]; then
                [[ "$plugin" =~ "syntax" ]] && continue
                [[ "$plugin" =~ "visual" ]] && continue
                source "$plugin" && echo " load-plugin ${plugin/$HOME/~}"
            fi
        done
        echo ""
    fi
    return 0
}
if zsh_at_startup; then
    source ~/.zsh/plugins/enhancd/enhancd.sh
    source ~/.zsh/plugins/favdir/favdir.sh
    source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    source ~/.zsh/plugins/vi-mode-visual/vi-mode-visual.sh
    source ~/.zsh/plugins/opp.zsh/opp.zsh
    #source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Utility functions {{{1
function chpwd() #{{{2
{
    ls_abbrev
}

function ls_abbrev() #{{{2
{
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac
    cmd_ls='/bin/ls'
    opt_ls=('-aCFG')

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

function ssh() #{{{2
{
    if [[ -n $(printenv TMUX) ]]; then
        local window_name=$(tmux display -p '#{window_name}')
        tmux rename-window -- "$@[-1]" # zsh specified
        # tmux rename-window -- "${!#}" # for bash
        command ssh $@
        tmux rename-window $window_name
    else
        command ssh $@
    fi
}

function show_buffer_stack() #{{{2
{
    POSTDISPLAY="
    stack: $LBUFFER"
    zle push-line-or-edit
}
zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

function pbcopy-buffer() #{{{2
{
    print -rn $BUFFER | pbcopy
    zle -M "pbcopy: ${BUFFER}"
}

zle -N pbcopy-buffer
bindkey '^x^p' pbcopy-buffer

# Utils for osx {{{2
if is_osx; then
    function op()
    {
        if [ -p /dev/stdin ]; then
            open $(cat -) "$@"
        elif [ -z "$1" ]; then
            open .
        else
            open "$@"
        fi
    }

    function tex()
    {
        if ! is_exist 'platex' || ! is_exist 'dvipdfmx'; then
            return 1
        fi
        platex "$1" && dvipdfmx "${1/.tex/.dvi}"
        if [ $? -eq 0 ]; then
            echo -e "\n\033[31mCompile complete!\033[m"
            if is_exist 'open'; then
                open "${1/.tex/.pdf}"
            fi
        fi
    }

    function poweroff()
    {
        osascript -e "set Volume 0"
        osascript -e 'tell application "Finder" to shut down'
    }
fi

# Some utils about google {{{2
function google()
{
    is_exist w3m || return 1

    local str opt
    if [ $ != 0 ]; then
        for i in $*; do
            str="$str+$i"
        done
        str=`echo $str | sed 's/^\+//'`
        opt='search?num=50&hl=ja&lr=lang_ja'
        opt="${opt}&q=${str}"
    fi
    w3m http://www.google.co.jp/$opt
}

function google_translate()
{
    is_exist w3m || return 1

    local str opt cond

    if [ $# != 0 ]; then
        str=`echo $1 | sed -e 's/  */+/g'` # 1文字以上の半角空白を+に変換
        cond=$2
        if [ $cond = "ja-en" ]; then
            # ja -> en 翻訳
            opt='?hl=ja&sl=ja&tl=en&ie=UTF-8&oe=UTF-8'
        else
            # en -> ja 翻訳
            opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
        fi
    else
        opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
    fi

    opt="${opt}&text=${str}"
    w3m +13 -dump "http://translate.google.com/${opt}"
}

function gte()
{
    google_translate "$*" "en-ja" | sed -n -e 20p
}

function gtj()
{
    google_translate "$*" "ja-en" | sed -n -e 21p
}


# Keybinds and widgets {{{1
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# widgets {{{2
kill-backward-blank-word() #{{{3
{
    zle set-mark-command
    zle vi-backward-blank-word
    zle kill-region
}
zle -N kill-backward-blank-word
bindkey '^Y' kill-backward-blank-word

peco-select-history() #{{{3
{
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle accept-line
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

peco-select-git-add() #{{{3
{
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
        peco --query "$LBUFFER" | \
        awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
        BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
        CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-git-add
bindkey "^x^g" peco-select-git-add

peco-git-recent-branches() #{{{3
{
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
        perl -pne 's{^refs/heads/}{}' | \
        peco)
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout ${selected_branch}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-git-recent-branches
bindkey "^g^b" peco-git-recent-branches

peco-dfind() #{{{3
{
    if ls -F -1 | grep -q "/$"; then
        local current_buffer=$BUFFER
        local selected_dir="$(find . -maxdepth 5 -type d ! -path "*/.*"| peco)"
        if [ -d "$selected_dir" ]; then
            BUFFER="${current_buffer} \"${selected_dir}\""
            CURSOR=$#BUFFER
            zle accept-line
        fi
        zle clear-screen
    fi
}
zle -N peco-dfind
bindkey '^z' peco-dfind

do-enter() #{{{3
{
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls_abbrev
    #if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    #    echo
    #    echo -e "\e[0;33m--- git status ---\e[0m"
    #    git status -sb 2> /dev/null
    #fi
    #call_precmd
    zle reset-prompt
    return 0
}
zle -N do-enter
bindkey '^m' do-enter

# keybinds {{{2
# Default keybinds
#bindkey -d
# Use vim-like key binding
bindkey -v

# Escape insert-mode with jj when 'bindkey -v'
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd "H" beginning-of-line
bindkey -M vicmd "L" end-of-line

# Useful key binding like emacs
bindkey "^A" beginning-of-line
bindkey "^B" backward-char
bindkey "^E" end-of-line
bindkey "^F" forward-char
bindkey "^G" send-break
bindkey "^H" backward-delete-char
bindkey "^I" expand-or-complete
bindkey "^L" clear-screen
bindkey "^M" accept-line
bindkey "^N" down-line-or-history
bindkey "^P" up-line-or-history
bindkey "^R" history-incremental-search-backward
bindkey "^U" kill-whole-line
bindkey "^W" backward-kill-word

if has_plugin 'zsh-history-substring-search'; then
    # bind P and N for EMACS mode
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down

    # bind k and j for VI mode
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down

    # bind UP and DOWN arrow keys
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # bind P and N keys
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
fi

# Shift-Tab
bindkey "^[[Z" reverse-menu-complete

#bindkey "^Q" show_buffer_stack
local p_buffer_stack=""
local -a buffer_stack_arr

function make_p_buffer_stack()
{
    if [[ ! $#buffer_stack_arr > 0 ]]; then
        p_buffer_stack=""
        return
    fi
    p_buffer_stack="%F{red}<stack:$buffer_stack_arr>%f"
}

function show_buffer_stack()
{
    local cmd_str_len=$#LBUFFER
    [[ cmd_str_len > 10 ]] && cmd_str_len=10
    buffer_stack_arr=("[$LBUFFER[1,${cmd_str_len}]]" $buffer_stack_arr)
    make_p_buffer_stack
    zle push-line-or-edit
    zle reset-prompt
}

function check_buffer_stack()
{
    [[ $#buffer_stack_arr > 0 ]] && shift buffer_stack_arr
    make_p_buffer_stack
}

zle -N show_buffer_stack
bindkey "^Q" show_buffer_stack
add-zsh-hook precmd check_buffer_stack

RPROMPT='${p_buffer_stack}'

# Prompt settings {{{1
# L prompt {{{2
PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
function zle-line-init zle-keymap-select()
{
    case $KEYMAP in
        vicmd)
        if [ "$VI_VIS_MODE" -eq 0 ]; then
            PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
        else
            PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[red]%}VIS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
        fi
            ;;
        main|viins)
            PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
            ;;
    esac
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#function zle-line-init zle-keymap-select
#{
#    EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
#    if echo $EMACS_INSERT | grep emacs > /dev/null 2>&1;then
#        EMACS_INSERT="%K{black}%F{011}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
#        VIM_NORMAL="%K{011}%F{125}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}%k%f"
#        VIM_INSERT="%K{011}%F{075}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}%k%f"
#    else
#        EMACS_INSERT="%K{black}%F{034}%k%f%K{034}%F{011} % $EMACS_INSERT %k%f"
#        VIM_NORMAL="%K{034}%F{125}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}%k%f"
#        VIM_INSERT="%K{034}%F{075}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}%k%f"
#    fi
#    #RPS1="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#    #RPS2=$RPS1
#    PROMPT="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# R prompt {{{2
setopt prompt_subst
function branch-status-check()
{
    local prefix branchname suffix
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    branchname=`get-branch-name`
    if [[ -z $branchname ]]; then
        return
    fi
    prefix=`get-branch-status`
    suffix='%{'${reset_color}'%}'
    echo ${prefix}${branchname}${suffix}
}
function get-branch-name()
{
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}
function get-branch-status()
{
    local res color
    output=`git status --short 2> /dev/null`
    if [ -z "$output" ]; then
        res=':' # status Clean
        color='%{'${fg[green]}'%}'
    elif [[ $output =~ "[\n]?\?\? " ]]; then
        res='?:' # Untracked
        color='%{'${fg[yellow]}'%}'
    elif [[ $output =~ "[\n]? M " ]]; then
        res='M:' # Modified
        color='%{'${fg[red]}'%}'
    else
        res='A:' # Added to commit
        color='%{'${fg[cyan]}'%}'
    fi
    #echo ${color}${res}'%{'${reset_color}'%}'
    echo ${color}
}

setopt transient_rprompt
function r-prompt()
{
    if [ -f $BIN/git-prompt.sh ]; then
        RPROMPT='%{'${fg[red]}'%}'`echo $(__git_ps1 "(%s)")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`'%{'${reset_color}'%}'
        RPROMPT+=$' at %{${fg[blue]}%}[%~]%{${reset_color}%}'
    else
        RPROMPT=$'`branch-status-check` at %{${fg[blue]}%}[%~]%{${reset_color}%}'
    fi
    RPROMPT+='${p_buffer_stack}'
}
add-zsh-hook precmd r-prompt

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS=0

# Other prompt {{{2
SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"

if false; then
RPROMPT=""

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


if is-at-least 4.3.10; then
    # git 用のフォーマット
    # git のときはステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
    zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then
    # git のときはフック関数を設定する

    # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    # のメッセージを設定する直前のフック関数
    # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
    # 各関数が最大3回呼び出される。
    zstyle ':vcs_info:git+set-message:*' hooks \
                                            git-hook-begin \
                                            git-untracked \
                                            git-push-status \
                                            git-nomerge-branch \
                                            git-stash-count

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
            # 0以外を返すとそれ以降のフック関数は呼び出されない
            return 1
        fi

        return 0
    }

    # untracked ファイル表示
    #
    # untracked ファイル(バージョン管理されていないファイル)がある場合は
    # unstaged (%u) に ? を表示
    function +vi-git-untracked() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if command git status --porcelain 2> /dev/null \
            | awk '{print $1}' \
            | command grep -F '??' > /dev/null 2>&1 ; then

            # unstaged (%u) に追加
            hook_com[unstaged]+='?'
        fi
    }

    # push していないコミットの件数表示
    #
    # リモートリポジトリに push していないコミットの件数を
    # pN という形式で misc (%m) に表示する
    function +vi-git-push-status() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" != "master" ]]; then
            # master ブランチでない場合は何もしない
            return 0
        fi

        # push していないコミット数を取得する
        local ahead
        ahead=$(command git rev-list origin/master..master 2>/dev/null \
            | wc -l \
            | tr -d ' ')

        if [[ "$ahead" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+="(p${ahead})"
        fi
    }

    # マージしていない件数表示
    #
    # master 以外のブランチにいる場合に、
    # 現在のブランチ上でまだ master にマージしていないコミットの件数を
    # (mN) という形式で misc (%m) に表示
    function +vi-git-nomerge-branch() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" == "master" ]]; then
            # master ブランチの場合は何もしない
            return 0
        fi

        local nomerged
        nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

        if [[ "$nomerged" -gt 0 ]] ; then
            # misc (%m) に追加
            hook_com[misc]+="(m${nomerged})"
        fi
    }


    # stash 件数表示
    #
    # stash している場合は :SN という形式で misc (%m) に表示
    function +vi-git-stash-count() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local stash
        stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
        if [[ "${stash}" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+=":S${stash}"
        fi
    }

fi

function _update_vcs_info_msg() {
    local -a messages
    local prompt

    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # vcs_info で何も取得していない場合はプロンプトを表示しない
        prompt=""
    else
        # vcs_info で情報を取得した場合
        # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
        # それぞれ緑、黄色、赤で表示する
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        # 間にスペースを入れて連結する
        prompt="${(j: :)messages}"
    fi

    RPROMPT="$prompt"
}
add-zsh-hook precmd _update_vcs_info_msg
fi

# Basic options {{{1
limit coredumpsize 0
umask 022
setopt auto_cd
setopt auto_pushd

# Do not print the directory stack after pushd or popd.
#setopt pushd_silent
# Replace 'cd -' with 'cd +'
setopt pushd_minus

# Ignore duplicates to add to pushd
setopt pushd_ignore_dups

# pushd no arg == pushd $HOME
setopt pushd_to_home

# Check spell command
setopt correct

# Check spell all
setopt correct_all

# Prohibit overwrite by redirection(> & >>) (Use >! and >>! to bypass.)
setopt no_clobber

# Deploy {a-c} -> a b c
setopt brace_ccl

# Enable 8bit
setopt print_eight_bit

# sh_word_split
setopt sh_word_split

# Change
#~$ echo 'hoge' \' 'fuga'
# to
#~$ echo 'hoge '' fuga'
setopt rc_quotes

# Case of multi redirection and pipe,
# use 'tee' and 'cat', if needed
# ~$ < file1  # cat
# ~$ < file1 < file2        # cat 2 files
# ~$ < file1 > file3        # copy file1 to file3
# ~$ < file1 > file3 | cat  # copy and put to stdout
# ~$ cat file1 > file3 > /dev/stdin  # tee
setopt multios

# Automatically delete slash complemented by supplemented by inserting a space.
setopt auto_remove_slash

# No Beep
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

# Expand '=command' as path of command
# e.g.) '=ls' -> '/bin/ls'
setopt equals

# Do not use Ctrl-s/Ctrl-q as flow control
setopt no_flow_control

# Look for a sub-directory in $PATH when the slash is included in the command
setopt path_dirs

# Show exit status if it's except zero.
setopt print_exit_value

# Show expaning and executing in what way
#setopt xtrace

# Confirm when executing 'rm *'
setopt rm_star_wait

# Let me know immediately when terminating job
setopt notify

# Show process ID
setopt long_list_jobs

# Resume when executing the same name command as suspended process name
setopt auto_resume

# Disable Ctrl-d (Use 'exit', 'logout')
#setopt ignore_eof

# Ignore case when glob
setopt no_case_glob

# Use '*, ~, ^' as regular expression
# Match without pattern
#  ex. > rm *~398
#  remove * without a file "398". For test, use "echo *~398"
setopt extended_glob

# If the path is directory, add '/' to path tail when generating path by glob
setopt mark_dirs

# Automaticall escape URL when copy and paste
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Prevent overwrite prompt from output withour cr
setopt no_prompt_cr

# Let me know mail arrival
setopt mail_warning

# History {{{2
# History file
HISTFILE=~/.zsh_history
# History size in memory
HISTSIZE=10000
# The number of histsize
SAVEHIST=1000000
# The size of asking history
LISTMAX=50
# Do not add in root
if [ $UID = 0 ]; then
    unset HISTFILE
    SAVEHIST=0
fi

# Do not record an event that was just recorded again.
setopt hist_ignore_dups

# Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_all_dups
setopt hist_save_nodups

# Expire a duplicate event first when trimming history.
setopt hist_expire_dups_first

# Do not display a previously found event.
setopt hist_find_no_dups

# Shere history
setopt share_history

# Pack extra blank
setopt hist_reduce_blanks

# Write to the history file immediately, not when the shell exits.
setopt inc_append_history

# Remove comannd of 'hostory' or 'fc -l' from history list
setopt hist_no_store

# Remove functions from history list
setopt hist_no_functions

# Record start and end time to history file
setopt extended_history

# Ignore the beginning space command to history file
setopt hist_ignore_space

# Append to history file
setopt append_history

# Edit history file during call history before executing
setopt hist_verify

# Enable history system like a Bash
setopt bang_hist

# Misc and test {{{1

autoload -Uz zmv
alias zmv='noglob zmv -W'

#local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$

# Stronger completing
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zmodload zsh/complist
autoload -Uz compinit && compinit -u
zstyle ':completion:*:default' menu select=2
#zstyle ':completion:*' menu select interactive
setopt menu_complete

zmodload zsh/complist
# "bindkey -M menuselect"設定できるようにするためのモジュールロード
bindkey -v '^a' beginning-of-line                             # 行頭へ(menuselectでは補完候補の先頭へ)
bindkey -v '^b' backward-char                                 # １文字左へ(menuselectでは補完候補1つ左へ)
bindkey -v '^e' end-of-line                                   # 行末へ(menuselectでは補完候補の最後尾へ)
bindkey -v '^f' forward-char                                  # １文字右へ(menuselectでは補完候補1つ右へ)
bindkey -v '^h' backward-delete-char                          # 1文字削除(menuselectでは絞り込みの1文字削除)
bindkey -v '^i' expand-or-complete                            # 補完開始
bindkey -M menuselect '^g' .send-break                        # send-break2回分の効果
bindkey -M menuselect '^i' forward-char                       # 補完候補1つ右へ
bindkey -M menuselect '^j' .accept-line                       # accept-line2回分の効果
bindkey -M menuselect '^k' accept-and-infer-next-history      # 次の補完メニューを表示する
bindkey -M menuselect '^n' down-line-or-history               # 補完候補1つ下へ
bindkey -M menuselect '^p' up-line-or-history                 # 補完候補1つ上へ
bindkey -M menuselect '^r' history-incremental-search-forward # 補完候補内インクリメンタルサーチ
# 補完時にhjklで選択
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char

# 名前で色を付けるようにする
autoload colors
colors

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:manuals' separate-sections true

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    autoload -Uz vcs_info
    # ここに vcs_info に関わる設定をかく
fi
REPORTTIME=3

## TEST

#declare -a plugins
#plugins=( $(find .zsh/plugins -maxdepth 1 -type f -name "*sh") )
#
#for plugin in "${plugins[@]}"
#do
#  echo $plugin
#done

# Aliases {{{1
#if $is_mac; then
#  function macvim()
#  {
#    if $(echo "$OSTYPE"  | grep -qi "darwin"); then
#      macvim_path='/Applications/MacVim.app/Contents/MacOS/Vim'
#      if [ -x "$macvim_path" ]; then
#        "$macvim_path" "$@"
#      else
#        echo "No supporting this"
#      fi
#    fi
#  }
#  #alias vi=macvim
#fi

if is_osx; then
    alias ls='/bin/ls -GF'
fi

if is_exist 'git'; then
    alias gst='git status'
fi

if is_osx; then
    if is_exist 'qlmanage'; then
        alias ql='qlmanage -p "$@" >& /dev/null'
    fi
fi

# function
if is_exist 'richpager'; then
    alias cl="richpager"
fi

# Common aliases
alias ..="cd .."
alias ld="ls -ld"          # Show info about the directory
alias lla="ls -lAF"        # Show hidden all files
alias ll="ls -lF"          # Show long file information
alias la="ls -AF"          # Show hidden files
alias lx="ls -lXB"         # Sort by extension
alias lk="ls -lSr"         # Sort by size, biggest last
alias lc="ls -ltcr"        # Sort by and show change time, most recent last
alias lu="ls -ltur"        # Sort by and show access time, most recent last
alias lt="ls -ltr"         # Sort by date, most recent last
alias lr="ls -lR"          # Recursive ls

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"

alias cp="cp -i"
alias mv="mv -i"

alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'

alias du="du -h"
alias jobs="jobs -l"
alias temp="test -e ~/temporary && command cd ~/temporary || mkdir ~/temporary && cd ~/temporary"
alias untemp="command cd $HOME && rm ~/temporary && ls"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use if colordiff exists
if is_exist 'colordiff'; then
    alias diff='colordiff -u'
else
    if [ -f "$BIN"/colordiff ]; then
        alias diff="$BIN/colordiff -u"
    else
        alias diff='diff -u'
    fi
fi

if [ -f $BIN/saferm.sh ]; then
    alias rm="$BIN/saferm.sh"
fi

# Use plain vim.
alias nvim='vim -N -u NONE -i NONE'

# The first word of each simple command, if unquoted, is checked to see 
# if it has an alias. [...] If the last character of the alias value is 
# a space or tab character, then the next command word following the 
# alias is also checked for alias expansion
alias sudo='sudo '

# Global aliases
alias -g C='| pbcopy'
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g W='| wc'
alias -g X='| xargs'

alias -s py=python

function extract()
{
    case "$1" in
        *.tar.gz|*.tgz)  tar xzvf $1;;
        *.tar.xz)        tar Jxvf $1;;
        *.zip)           unzip $1;;
        *.lzh)           lha e $1;;
        *.tar.bz2|*.tbz) tar xjvf $1;;
        *.tar.Z)         tar zxvf $1;;
        *.gz)            gzip -d $1;;
        *.bz2)           bzip2 -dc $1;;
        *.Z)             uncompress $1;;
        *.tar)           tar xvf $1;;
        *.arj)           unarj $1;;
    esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

if is_osx; then
    alias google-chrome='open -a Google\ Chrome'
else
    alias chrome='google-chrome'
fi
alias -s html=chrome

if is_osx; then
    alias eog='open -a Preview'
fi
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog

# __END__ {{{1
# Setup zsh-autosuggestions
source ~/.zsh/plugins/zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^0' autosuggest-toggle

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:
