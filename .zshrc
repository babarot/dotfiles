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
fpath=($HOME/.zsh/Completion(N-/) $fpath)
fpath=($HOME/.zsh/functions/*(N-/) $fpath)
fpath=($HOME/.zsh/plugins/zsh-completions(N-/) $fpath)
fpath=(/usr/local/share/zsh/site-functions(N-/) $fpath)

# Load modules
autoload -U run-help
autoload -Uz add-zsh-hook
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz colors; colors
autoload -Uz compinit; compinit -u
autoload -Uz history-search-end
autoload -Uz modify-current-argument
autoload -Uz smart-insert-last-word
autoload -Uz terminfo
autoload -Uz vcs_info
autoload -Uz zcalc
autoload -Uz zmv
autoload run-help-git
autoload run-help-svk
autoload run-help-svn
unalias run-help
alias help=run-help

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

# PATH
export GOPATH=$HOME
export PATH=$GOPATH/bin:/usr/local/bin/$PATH

# LS
export LSCOLORS=exfxcxdxbxegedabagacad

# Options {{{1
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

# Functions {{{1

# helper functions
get_filter() {
    if test -z "$FILTER"; then
        FILTER="fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
        export FILTER
    fi

    # Narrows the FILTER environment variables down to one
    # and sets it to the variables filter
    typeset -g filter
    filter="$(available "$FILTER")"
    if test -z "$FILTER"; then
        die '$FILTER not set'
        return 1
    elif test -z "$filter"; then
        die "$FILTER is invalid \$FILTER"
        return 1
    fi
}

ask() {
    local ans

    printf "%s [y/N]: " "$1"
    read ans
    case "$ans" in
        y|Y|yes|YES)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

zshrc_functions() {
    op() {
        if [ -p /dev/stdin ]; then
            open $(cat -) "$@"
        elif [ -z "$1" ]; then
            open .
        else
            open "$@"
        fi
    }
    is_osx || unfunction op 2>/dev/null

    tex() {
        if ! has 'platex' || ! has 'dvipdfmx'; then
            return 1
        fi
        platex "$1" && dvipdfmx "${1/.tex/.dvi}"
        if [ $? -eq 0 ]; then
            echo -e "\n\033[31mCompile complete!\033[m"
            if has 'open'; then
                open "${1/.tex/.pdf}"
            fi
        fi
    }
    is_osx || unfunction tex 2>/dev/null

    chpwd() {
        ls -F
    }

    reload() {
        local f
        f=(~/.zsh/Completion/*(.))
        unfunction $f:t 2>/dev/null
        autoload -U $f:t
    }
}

peco-src() {
    local selected_dir=$(ghq list -p | "$filter" --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

peco-select-history() {
    if true; then
        BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | "$filter" --query "$LBUFFER")

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

peco-select-path() {
        if [ "$LBUFFER" -eq "" ]; then
            if is_git_repo; then
                local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
                    "$filter" --query "$LBUFFER" | \
                    awk -F ' ' '{print $NF}')"
                if [ -n "$SELECTED_FILE_TO_ADD" ]; then
                    BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
                fi
            else
                local filepath="$(find . | grep -v '/\.' | "$filter" --prompt 'PATH>')"
                if [ -d "$filepath" ]; then
                    BUFFER="cd $filepath"
                elif [ -f "$filepath" ]; then
                    BUFFER="$EDITOR $filepath"
                fi
            fi
        else
            BUFFER="$LBUFFER$filepath"
        fi
        CURSOR=$#BUFFER
        zle clear-screen
}

peco-select-git-add() {
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
        "$filter" --query "$LBUFFER" | \
        awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
        BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
        CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}

start-tmux-if-it-is-not-already-started() {
    BUFFER='tmux'
    if has 'tmux_automatically_attach'; then
        BUFFER='tmux_automatically_attach'
    fi
    CURSOR=$#BUFFER
    zle accept-line
}

do-enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi

    if is_git_repo; then
        git status
    else
        has "gch" && gch || ls
    fi

    zle reset-prompt
}

# Aliases {{{1
zshrc_aliases()
{
    if is_osx; then
        alias ls='/bin/ls -GF'
    fi

    if has 'git'; then
        alias gst='git status'
    fi

    if is_osx && has 'qlmanage'; then
        alias ql='qlmanage -p "$@" >&/dev/null'
    fi

    if has 'richpager'; then
        alias cl='richpager'
    fi

    # Common aliases
    alias ..='cd ..'
    alias ld='ls -ld'          # Show info about the directory
    alias lla='ls -lAF'        # Show hidden all files
    alias ll='ls -lF'          # Show long file information
    alias la='ls -AF'          # Show hidden files
    alias lx='ls -lXB'         # Sort by extension
    alias lk='ls -lSr'         # Sort by size, biggest last
    alias lc='ls -ltcr'        # Sort by and show change time, most recent last
    alias lu='ls -ltur'        # Sort by and show access time, most recent last
    alias lt='ls -ltr'         # Sort by date, most recent last
    alias lr='ls -lR'          # Recursive ls

    # The ubiquitous 'll': directories first, with alphanumeric sorting:
    alias ll='ls -lv --group-directories-first'

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

# Prompt {{{1
git_prompt_internal() {
    autoload -Uz is-at-least

    if is-at-least 4.3.10; then
        autoload -Uz vcs_info
        autoload -Uz add-zsh-hook
        autoload -Uz colors

        # Exports the following three messages
        #   $vcs_info_msg_0_ : Nomarl message (green)
        #   $vcs_info_msg_1_ : Warning message (yellow)
        #   $vcs_info_msg_2_ : Error message (red)
        zstyle ':vcs_info:*' max-exports 3

        zstyle ':vcs_info:*' enable git svn hg bzr
        # Standard format (except git)
        # Replace misc(%m) with blank string normally
        zstyle ':vcs_info:*' formats '(%s)-[%b]'
        zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
        zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
        zstyle ':vcs_info:bzr:*' use-simple true


        # Format for git
        # Display whether your stage
        zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
        zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
        zstyle ':vcs_info:git:*' check-for-changes true
        #zstyle ':vcs_info:git:*' stagedstr "+"   # char of %c
        #zstyle ':vcs_info:git:*' unstagedstr "-" # char of %u
        zstyle ':vcs_info:git:*' stagedstr "+"   # char of %c
        zstyle ':vcs_info:git:*' unstagedstr "*" # char of %u

        # hooks
        if is-at-least 4.3.11; then
            # Set hook function when git
            # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
            # hook function before that set message
            # Two when the format is the case of this configuration,
            # when the actionformats is each function
            # because there are three messages will be called up to three times.
            zstyle ':vcs_info:git+set-message:*' hooks \
                git-hook-begin \
                git-untracked \
                git-push-status \
                git-nomerge-branch \
                git-stash-count

            # First hook function
            # To call the directory only hook function with working copy of git
            # (Do not call when you are in the .git directory)
            # Because of the `git status --porcelain` results in an error within .git directory
            function +vi-git-hook-begin()
            {
                if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
                    # If returns non-zero , subsequent hook function will not be called
                    return 1
                fi

                return 0
            }

            # Display untracked files
            #
            # If untracked files(Files that are not versioned) exist,
            # replace untracked(%u) with question mark(?)
            function +vi-git-untracked()
            {
                # zstyle formats,
                # to target only the second message of actionformats
                if [[ "$1" != "1" ]]; then
                    return 0
                fi

                if command git status --porcelain 2> /dev/null | awk '{print $1}' | command grep -F '??' >/dev/null 2>&1; then
                    # Add unstaged (%u)
                    #hook_com[unstaged]+='?'
                    hook_com[unstaged]+='%%'
                fi
            }

            # Display number of unpushed commits
            #
            # Replace number of unpushed commits misc (%m) in the form of pN
            function +vi-git-push-status()
            {
                # zstyle formats,
                # to target only the second message of actionformats
                if [[ "$1" != "1" ]]; then
                    return 0
                fi

                if [[ "${hook_com[branch]}" != "master" ]]; then
                    # Do nothing if not the master branch
                    return 0
                fi

                # Fetch the number of unpushed commits
                local ahead
                ahead=$(command git rev-list origin/master..master 2>/dev/null \
                    | wc -l \
                    | tr -d ' ')

                if [[ "$ahead" -gt 0 ]]; then
                    # misc (%m) に追加
                    hook_com[misc]+="(p${ahead})"
                else
                    hook_com[misc]+="(=)"
                fi
            }

            # Display the number of unmerged
            #
            # If you are in branch other than the master,
            # replace number of unmerged commits with misc (%m) in the form of mN
            function +vi-git-nomerge-branch()
            {
                # zstyle formats,
                # to target only the second message of actionformats
                if [[ "$1" != "1" ]]; then
                    return 0
                fi

                if [[ "${hook_com[branch]}" == "master" ]]; then
                    # Do nothing if not the master branch
                    return 0
                fi

                local nomerged
                nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

                if [[ "$nomerged" -gt 0 ]]; then
                    # Add misc (%m)
                    hook_com[misc]+="(m${nomerged})"
                fi
            }

            # Display the number of stashes
            #
            # If you stashed,
            # replace number of unpushed commits with misc (%m) in the form of :SN
            function +vi-git-stash-count()
            {
                # zstyle formats,
                # to target only the second message of actionformats
                if [[ "$1" != "1" ]]; then
                    return 0
                fi

                local stash
                stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
                if [[ "${stash}" -gt 0 ]]; then
                    # Add misc (%m)
                    hook_com[misc]+=":S${stash}"
                fi
            }
        fi

        function _update_vcs_info_msg()
        {
            local -a messages
            local prompt

            LANG=en_US.UTF-8 vcs_info

            if [[ -z ${vcs_info_msg_0_} ]]; then
                # Do not display the prompt if anything did not get by vcs_info
                prompt=""
            else
                # If you get the information in vcs_info
                # Put $vcs_info_msg_0_, $vcs_info_msg_1_, and $vcs_info_msg_2_,
                # into green, yellow and red, respectively
                [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
                [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
                [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

                # connected between a space
                prompt="${(j: :)messages}"
            fi

            RPROMPT="$prompt "
            RPROMPT+="at %{$fg[blue]%}[%~]%{$reset_color%}"
            RPROMPT+='${p_buffer_stack}'
        }

        add-zsh-hook precmd _update_vcs_info_msg
    fi
}

zshrc_prompt() {
    #   # 1. Prompt
    #   PROMPT='[%(?.%{${fg[green]}%}.%{${fg[red]}%})%n%{${reset_color}%}]%# '

    #   # 2. R prompt
    #   setopt prompt_subst
    #   # Automatically hidden rprompt
    #   setopt transient_rprompt

    #   if has '__git_ps1'; then
    #       function r-prompt()
    #       {
    #           export GIT_PS1_SHOWDIRTYSTATE=1
    #           export GIT_PS1_SHOWSTASHSTATE=1
    #           export GIT_PS1_SHOWUNTRACKEDFILES=1
    #           export GIT_PS1_SHOWUPSTREAM="auto"
    #           export GIT_PS1_DESCRIBE_STYLE="branch"
    #           export GIT_PS1_SHOWCOLORHINTS=0
    #           RPROMPT='%{'${fg[red]}'%}'`echo $(__git_ps1 "(%s)")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`'%{'${reset_color}'%}'
    #           RPROMPT+=$' at %{${fg[blue]}%}[%~]%{${reset_color}%}'
    #           RPROMPT+='${p_buffer_stack}'
    #       }
    #       add-zsh-hook precmd r-prompt
    #   else
    #       git_prompt_internal
    #   fi

    # New
    terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
    function _left_down_prompt_preexec () { print -rn -- $terminfo[el]; }
    add-zsh-hook preexec _left_down_prompt_preexec


    # [zsh vi mode status line](http://stackoverflow.com/questions/3622943/zsh-vi-mode-status-line)
    function zle-keymap-select zle-line-init zle-line-finish
    {
        #PROMPT_2="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --} `vcs_info_precmd`"
        case $KEYMAP in
            main)  PROMPT_2="$fg[black]-- INSERT --$reset_color $(git_prompt_internal)" ;;
            vicmd) PROMPT_2="$fg[white]-- NORMAL --$reset_color $(git_prompt_internal)" ;;
            viins) PROMPT_2="$fg[green]-- INSERT --$reset_color $(git_prompt_internal)" ;;
        esac
        PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})${HOST}%{${reset_color}%}]%# "
        zle reset-prompt
    }

    zle -N zle-line-init
    zle -N zle-line-finish
    zle -N zle-keymap-select
    zle -N edit-command-line

    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})${HOST}%{${reset_color}%}]%# "
    #PROMPT='%{$fg[blue]%}%~%{$reset_color%} %% '

    # R Prompt

    setopt prompt_subst
    # Automatically hidden rprompt
    setopt transient_rprompt

    if has '__git_ps1'; then
        function r-prompt()
        {
            export GIT_PS1_SHOWDIRTYSTATE=1
            export GIT_PS1_SHOWSTASHSTATE=1
            export GIT_PS1_SHOWUNTRACKEDFILES=1
            export GIT_PS1_SHOWUPSTREAM="auto"
            export GIT_PS1_DESCRIBE_STYLE="branch"
            export GIT_PS1_SHOWCOLORHINTS=0
            RPROMPT='%{'${fg[red]}'%}'`echo $(__git_ps1 "(%s)")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`'%{'${reset_color}'%}'
            RPROMPT+=$' at %{${fg[blue]}%}[%~]%{${reset_color}%}'
            RPROMPT+='${p_buffer_stack}'
        }
        add-zsh-hook precmd r-prompt
    else
        git_prompt_internal
        #RPROMPT='[%{$fg[blue]%}%~%{$reset_color%}]'
    fi

    # 3. Other prompt
    SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"
}

# Keybinds {{{1
zshrc_keymappings() {
    bindkey -v

    zle -N peco-select-git-add
    zle -N do-enter
    zle -N peco-select-history
    zle -N peco-select-path
    zle -N start-tmux-if-it-is-not-already-started

    if has 'autosuggest-start'; then
        zle-line-init() {
            zle autosuggest-start
        }
        zle -N zle-line-init
    fi

    # Basic asign
    bindkey '^A' beginning-of-line
    bindkey '^B' backward-char
    bindkey '^E' end-of-line
    bindkey '^F' forward-char
    bindkey '^G' send-break
    bindkey '^H' backward-delete-char
    bindkey '^I' expand-or-complete
    bindkey '^L' clear-screen
    bindkey '^M' accept-line
    bindkey '^N' down-line-or-history
    bindkey '^P' up-line-or-history
    bindkey '^R' history-incremental-search-backward
    bindkey '^U' kill-whole-line
    bindkey '^W' backward-kill-word

    # Emacs Keybindings in vi ins mode
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

    # Emacs Keybindings in vi cmd mode
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
    # alt
    bindkey -M vicmd '\ef'   forward-word
    bindkey -M vicmd '\eb'   backward-word
    bindkey -M vicmd '\ed'   kill-word

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

    # bind UP and DOWN arrow keys
    #bindkey '^[[A' history-substring-search-up
    #bindkey '^[[B' history-substring-search-down
    #${key[Up]}
    #${key[Down]}

    bindkey "^[[Z" reverse-menu-complete

    bindkey '^m' do-enter
    bindkey '^r' peco-select-history
    bindkey '^x^f' peco-select-path
    bindkey '^x^g' peco-select-git-add

    zle -N peco-src
    #bindkey '^' peco-src

    if ! is_tmux_runnning; then
        bindkey '^T' start-tmux-if-it-is-not-already-started
    fi

    bindkey -M viins 'jj' vi-cmd-mode

    # Insert a last word
    zle -N insert-last-word smart-insert-last-word
    zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
    bindkey -M viins '^]' insert-last-word

    # Surround a forward word by single quote
    _quote-previous-word-in-single() {
        modify-current-argument '${(qq)${(Q)ARG}}'
        zle vi-forward-blank-word
    }
    zle -N _quote-previous-word-in-single
    bindkey -M viins '^Q' _quote-previous-word-in-single

    # Surround a forward word by double quote
    _quote-previous-word-in-double() {
        modify-current-argument '${(qqq)${(Q)ARG}}'
        zle vi-forward-blank-word
    }
    zle -N _quote-previous-word-in-double
    bindkey -M viins '^Xq' _quote-previous-word-in-double

    bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete
}

# Completion {{{1
zshrc_completion()
{
    # cf. http://voidy21.hatenablog.jp/entry/20090902/1251918174
    setopt auto_param_slash
    setopt mark_dirs
    setopt list_types
    setopt auto_menu
    setopt auto_param_keys
    setopt interactive_comments
    setopt magic_equal_subst

    setopt complete_in_word
    setopt always_last_prompt
    setopt print_eight_bit
    setopt extended_glob
    setopt globdots

    bindkey "^I" menu-complete

    # Completing Highlighting
    autoload -U compinit
    compinit
    zstyle ':completion:*:default' menu select=2

    # Completing Selectable
    zmodload -i zsh/complist
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect '^k' accept-and-infer-next-history 

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

    #zstyle ':completion:*' completer _complete _expand _list _match _prefix
    #zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    #zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
    #zstyle ':completion:*' menu select=2
    #zstyle ':completion:*:sudo:*' command-path $sudo_path $path
    #zstyle ':completion:*' use-cache true
    #
    #zstyle ':vcs_info:*' enable git hg svn
    #zstyle ":vcs_info:*" check-for-changes true
    #zstyle ':vcs_info:*' stagedstr "+"
    #zstyle ':vcs_info:*' unstagedstr "?"
    #zstyle ':vcs_info:*' formats '%u%c%b (%s)'
    #zstyle ':vcs_info:*' actionformats '%u%c%b (%s) !%a'
}

# Disable {{{1
zshrc_misc() {
    if is_osx; then
        has "rbenv" && eval "$(rbenv init -)"
    fi
}
zsh_disable_function() {
    typeset -A aaaliases
    aaaliases=(
    "ll"    "ls"
    )

    self-insert-aa() {
        local self_insert_next
        zstyle -s ":self-insert-aa" self-insert-next self_insert_next

        local aamatch
        local aastroke
        local aacommand
        local aacontext
        local aakey

        aamatch=0
        for aastroke in "${(@k)aaaliases}"; do
            aacommand=$aaaliases[$aastroke]
            aacontext=$aastroke[0,-2]
            aakey=$aastroke[-1]

            if [[ $LBUFFER == $aacontext && $KEYS == $aakey ]]; then
                LBUFFER=$aacommand
                zle .accept-line

                aamatch=1
                break
            fi
        done

        if [[ $aamatch == 0 ]]; then
            zle "$self_insert_next"
        fi
    }

    self-insert-aa.on() {
    # Find self-insert wrapper
    # reference: knu/zsh-git-escape-magic (https://github.com/knu/zsh-git-escape-magic)
    emulate -L zsh
    local self_insert_next="${$(zle -lL | awk '$1=="zle"&&$2=="-N"&&$3=="self-insert"{print $4;exit}'):-.self-insert}"

    zle -la "$self_insert_next" || zle -N "$self_insert_next"
    zstyle ":self-insert-aa" self-insert-next "$self_insert_next"
    zle -A self-insert-aa self-insert
}
zle -N self-insert-aa
self-insert-aa.on
}

# main {{{1

# load_modules {{{2
load_modules() {
    local f

    # vitalize
    echo -e "$fg[blue]Starting $SHELL....$reset_color\n"
    if [[ -d  ~/.loading ]]; then
        for f in ~/.loading/**/*.(sh|zsh)
        do
            if [[ ! -x $f ]]; then
                source "$f" 2>/dev/null &&
                    echo "  loading $f"
            fi
            unset f
        done
        echo ""
    fi

    # failure of vitalize
    # this means that zsh cannnot initialize
    if ! vitalize 2>/dev/null; then
        echo -e "$fg[red]Cannot vitalize ...$reset_color\n"
        return 1
    fi

    [ -f ~/.path ] && source ~/.path
}

