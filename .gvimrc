syntax enable

" Distinction by means of OS
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
	\ && (has('mac') || has('macunix') || has('gui_macvim') ||
	\    (!executable('xdg-open') &&
	\    system('uname') =~? '^darwin'))
let s:is_unix = !s:is_mac && has('unix')

" About Fonts
if has('win32')
	" For Windows.
	set guifont=MS_Gothic:h12:cSHIFTJIS
	set linespace=1
	if has('kaoriya')
		set ambiwidth=auto
	endif
elseif has('mac')
	" For Mac OS.
	""set guifont=Osaka－等幅:h14
	set guifont=Andale\ Mono:h12
elseif has('xfontset')
	" For UNIX.
	set guifontset=a14,r14,k14
endif

if has('win32')
	" For GVim windows, only
	set background=dark
	colorscheme solarized
endif

" Appearance {{{
source $VIMRUNTIME/delmenu.vim
""source $VIMRUNTIME/menu.vim
set langmenu=none
" The degree of transparency
"set transparency=5
" No menubar
set guioptions-=m
" No Waku
set guioptions-=C
set guioptions-=T
" No right scroolbar
set guioptions-=r
set guioptions-=R
" No left scroolbar
set guioptions-=l
set guioptions-=L
" No under scroolbar
set guioptions-=b
" Do NOT show tab
set showtabline=0
" }}}

" Share clipboard with GUI
set clipboard+=unnamed

" Store inverted words to clipboard automatically
set guioptions+=a

" Automatically save and restore window size
let g:save_window_file = expand('$HOME/.vimwinpos')
augroup SaveWindow
	autocmd!
	autocmd VimLeavePre * call s:save_window()
	function! s:save_window()
		let options = [
			\ 'set columns=' . &columns,
			\ 'set lines=' . &lines,
			\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
			\ ]
		call writefile(options, g:save_window_file)
	endfunction
augroup END
if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

" Cursor color on when IME ON
if has('multi_byte_ime') || has('xim')
	highlight Cursor guibg=NONE guifg=Yellow
	highlight CursorIM guibg=NONE guifg=Red
	set iminsert=0 imsearch=0
	if has('xim') && has('GUI_GTK')
		""set imactivatekey=s-space
	endif
	inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif

" Automatically change size when open gvim

if s:is_windows
	au GUIEnter * simalt ~x
elseif s:is_unix
	au GUIEnter * set lines=100
	au GUIEnter * set columns=300
elseif s:is_mac
	au GUIEnter * set lines=50
	au GUIEnter * set columns=150
endif
