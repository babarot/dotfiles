#          _              
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#                         
#

umask 022
limit coredumpsize 0
bindkey -d

# NOTE: set fpath before compinit
fpath=(~/.zsh/Completion(N-/) $fpath)
fpath=(~/.zsh/functions/*(N-/) $fpath)
fpath=(~/.zsh/plugins/zsh-completions(N-/) $fpath)
fpath=(/usr/local/share/zsh/site-functions(N-/) $fpath)

# autoload
autoload -U  run-help
autoload -Uz add-zsh-hook
autoload -Uz cdr
autoload -Uz colors; colors
autoload -Uz compinit; compinit -u
autoload -Uz is-at-least
autoload -Uz history-search-end
autoload -Uz modify-current-argument
autoload -Uz smart-insert-last-word
autoload -Uz terminfo
autoload -Uz vcs_info
autoload -Uz zcalc
autoload -Uz zmv
autoload     run-help-git
autoload     run-help-svk
autoload     run-help-svn

# It is necessary for the setting of DOTPATH
[ -f ~/.path ] && source ~/.path

# DOTPATH environment variable specifies the location of dotfiles.
# On Unix, the value is a colon-separated string. On Windows,
# it is not yet supported.
# DOTPATH must be set to run make init, make test and shell script library
# outside the standard dotfiles tree.
if [[ -z $DOTPATH ]]; then
    echo "$fg[red]cannot start ZSH, \$DOTPATH not set$reset_color" 1>&2
    return 1
fi

# Vital
# vital.sh script is most important file in this dotfiles.
# This is because it is used as installation of dotfiles chiefly and as shell
# script library vital.sh that provides most basic and important functions.
# As a matter of fact, vital.sh is a symbolic link to install, and this script
# change its behavior depending on the way to have been called.
export VITAL_PATH="$DOTPATH/etc/lib/vital.sh"
if [[ -f $VITAL_PATH ]]; then
    source "$VITAL_PATH"
fi

# Check whether the vital file is loaded
if ! vitalize 2>/dev/null; then
    echo "$fg[red]cannot vitalize$reset_color" 1>&2
    return 1
fi

# PATH
export GOPATH="$HOME"
export PATH="$GOPATH"/bin:/usr/local/bin/"$PATH"

# LANGUAGE must be set by en_US
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# Editor
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Pager
export PAGER=less
# Less status line
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# LS
export LSCOLORS=exfxcxdxbxegedabagacad

antigen=~/.antigen
antigen_plugins=(
"b4b4r07/enhancd"
"b4b4r07/tmuxlogger"
"b4b4r07/zsh-vimode-visual"
"brew"
"hchbaw/opp.zsh"
"zsh-users/zsh-completions"
"zsh-users/zsh-history-substring-search"
"zsh-users/zsh-syntax-highlighting"
)

setup_bundles() {
    echo "$fg[blue]Starting $SHELL....$reset_color"

    # ~/.modules directory
    if [[ -d ~/.modules ]]; then
        for f in ~/.modules/**/*.(sh|zsh)
        do
            # not execute files
            if [[ ! -x $f ]]; then
                source "$f" && echo "loading $f" | e_indent 2
            fi
        done

        echo ""
    fi

    # has_plugin returns true if $1 plugin are installed and available
    has_plugin() {
        if [[ -n $1 ]]; then
            [[ -n ${(M)antigen_plugins:#$1} ]] || [[ -n ${(M)antigen_plugins:#*/$1} ]]
        else
            return 1
        fi
    }

    # bundle_install installs antigen and runs bundles command
    bundle_install() {
        # require git command
        if ! has "git"; then
            echo "git: required" 1>&2
            return 1
        fi

        # install antigen
        git clone https://github.com/zsh-users/antigen $antigen

        # run bundles
        bundles
    }

    # bundles checks if antigen plugins are valid and available
    bundles() {
        if [[ -f $antigen/antigen.zsh ]]; then
            e_arrow $(e_header "Setup antigen...")
            local p

            # load antigen
            source $antigen/antigen.zsh

            # check plugins installed by antigen
            for p in ${antigen_plugins[@]}
            do
                echo "checking... $p" | e_indent 2
                antigen-bundle "$p"
            done

            # apply antigen
            antigen-apply && e_done "Ready"
        else
            echo "$fg[red]To make your shell strong, run 'bundle_install'.$reset_color"
        fi
    }

    # run bundles
    bundles
}

# tmux_automatically_attach attachs tmux session automatically
tmux_automatically_attach() {
    is_ssh_running && return 1

    if is_screen_or_tmux_running; then
        if is_tmux_runnning; then
            if has "cowsay"; then
                if [[ $(( $RANDOM % 5 )) == 1 ]]; then
                    cowsay -f ghostbusters "G,g,g,ghostbusters!!!"
                    echo ""
                fi
            else
                echo "$fg_bold[red] _____ __  __ _   ___  __ $reset_color"
                echo "$fg_bold[red]|_   _|  \/  | | | \ \/ / $reset_color"
                echo "$fg_bold[red]  | | | |\/| | | | |\  /  $reset_color"
                echo "$fg_bold[red]  | | | |  | | |_| |/  \  $reset_color"
                echo "$fg_bold[red]  |_| |_|  |_|\___//_/\_\ $reset_color"
            fi
            export DISPLAY="$TMUX"
        elif is_screen_running; then
            # For GNU screen
            :
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! has "tmux"; then
                echo "tmux not found" 1>&2
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && has "reattach-to-user-namespace"; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_login_shell="/bin/zsh"
                tmux_config=$(cat ~/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l' $tmux_login_shell'"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}

zshrc_startup() {
    # tmux_automatically_attach attachs tmux session automatically when your are in zsh
    tmux_automatically_attach
    # setup_bundles return true if antigen plugins and some modules are valid
    setup_bundles || return 1

    # Display Zsh version and display number
    echo -e "\n$fg_bold[cyan]This is ZSH $fg_bold[red]${ZSH_VERSION}$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n"
}

zshrc_keybind() {
    # Vim-like keybind as default
    bindkey -v
    # Vim-like escaping jj keybind
    bindkey -M viins 'jj' vi-cmd-mode

    # Add emacs-like keybind to viins mode
    bindkey -M viins '^F'    forward-char
    bindkey -M viins '^B'    backward-char
    bindkey -M viins '^P'    up-line-or-history
    bindkey -M viins '^N'    down-line-or-history
    bindkey -M viins '^A'    beginning-of-line
    bindkey -M viins '^E'    end-of-line
    bindkey -M viins '^K'    kill-line
    bindkey -M viins '^R'    history-incremental-pattern-search-backward
    bindkey -M viins '\er'   history-incremental-pattern-search-forward
    bindkey -M viins '^Y'    yank
    bindkey -M viins '^W'    backward-kill-word
    bindkey -M viins '^U'    backward-kill-line
    bindkey -M viins '^H'    backward-delete-char
    bindkey -M viins '^?'    backward-delete-char
    bindkey -M viins '^G'    send-break
    bindkey -M viins '^D'    delete-char-or-list

    bindkey -M vicmd '^A'    beginning-of-line
    bindkey -M vicmd '^E'    end-of-line
    bindkey -M vicmd '^K'    kill-line
    bindkey -M vicmd '^P'    up-line-or-history
    bindkey -M vicmd '^N'    down-line-or-history
    bindkey -M vicmd '^Y'    yank
    bindkey -M vicmd '^W'    backward-kill-word
    bindkey -M vicmd '^U'    backward-kill-line
    bindkey -M vicmd '/'     vi-history-search-forward
    bindkey -M vicmd '?'     vi-history-search-backward

    # Original keybind
    #
    bindkey -M vicmd 'gg' beginning-of-line
    bindkey -M vicmd 'G'  end-of-line


    if is-at-least 5.0.8; then
        autoload -Uz surround
        zle -N delete-surround surround
        zle -N change-surround surround
        zle -N add-surround surround
        bindkey -a cs change-surround
        bindkey -a ds delete-surround
        bindkey -a ys add-surround
        bindkey -a S add-surround

        #autoload -U select-bracketed
        #zle -N select-bracketed
        #for m in vivis viopp; do
        #    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        #        bindkey -M $m $c select-bracketed
        #    done
        #done

        #autoload -U select-quoted
        #zle -N select-quoted
        #for m in vivis viopp; do
        #    for c in {a,i}{\',\",\`}; do
        #        bindkey -M $m $c select-quoted
        #    done
        #done
    fi

    # Ctrl-T
    start-tmux-if-it-is-not-already-started() {
        BUFFER='tmux'
        if has 'tmux_automatically_attach'; then
            BUFFER='tmux_automatically_attach'
        fi
        CURSOR=$#BUFFER
        zle accept-line
    }
    zle -N start-tmux-if-it-is-not-already-started
    if ! is_tmux_runnning; then
        bindkey '^T' start-tmux-if-it-is-not-already-started
    fi

    # Ctrl-R
    peco-select-history() {
        if true; then
            BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | fzf --query "$LBUFFER")

            CURSOR=${#BUFFER}
            #zle accept-line
            zle clear-screen
        else
            if is-at-least 4.3.9; then
                zle -la history-incremental-pattern-search-backward && bindkey "^r" history-incremental-pattern-search-backward
            else
                history-incremental-search-backward
            fi
        fi
    }
    zle -N peco-select-history
    bindkey '^r' peco-select-history

    # Enter
    do-enter() {
        if [ -n "$BUFFER" ]; then
            zle accept-line
            return
        fi

        if is_git_repo; then
            git status
        else
            ls
        fi

        zle reset-prompt
    }
    zle -N do-enter
    bindkey '^m' do-enter

    # Plugins' keybind
    #

    # bind P and N for EMACS mode
    has 'history-substring-search-up' &&
        bindkey -M emacs '^P' history-substring-search-up
    has 'history-substring-search-down' &&
        bindkey -M emacs '^N' history-substring-search-down

    # bind k and j for VI mode
    has 'history-substring-search-up' &&
        bindkey -M vicmd 'k' history-substring-search-up
    has 'history-substring-search-down' &&
        bindkey -M vicmd 'j' history-substring-search-down

    # bind P and N keys
    has 'history-substring-search-up' &&
        bindkey '^P' history-substring-search-up
    has 'history-substring-search-down' &&
        bindkey '^N' history-substring-search-down

    # Insert a last word
    zle -N insert-last-word smart-insert-last-word
    zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
    bindkey -M viins '^]' insert-last-word

    # Surround a forward word by single quote
    quote-previous-word-in-single() {
        modify-current-argument '${(qq)${(Q)ARG}}'
        zle vi-forward-blank-word
    }
    zle -N quote-previous-word-in-single
    bindkey -M viins '^Q' quote-previous-word-in-single

    # Surround a forward word by double quote
    quote-previous-word-in-double() {
        modify-current-argument '${(qqq)${(Q)ARG}}'
        zle vi-forward-blank-word
    }
    zle -N quote-previous-word-in-double
    bindkey -M viins '^Xq' quote-previous-word-in-double

    bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete
}

zshrc_setopt()
{
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

    # History
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
}

zshrc_prompt() {
    # PROMPT
    #
    terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
    left_down_prompt_preexec() {
        print -rn -- $terminfo[el]
    }
    add-zsh-hook preexec left_down_prompt_preexec
    function zle-keymap-select zle-line-init zle-line-finish {
    case $KEYMAP in
        main|viins)
            PROMPT_2="$fg[black]-- INSERT --$reset_color"
            ;;
        vicmd)
            PROMPT_2="$fg[white]-- NORMAL --$reset_color"
            ;;
        vivis|vivli)
            PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
            ;;
        virep)
            PROMPT_2="$fg[red]-- REPLACE --$reset_color"
            ;;
    esac
    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})${HOST}%{${reset_color}%}]%# "
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})${HOST}%{${reset_color}%}]%# "

