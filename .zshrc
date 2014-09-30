# Initial {{{1

# Language
#export LC_ALL=en_US.UTF-8
export LANGUAGE="ja_JP.eucJP"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"

# Check existing.
function is_exist()
{
	type $1 >/dev/null 2>&1; return $?;
}

# OS judgement. boolean.
typeset is_mac=$( uname | grep -qi 'darwin' && true || false )
typeset is_linux=$( uname | grep -qi 'linux' && true || false )

# environment variables
export OS=$(uname | awk '{print tolower($1)}')
export BIN="$HOME/.bin"
export PATH="$BIN:$PATH"

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
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

autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

function clipboard_vim_path()
{
	typeset -a all_path
	typeset i
	typeset clipboard_vim_path

	all_path=( `echo $PATH | tr ':' "\n" | sort | uniq` )
	for i in "${all_path[@]}"
	do
		if [ -x "$i"/vim ]; then
			vim_path+=( "$i"/vim )
		fi
	done

	for i in "${vim_path[@]}"
	do
		if "$i" --version 2>/dev/null | grep -q '+clipboard'; then
			clipboard_vim_path="$i"
			break
		fi
	done
	echo $clipboard_vim_path
}

#--------------------------------------------------------------
# Define EDITOR environment value with search().
# Use vim with compiled '+clipboard', if present.
#--------------------------------------------------------------
export EDITOR=$(clipboard_vim_path)
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"
alias vi=$EDITOR
alias vim=$EDITOR

# Option {{{1
limit coredumpsize 0
umask 022
setopt auto_cd
setopt auto_pushd
# Do not print the directory stack after pushd or popd.
# setopt pushd_silent
# cd - と cd + を入れ替える
setopt pushd_minus
# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups
# pushd 引数ナシ == pushd $HOME
setopt pushd_to_home
# コマンドのスペルチェックをする
setopt correct
# コマンドライン全てのスペルチェックをする
setopt correct_all
# > or >> を使用した上書きリダイレクトの禁止 (Use >! and >>! to bypass.)
setopt no_clobber
# Deploy {a-c} -> a b c
setopt brace_ccl

setopt print_eight_bit
# 変数に格納されたパスでcd
#setopt cdable_vars
# "~$var" でディレクトリにアクセス
#setopt auto_name_dirs
# 変数内の文字列分解のデリミタ
setopt sh_word_split

# echo 'hoge' \' 'fuga'
# echo 'hoge '' fuga'  <- これが可能になる
setopt rc_quotes

# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
#  $ < file1  # cat
#  $ < file1 < file2  # 2ファイル同時cat
#  $ < file1 > file3  # file1をfile3へコピー
#  $ < file1 > file3 | cat  # コピーしつつ標準出力にも表示
#  $ cat file1 > file3 > /dev/stdin  # tee
setopt multios

# 補完で末尾に補われた / をスペース挿入で自動的に削除
setopt auto_remove_slash
# beepを鳴らさない
setopt no_beep
setopt no_list_beep
setopt no_hist_beep
# =command を command のパス名に展開する
setopt equals
# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
# コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt path_dirs
# 戻り値が 0 以外の場合終了コードを表示する
setopt print_exit_value
# コマンドラインがどのように展開され実行されたかを表示するようになる
#setopt xtrace
# rm * 時に確認する
setopt rm_star_wait
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt notify
# jobsでプロセスIDも出力
setopt long_list_jobs
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt auto_resume
# Ctrl+D では終了しないようになる（exit, logout などを使う）
#setopt ignore_eof
#
# 実行したプロセスの消費時間が3秒以上かかったら
# 自動的に消費時間の統計情報を表示
REPORTTIME=3

# glob展開時に大文字小文字を無視
setopt no_case_glob

# *, ~, ^ の 3 文字を正規表現として扱う
# Match without pattern
#  ex. > rm *~398
#  remove * without a file "398". For test, use "echo *~398"
setopt extended_glob

# globでパスを生成したときに、パスがディレクトリだったら最後に「/」をつける。
setopt mark_dirs

