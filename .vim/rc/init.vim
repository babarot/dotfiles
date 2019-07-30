" Tiny vim
if 0 | endif
finish

" Use plain vim
" when vim was invoked by 'sudo' command
" or, invoked as 'git difftool'
if exists('$SUDO_USER') || exists('$GIT_DIR')
  finish
endif

if &compatible
  set nocompatible
endif

let g:false = 0
let g:true  = 1

augroup MyAutoCmd
  autocmd!
augroup END

" Base functions "{{{1
function! s:glob(from, pattern)
  return split(globpath(a:from, a:pattern), "[\r\n]")
endfunction

function! s:source(from, ...)
  let found = g:false
  for pattern in a:000
    for script in s:glob(a:from, pattern)
      execute 'source' escape(script, ' ')
      let found = g:true
    endfor
  endfor
  return found
endfunction

function! s:load(...) abort
  let base = expand($HOME.'/.vim/rc')
  let found = g:true

  if len(a:000) > 0
    " Stop to load
    if index(a:000, g:false) != -1
      return g:false
    endif
    for file in a:000
      if !s:source(base, file)
        let found = s:source(base, '*[0-9]*_'.file)
      endif
    endfor
  else
    " Load all files starting with number
    let found = s:source(base, '*[0-9]*_*.vim')
  endif

  return found
endfunction
"}}}

" Init
if !s:load('config.vim')
  " Finish if loading config.vim is failed
  finish
endif

let g:config.vimrc.plugin_on = g:true
let g:config.vimrc.manage_rtp_manually = g:false
let g:config.vimrc.plugin_on = 
      \ g:config.vimrc.manage_rtp_manually == g:true
      \ ? g:false
      \ : g:config.vimrc.plugin_on

if g:config.is_starting
  scriptencoding utf-8
  set runtimepath&

  " Check if there are plugins not to be installed
  augroup vimrc-check-plug
    autocmd!
    if g:config.vimrc.check_plug_update == g:true
      autocmd VimEnter * if !argc() | call g:plug.check_installation() | endif
    endif
  augroup END

  if has('reltime')
    let g:startuptime = reltime()
    augroup vimrc-startuptime
      autocmd!
      autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
            \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
    augroup END
  endif
endif

execute 'set runtimepath^=' . fnameescape(g:config.path.rc)

call s:load('plug.vim')

call s:load('autocmd.vim')
call s:load('options.vim')
call s:load('command.vim')
call s:load('mapping.vim')

call s:load('misc.vim')
call s:load('app.vim')

" if s:load('plug.vim')
"   call s:load('custom.vim')
" endif
" call s:load('dein.vim', g:false)
" call s:load('func.vim')
" call s:load('base.vim')
" call s:load('view.vim')
" call s:load('map.vim')
" call s:load('command.vim')
" call s:load('utils.vim')
" call s:load('option.vim')
" call s:load('gui.vim', g:config.is_gui)

" Must be written at the last.  see :help 'secure'.
set secure