# tmux_automatically_attach {{{2
tmux_automatically_attach() {
    is_ssh_running && return

    if is_screen_or_tmux_running; then
        if is_tmux_runnning; then
            if has 'cowsay'; then
                #cowsay -f ghostbusters "$fg[blue]Starting $SHELL....$reset_color"
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
            if ! has 'tmux'; then
                echo 'Error: tmux command not found' >/dev/stderr
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

            if is_osx && has 'reattach-to-user-namespace'; then
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

# setup plugins {{{2
export ANTIGEN=~/.antigen
antigen_plugins=(
"brew"
"zsh-users/zsh-completions"
"zsh-users/zsh-history-substring-search"
"zsh-users/zsh-syntax-highlighting"
#"tarruda/zsh-autosuggestions"
"b4b4r07/enhancd"
"Tarrasch/zsh-bd"
#"b4b4r07/zsh-vi-mode-visual"
"hchbaw/opp.zsh"
"joel-porquet/zsh-dircolors-solarized"
)

setup_antigen() {
    has_plugin() {
        if [[ -n $1 ]]; then
            typeset -g -a antigen_plugins

            [[ -n ${(M)antigen_plugins:#$1} ]] ||
                [[ -n ${(M)antigen_plugins:#*/$1} ]]
        else
            return 1
        fi
    }

    ANTIGEN_NO_INSTALL=0
    if [[ ! -d $ANTIGEN ]]; then
        if ask "Do you install antigen?"; then
            git clone https://github.com/zsh-users/antigen $ANTIGEN
        fi
    fi

    if [[ -f $ANTIGEN/antigen.zsh ]]; then
        e_arrow $(e_header "Setup antigen....")
        local plugin

        source ~/.antigen/antigen.zsh
        for plugin in "${antigen_plugins[@]}"
        do
            echo "checking... $plugin" | e_indent 2
            antigen bundle "$plugin"
        done

        antigen apply &&
            e_heartful 'ready'
    else
        unfunction has_plugin 2>/dev/null
    fi
}
#}}}

zsh_at_startup() {
    if ! load_modules; then
        # If zsh can't load vital library,
        # zsh cannot work normally.
        return 1
    fi

    tmux_automatically_attach
    setup_antigen

    # Hello, Zsh!!
    # The fact that display this message means that the initialization of zsh is almost finished.
    echo -e "\n$fg_bold[cyan]This is ZSH $fg_bold[red]${ZSH_VERSION}$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n"

    zshrc_setopt

    # get_filter depends on zshrc_setopt
    get_filter
}
#}}}

if zsh_at_startup; then
    zshrc_functions
    zshrc_aliases
    zshrc_prompt
    zshrc_keymappings
    zshrc_completion
    zshrc_misc

    # declare the environment variables
    export CORRECT_IGNORE='_*'
    export CORRECT_IGNORE_FILE='.*'

    export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
    export WORDCHARS='*?.[]~&;!#$%^(){}<>'

    # History
    export HISTFILE=~/.zsh_history
    export HISTSIZE=1000000
    export SAVEHIST=1000000

    if [ -f ~/.localrc ]; then
        source ~/.localrc
    fi
fi

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:
