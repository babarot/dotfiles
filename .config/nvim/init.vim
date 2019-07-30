if 0 | endif

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
let g:true = 1

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
  let base = expand($HOME.'/.config/nvim/rc')
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

call s:load('env.vim')

let g:env.vimrc.plugin_on = g:true
let g:env.vimrc.manage_rtp_manually = g:false
let g:env.vimrc.plugin_on = 
      \ g:env.vimrc.manage_rtp_manually == g:true
      \ ? g:false
      \ : g:env.vimrc.plugin_on

if g:env.is_starting
  " Necesary for lots of cool vim things
  " http://rbtnn.hateblo.jp/entry/2014/11/30/174749

  scriptencoding utf-8
  set runtimepath&

  " Check if there are plugins not to be installed
  augroup vimrc-check-plug
    autocmd!
    if g:env.vimrc.check_plug_update == g:true
      autocmd VimEnter * if !argc() | call g:plug.check_installation() | endif
    endif
  augroup END

  " Vim starting time
  if has('reltime')
    let g:startuptime = reltime()
    augroup vimrc-startuptime
      autocmd!
      autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
            \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
    augroup END
  endif
endif

call s:load("plug.vim")

call s:load("a.vim")
call s:load("base.vim")
call s:load("command.vim")
call s:load("custom.vim")
" call s:load("dein.vim")
" call s:load("env.vim")
call s:load("func.vim")
call s:load("gui.vim")
call s:load("map.vim")
call s:load("option.vim")
call s:load("utils.vim")
call s:load("view.vim")

" Must be written at the last.  see :help 'secure'.
set secure
