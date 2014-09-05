" Essential.
syntax enable

" Colorized cursor if IME works.
if has('multi_byte_ime') || has('xim')
	highlight Cursor   guibg=NONE guifg=Yellow
	highlight CursorIM guibg=NONE guifg=Red
	set iminsert=0 imsearch=0
	inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif

" Remove all menus.
source $VIMRUNTIME/delmenu.vim

let s:is_mac = (has('mac') || has('macunix') || has('gui_macvim'))
			\ || (executable('uname') && system('uname') =~? '^darwin')

" Font.
if s:is_mac
	set guifont=Andale\ Mono:h12
endif

" Automatically save and restore window size.
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
