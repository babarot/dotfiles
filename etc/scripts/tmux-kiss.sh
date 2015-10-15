#!/bin/bash
# tmux kill session all

# Check if tmux session is already running
if [ -n "$TMUX" ]; then
    echo "At first, do run tmux kill-session" 1>&2
    exit 1
fi

# all sessions will be killing while s is zero
s=0
while [ "$s" = 0 ]
do
    # no output
    tmux kill-session >/dev/null 2>&1
    s=$?
done

# done
if [ $? -eq 0 ]; then
    echo "All tmux sessions are terminated!"
fi
