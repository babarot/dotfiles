# Initial {{{1
# Essential {{{2
ostype() { echo $OSTYPE | tr '[A-Z]' '[a-z]'; }
export SHELL_PLATFORM='unknown'
case "$(ostype)" in
  *'linux'*)  SHELL_PLATFORM='linux' ;;
  *'darwin'*) SHELL_PLATFORM='osx'   ;;
  *'bsd'*)    SHELL_PLATFORM='bsd'   ;;
esac
is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx()   { [[ $SHELL_PLATFORM == 'osx' ]]; }
is_bsd()   { [[ $SHELL_PLATFORM == 'bsd' || $SHELL_PLATFORM == 'osx' ]]; }

is_exist() { type $1 >/dev/null 2>&1; return $?; }

# Language
#export LANGUAGE="ja_JP.eucJP"
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# environment variables
export OS=$(uname | awk '{print tolower($1)}')
export BIN="$HOME/bin"
export PATH=$BIN:"$PATH"

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
#if [ -d $BIN ]; then
#  if ls -A1 $BIN/ | grep -q '.sh'; then
#    for f in $BIN/*.sh ; do
#      [ ! -x "$f" ] && source "$f" && echo " load $f"
#    done
#    echo ""
#    unset f
#  fi
#fi

# colors
autoload -Uz colors
colors

export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# PAGER {{{2

export PAGER=less
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESS='-f -N -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESS='-f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# EDITOR {{{2
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

alias vi=$EDITOR
alias vim=$EDITOR
# Tmux {{{2
function is_screen_running() { [ ! -z "$WINDOW" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }

function tmuxx_func()
{
  # attach to an existing tmux session, or create one if none exist
  # also set up access to the system clipboard from within tmux when possible
  #
  # e.g.
  # https://gist.github.com/1462391
  # https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard

  if ! type tmux >/dev/null 2>&1; then
    echo 'Error: tmux command not found' 2>&1
    return 1
  fi

  if [ -n "$TMUX" ]; then
    echo "Error: tmux session has been already attached" 2>&1
    return 1
  fi

  if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
    # detached session exists
    tmux attach && echo "$(tmux -V) attached session "
  else
    if [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null) ) ]]; then
      # on OS X force tmux's default command to spawn a shell in the user's namespace
      tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l /bin/zsh"'))
      #tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      tmux -f <(echo "$tmux_config") new-session \; if "test -f ~/tmux_session" "source-file ~/tmux_session" && echo "$(tmux -V) created new session supported OS X"
    else
      tmux new-session && echo "tmux created new session"
    fi
  fi
}

if ! is_screen_or_tmux_running && shell_has_started_interactively; then
  if type tmuxx >/dev/null 2>&1; then
    tmuxx
  elif type tmuxx_func >/dev/null 2>&1; then
    tmuxx_func
    #elif type tmux >/dev/null 2>&1; then
    #    if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
    #        tmux attach && echo "tmux attached session "
    #    else
    #        tmux new-session && echo "tmux created new session"
    #    fi
  elif type screen >/dev/null 2>&1; then
    screen -rx || screen -D -RR
  fi
fi
#}}}
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

# Option {{{1

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

#alias gg='nocorrect _favdir_gg'
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
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g W='| wc'
alias -g X='| xargs'

alias -s py=python

function extract() {
case $1 in
  *.tar.gz|*.tgz) tar xzvf $1;;
  *.tar.xz) tar Jxvf $1;;
  *.zip) unzip $1;;
  *.lzh) lha e $1;;
  *.tar.bz2|*.tbz) tar xjvf $1;;
  *.tar.Z) tar zxvf $1;;
  *.gz) gzip -d $1;;
  *.bz2) bzip2 -dc $1;;
  *.Z) uncompress $1;;
  *.tar) tar xvf $1;;
  *.arj) unarj $1;;
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

# Utils {{{1

# Make all bind clear
bindkey -d
# Use vim-like key binding
bindkey -v

# Escape insert-mode with jj when 'bindkey -v'
bindkey -M viins 'jj' vi-cmd-mode

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

chpwd() {
  ls_abbrev
}
ls_abbrev() {
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
function do_enter() #{{{2
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
zle -N do_enter
bindkey '^m' do_enter

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


if $is_mac; then
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
    if ! $(is_exist 'platex') || ! $(is_exist 'dvipdfmx'); then
      return 1
    fi
    platex "$1" && dvipdfmx "${1/.tex/.dvi}" && {
    echo -e "\n\033[31mCompile complete!\033[m"
  } && if $(is_exist 'open'); then
  open "${1/.tex/.pdf}"; fi
}

function poweroff() {
osascript -e "set Volume 0"
osascript -e 'tell application "Finder" to shut down'
  }
fi

# google {{{2
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
# Prompt {{{1
# L prompt {{{2
PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
function zle-line-init zle-keymap-select()
{
  case $KEYMAP in
    vicmd)
      PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
      ;;
    main|viins)
      PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
      ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

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

if [ -f ~/.bin/git-prompt.sh ]; then
  source ~/.bin/git-prompt.sh
fi
setopt TRANSIENT_RPROMPT
function precmd()
{
  touch ~/zsh_cdhist
  if [ "$PWD" != "$OLDPWD" ]; then
    OLDPWD=$PWD
    pwd >>~/zsh_cdhist
  fi

  if [ -f "$BIN"/git-prompt.sh ]; then
    RPROMPT='%{'${fg[red]}'%}'`echo $(__git_ps1 "(%s)")|sed -e s/%/%%/|sed -e s/%%%/%%/|sed -e 's/\\$/\\\\$/'`'%{'${reset_color}'%}'
    RPROMPT+=$' at %{${fg[blue]}%}[%~]%{${reset_color}%}'
  else
    RPROMPT=$'`branch-status-check` at %{${fg[blue]}%}[%~]%{${reset_color}%}'
  fi
}

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS=0

# Other prompt {{{2
SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"

# History {{{1

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
#unsetopt share_history
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

# Other {{{1
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

if [ -n "$TMUX" ]; then
  DISPLAY="$TMUX"
fi
### Complete Messages
echo -e "${BCyan}This is ZSH ${BRed}${ZSH_VERSION}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"
echo "Loading .zshrc completed!! (ZDOTDIR=${ZDOTDIR})"
echo "Now zsh version $ZSH_VERSION starting!!"

# Print log
log

# vim:fdm=marker fdc=3 ft=zsh ts=2 sw=2 sts=2:
