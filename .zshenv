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
    ~/.bun/bin(N-/) \
    ~/bin(N-/) \
    ~/.local/bin(N-/) \
    /etc/profiles/per-user/$USER/bin(N-/) \
    /run/current-system/sw/bin(N-/) \
    /nix/var/nix/profiles/default/bin(N-/) \
    /usr/local/bin(N-/) \
    /opt/homebrew/bin \
    ~/.cargo/bin(N-/) \
    ~/.tmux/bin(N-/) \
    "$path[@]" \
)

# set fpath before compinit
typeset -gx -U fpath
fpath=( \
    ~/.zsh/Completion(N-/) \
    ~/.zsh/functions(N-/) \
    ~/.zsh/plugins/zsh-completions(N-/) \
    /usr/local/share/zsh/site-functions(N-/) \
    $fpath \
)

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
    # Less status line
    export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
else
    # Nobody can answer an editor, pager or password prompt: fail fast
    # instead of hanging
    export EDITOR=true VISUAL=true GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true
    export PAGER=cat GIT_PAGER=cat BAT_PAGER=cat MANPAGER=cat
    export GIT_TERMINAL_PROMPT=0
fi
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ls command colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# declare the environment variables
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

#export WORDCHARS='*?[]~&;!#$%^(){}<>'
#export WORDCHARS='*?.[]~&;!#$%^(){}<>'
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# History file and its size
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
# The size of asking history
export LISTMAX=50
# Do not add in root
if [[ $UID == 0 ]]; then
    unset HISTFILE
    export SAVEHIST=0
fi

# fzf - command-line fuzzy finder (https://github.com/junegunn/fzf)
export FZF_DEFAULT_OPTS="--extended --ansi --multi"

# Cask
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Supply-chain cooldown: skip releases younger than 7 days
# (see also .config/uv/uv.toml)
export PINACT_MIN_AGE=7

export GOPATH=$HOME
. "$HOME/.cargo/env"
export BUN_INSTALL="$HOME/.bun"