# URLをコピペしたときに自動でエスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# 改行のない出力をプロンプトで上書きするのを防ぐ
setopt no_prompt_cr

# メールが届いていたら知らせる
setopt mail_warning

# Aliases {{{1
if $is_mac; then
	alias ls='/bin/ls -GF'
fi

if $(is_exist 'git'); then
	alias gst='git status'
fi

if $is_mac; then
	if $(is_exist 'qlmanage'); then
		alias ql='qlmanage -p "$@" >& /dev/null'
	fi
fi

# function
alias cl="richpager"

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
alias du="du -h"
alias jobs="jobs -l"
alias temp="test -e ~/temporary && command cd ~/temporary || mkdir ~/temporary && cd ~/temporary"
alias untemp="command cd $HOME && rm ~/temporary && ls"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use if colordiff exists
if $(is_exist 'colordiff'); then
	alias diff='colordiff -u'
else
	if [ -f ~/.bin/colordiff ]; then
		alias diff='~/.bin/colordiff -u'
	else
		alias diff='diff -u'
	fi
fi

if [ -f ~/.bin/saferm.sh ]; then
	alias rm='~/.bin/saferm.sh'
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

if [ `uname` = "Darwin" ]; then
  alias google-chrome='open -a Google\ Chrome'
else
	alias chrome='google-chrome'
fi
alias -s html=chrome

if [ `uname` = "Darwin" ]; then
  alias eog='open -a Preview'
fi
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog

# Utils {{{1
bindkey -d
bindkey -v

bindkey -M viins 'jj' vi-cmd-mode

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

# Prompt {{{1
#PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~ %# "
#PROMPT="%{${fg[blue]}%}[%n@%m] %(!.#.$) %{${reset_color}%}"
PROMPT2="%{${fg[blue]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
setopt prompt_subst
#PROMPT=%T
function branch-status-check {
    local prefix branchname suffix
        # .gitの中だから除外
        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
            return
        fi
        branchname=`get-branch-name`
        # ブランチ名が無いので除外
        if [[ -z $branchname ]]; then
            return
        fi
        prefix=`get-branch-status` #色だけ返ってくる
        suffix='%{'${reset_color}'%}'
        echo ${prefix}${branchname}${suffix}
}
function get-branch-name {
    # gitディレクトリじゃない場合のエラーは捨てます
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}
function get-branch-status {
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
        # echo ${color}${res}'%{'${reset_color}'%}'
        echo ${color} # 色だけ返す
}
#RPROMPT="$(branch-status-check) at %{${fg[blue]}%}[%~]%{${reset_color}%}"
#RPROMPT=$'`branch-status-check` %~'
RPROMPT=$'`branch-status-check` at %{${fg[blue]}%}[%~]%{${reset_color}%}'

			PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
function zle-line-init zle-keymap-select
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



# History configuration {{{1
#
HISTFILE=~/.zsh_history
HISTSIZE=10000   # メモリ内の履歴の数
SAVEHIST=1000000  # 保存される履歴の数
LISTMAX=50       # 補完リストを尋ねる数(0=ウィンドウから溢れる時は尋ねる)
# rootのコマンドはヒストリに追加しない
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
# historyの共有 (悩みどころ)
setopt share_history
#unsetopt share_history
# 余分な空白は詰める
setopt hist_reduce_blanks
# Write to the history file immediately, not when the shell exits.
setopt inc_append_history
# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
# ヒストリから関数定義を取り除く
setopt hist_no_functions
# zsh の開始・終了時刻をヒストリファイルに書き込む
setopt extended_history
# スペースで始まるコマンドはヒストリに追加しない
setopt hist_ignore_space
# 履歴を追加 (毎回 .zhistory を作らない)
setopt append_history
# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify
# !を使ったヒストリ展開を行う
setopt bang_hist

# Other {{{1
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=2

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

zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
# vim:fdm=marker fdc=3 ft=zsh ts=2 sw=2 sts=2:
