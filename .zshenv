# .zshenv is read by every zsh, including the non-interactive ones AI agents
# (Claude Code, Codex, ...) use to run commands. Keep this file AI-safe:
# human-oriented settings belong in .zshrc below the is_human guard.

# Prevent /etc/zprofile from messing up PATH order
setopt no_global_rcs

XDG_CONFIG_HOME=$HOME/.config

# A human is at the keyboard only if stdin/stdout are a TTY and no known
# agent marker is set. $TERM or -o interactive can't tell: agents inherit
# TERM from the terminal and Claude Code snapshots the rc with `zsh -i`.
# Export AI_AGENT=1 to force the agent side.
is_human() {
    [[ -t 0 && -t 1 ]] || return 1
    [[ -z $CLAUDECODE$CODEX_SANDBOX$GEMINI_CLI$CURSOR_AGENT$AI_AGENT ]]
}

# Claude Code restores the PATH captured when it snapshots .zshrc,
# so every PATH entry agents need must be set here, not in .zshrc.
# Nix profiles come before Homebrew so Nix-managed tools win over
# leftover brew duplicates.
typeset -gx -U path
path=( \
    ~/.local/share/mise/shims(N-/) \
    ~/bin(N-/) \
    ~/.local/bin(N-/) \
    /etc/profiles/per-user/$USER/bin(N-/) \
    /run/current-system/sw/bin(N-/) \
    /nix/var/nix/profiles/default/bin(N-/) \
    /usr/local/bin(N-/) \
    /opt/homebrew/bin \
    "$path[@]" \
)

# set fpath before compinit
typeset -gx -U fpath
# (completions of Nix packages are added by nix-darwin's /etc/zshenv)
fpath=( \
    ~/.zsh/Completion(N-/) \
    $fpath \
)

# Tool variables from nix/home/tools/*.nix (my.env); missing until the
# first darwin-rebuild switch
[[ -r ~/.config/zsh/env.zsh ]] && source ~/.config/zsh/env.zsh

# LANGUAGE must be set by en_US
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

if is_human; then
    # Editor
    export EDITOR=vim
    export CVSEDITOR="${EDITOR}"
    export SVN_EDITOR="${EDITOR}"
    export GIT_EDITOR="${EDITOR}"

    # Pager
    export PAGER=less
else
    # Nobody can answer an editor, pager or password prompt: fail fast
    # instead of hanging
    export EDITOR=true VISUAL=true GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true
    export PAGER=cat GIT_PAGER=cat BAT_PAGER=cat MANPAGER=cat
    export GIT_TERMINAL_PROMPT=0
fi
