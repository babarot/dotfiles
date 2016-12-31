#!/bin/zsh

# tmux_automatically_attach attachs tmux session automatically
is_ssh_running && exit 0

if is_screen_or_tmux_running; then
    if is_tmux_runnning; then
        export DISPLAY="$TMUX"
    elif is_screen_running; then
        : # For GNU screen
    fi
else
    if ! is_ssh_running; then
        if ! (( $+commands[tmux] )); then
            echo "tmux not found" 1>&2
            exit 1
        fi

        if tmux has-session &>/dev/null && tmux list-sessions | grep -qE '.*]$'; then
            # detached session exists
            tmux list-sessions | perl -pe 's/(^.*?):/\033[31m$1:\033[m/'
            printf "tmux: attach? (y/N num/session-name) "
            read
            if [[ $REPLY =~ ^[Yy]$ || $REPLY == '' ]]; then
                if tmux attach-session; then
                    echo "$(tmux -V) attached session"
                    exit 0
                fi
            elif tmux list-sessions | grep -q "^$REPLY:"; then
                if tmux attach -t "$REPLY"; then
                    echo "$(tmux -V) attached session"
                    exit 0
                fi
            fi
        fi

        if is_osx && (( $+commands[reattach-to-user-namespace] )); then
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
