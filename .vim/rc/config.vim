function! s:config()
  let config = {}
  let config.is_ = {}

  let config.is_.windows = has('win16') || has('win32') || has('win64')
  let config.is_.cygwin = has('win32unix')
  let config.is_.mac = !config.is_.windows && !config.is_.cygwin
        \ && (has('mac') || has('macunix') || has('gui_macvim') ||
        \    (!executable('xdg-open') &&
        \    system('uname') =~? '^darwin'))
  let config.is_.linux = !config.is_.mac && has('unix')

  let config.is_starting = has('vim_starting')
  let config.is_gui      = has('gui_running')
  let config.hostname    = substitute(hostname(), '[^\w.]', '', '')

  " vim
  if config.is_.windows
    let vimpath = expand('~/vimfiles')
  else
    let vimpath = expand('~/.vim')
  endif

  let config.path = {
        \ 'vim': vimpath,
        \ 'rc':  vimpath . '/rc',
        \ }

  let config.bin = {
        \ 'ag':        executable('ag'),
        \ 'osascript': executable('osascript'),
        \ 'open':      executable('open'),
        \ 'chmod':     executable('chmod'),
        \ 'qlmanage':  executable('qlmanage'),
        \ }

  " tmux
  let config.is_tmux_running = !empty($TMUX)
  let config.tmux_proc = system('tmux display-message -p "#W"')

  let config.vimrc = {
        \ 'plugin_on': g:true,
        \ 'suggest_neobundleinit': g:true,
        \ 'goback_to_eof2bof': g:false,
        \ 'save_window_position': g:true,
        \ 'restore_cursor_position': g:true,
        \ 'statusline_manually': g:true,
        \ 'add_execute_perm': g:false,
        \ 'colorize_statusline_insert': g:true,
        \ 'manage_rtp_manually': g:true,
        \ 'auto_cd_file_parentdir': g:true,
        \ 'ignore_all_settings': g:true,
        \ 'check_plug_update': g:true,
        \ }

  return config
endfunction

let g:config = s:config()

function! IsWindows() abort
  return g:config.is_.windows
endfunction

function! IsMac() abort
  return g:config.is_.mac
endfunction
