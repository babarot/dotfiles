function! s:vimrc_environment()
    let env = {}
    let env.is_ = {}

    let env.is_.windows = has('win16') || has('win32') || has('win64')
    let env.is_.cygwin = has('win32unix')
    let env.is_.mac = !env.is_.windows && !env.is_.cygwin
                \ && (has('mac') || has('macunix') || has('gui_macvim') ||
                \    (!executable('xdg-open') &&
                \    system('uname') =~? '^darwin'))
    let env.is_.linux = !env.is_.mac && has('unix')


    let env.is_starting = has('vim_starting')
    let env.is_gui      = has('gui_running')

    let env.hostname    = substitute(hostname(), '[^\w.]', '', '')

    " vim
    if env.is_.windows
        let vimpath = expand('~/vimfiles')
    else
        let vimpath = expand('~/.vim')
    endif

    let env.path = {
                \ 'vim': vimpath,
                \ }

    let env.bin = {
                \ 'ag': executable('ag'),
                \ 'osascript': executable('osascript'),
                \ 'open': executable('open'),
                \ 'chmod': executable('chmod'),
                \ 'qlmanage': executable('qlmanage'),
                \ }

    " tmux
    let env.is_tmux_running = !empty($TMUX)
    let env.tmux_proc = system('tmux display-message -p "#W"')

  "echo get(g:env.vimrc, 'enable_plugin', g:false)
  let env.vimrc = {
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

    return env
endfunction

" g:env is an environment variable in vimrc
let g:env = s:vimrc_environment()

function! IsWindows() abort
    return g:env.is_.windows
endfunction

function! IsMac() abort
    return g:env.is_.mac
endfunction

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
