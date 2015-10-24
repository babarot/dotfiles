set fish_greeting ""

set fish_color_normal       normal
set fish_color_command      blue
set fish_color_quote        yellow
set fish_color_end          black
set fish_color_error        red
set fish_color_param        normal -bold
set fish_color_comment      black
set fish_color_match        green
set fish_color_search_match yellow
set fish_color_operator     yellow
set fish_color_escape       brown

#set -x PATH /opt/homebrew/bin $HOME/.rbenv/shims $HOME/.rbenv/bin $HOME/.plenv/shims $HOME/.plenv/bin /usr/bin /usr/sbin /bin /sbin
set -x PATH $HOME/bin $PATH

set -U PAGER less
set -U LESS "--LONG-PROMPT --RAW-CONTROL-CHARS"
set -U MACVIM_APP /Applications/MacVim.app/Contents/MacOS/Vim
#set -U EDITOR "reatach-to-user-namespace -l $MACVIM_APP"

function fish_prompt
  set -l last_status $status
  printf ' '
  if test $last_status -eq 0
    set_color yellow
    printf '✘╹◡╹✘'
  else
    set_color red
    printf '✘>﹏<✘'
  end
  set_color normal
  printf " < \n"
end

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_cleanstate green

function fish_right_prompt
  printf "%s " (__fish_git_prompt)
  set_color cyan
  prompt_pwd
end

alias l ls\ -AFG
alias ll ls\ -AFGl