# Right PROMPT
#
setopt prompt_subst
# Automatically hidden rprompt
# however, 
setopt transient_rprompt

r-prompt() {
    if has '__git_ps1'; then
        export GIT_PS1_SHOWDIRTYSTATE=1
        export GIT_PS1_SHOWSTASHSTATE=1
        export GIT_PS1_SHOWUNTRACKEDFILES=1
        export GIT_PS1_SHOWUPSTREAM="auto"
        export GIT_PS1_DESCRIBE_STYLE="branch"
        export GIT_PS1_SHOWCOLORHINTS=0
        RPROMPT='%{'${fg[red]}'%}'`echo $(__git_ps1 "(%s)")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`'%{'${reset_color}'%}'
        RPROMPT+=$' at %{${fg[blue]}%}[%~]%{${reset_color}%}'
        RPROMPT+='${p_buffer_stack}'
    else
        RPROMPT='[%{$fg[blue]%}%~%{$reset_color%}]'
    fi
}
add-zsh-hook precmd r-prompt

# Other PROMPT
#J
SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"
}

zshrc_comp() {
    setopt auto_param_slash
    setopt list_types
    setopt auto_menu
    setopt auto_param_keys
    setopt interactive_comments
    setopt magic_equal_subst
    setopt complete_in_word
    setopt always_last_prompt
    setopt globdots

    # Important
    zstyle ':completion:*:default' menu select=2

    # Completing Groping
    zstyle ':completion:*:options' description 'yes'
    zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'
    zstyle ':completion:*' group-name ''

    # Completing misc
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
    zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
    zstyle ':completion:*' use-cache true
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

    # Directory
    zstyle ':completion:*:cd:*' ignore-parents parent pwd
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

    # default: --
    zstyle ':completion:*' list-separator '-->'
    zstyle ':completion:*:manuals' separate-sections true

    # Menu select
    zmodload -i zsh/complist
    bindkey -M menuselect '^h' vi-backward-char
    bindkey -M menuselect '^j' vi-down-line-or-history
    bindkey -M menuselect '^k' vi-up-line-or-history
    bindkey -M menuselect '^l' vi-forward-char
    #bindkey -M menuselect '^k' accept-and-infer-next-history
}

zshrc_alias() {
    # For mac, aliases
    if is_osx; then
        has "qlmanage" && alias ql='qlmanage -p "$@" >&/dev/null'
    fi

    if has 'git'; then
        alias gst='git status'
    fi

    if has 'richpager'; then
        alias cl='richpager'
    fi

    # Common aliases
    alias ..='cd ..'
    alias ld='ls -ld'          # Show info about the directory
    alias lla='ls -lAF'        # Show hidden all files
    alias ll='ls -lF'          # Show long file information
    alias l='ls -1F'          # Show long file information
    alias la='ls -AF'          # Show hidden files
    alias lx='ls -lXB'         # Sort by extension
    alias lk='ls -lSr'         # Sort by size, biggest last
    alias lc='ls -ltcr'        # Sort by and show change time, most recent last
    alias lu='ls -ltur'        # Sort by and show access time, most recent last
    alias lt='ls -ltr'         # Sort by date, most recent last
    alias lr='ls -lR'          # Recursive ls

    # The ubiquitous 'll': directories first, with alphanumeric sorting:
    #alias ll='ls -lv --group-directories-first'

    alias cp="${ZSH_VERSION:+nocorrect} cp -i"
    alias mv="${ZSH_VERSION:+nocorrect} mv -i"
    alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

    #autoload -Uz zmv
    alias zmv='noglob zmv -W'

    alias du='du -h'
    alias job='jobs -l'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Use if colordiff exists
    if has 'colordiff'; then
        alias diff='colordiff -u'
    else
        alias diff='diff -u'
    fi

    alias vi="vim"

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
}

if zshrc_startup; then
    zshrc_setopt
    zshrc_keybind
    zshrc_prompt
    zshrc_comp
    zshrc_alias
fi

# declare the environment variables
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# History file and its size
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# chpwd function is called after cd command
chpwd() {
    ls -F
}

# reload resets Completion function
reload() {
    local f
    f=(~/.zsh/Completion/*(.))
    unfunction $f:t 2>/dev/null
    autoload -U $f:t
}

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:
