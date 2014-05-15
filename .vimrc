"      ___                       ___           ___           ___     
"     /\__\          ___        /\__\         /\  \         /\  \    
"    /:/  /         /\  \      /::|  |       /::\  \       /::\  \   
"   /:/  /          \:\  \    /:|:|  |      /:/\:\  \     /:/\:\  \  
"  /:/__/  ___      /::\__\  /:/|:|__|__   /::\~\:\  \   /:/  \:\  \ 
"  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\ /:/\:\ \:\__\ /:/__/ \:\__\
"  |:|  |/:/  / /\/:/  /    \/__/~~/:/  / \/_|::\/:/  / \:\  \  \/__/
"  |:|__/:/  /  \::/__/           /:/  /     |:|::/  /   \:\  \      
"   \::::/__/    \:\__\          /:/  /      |:|\/__/     \:\  \     
"    ~~~~         \/__/         /:/  /       |:|  |        \:\__\    
"                               \/__/         \|__|         \/__/    

"
" Author: b4b4r07
"

set nocompatible
"set encoding
"scriptencoding utf-8

"
" OS 
"
let g:is_windows = has('win16') || has('win32') || has('win64')
let g:is_cygwin = has('win32unix')
let g:is_mac = !g:is_windows && !g:is_cygwin
	\ && (has('mac') || has('macunix') || has('gui_macvim') ||
	\    (!executable('xdg-open') &&
	\    system('uname') =~? '^darwin'))
let g:is_unix = !g:is_mac && has('unix')

"
" Use English interface.
"
if g:is_windows
	language message en "For Windows
else
	language mes C      "For Linux
endif

if g:is_windows
	set shellslash "Exchange path separator
	let $HOME=$VIM "Change home directory
endif

"
" Loading divided files
"
let g:local_vimrc = expand('~/.vimrc.local')
if filereadable(g:local_vimrc)
	execute 'source ' . g:local_vimrc
endif

let g:plugin_vimrc = expand('~/.vimrc.plugin')
if filereadable(g:plugin_vimrc)
	execute 'source ' . g:plugin_vimrc
endif

"
" FUNCTION:
" =======================================================================================
"
function! g:Date()
	return strftime("%Y/%m/%d %H:%M")
endfunction

" Function that make its directory if the directory you want to make do not exist
function! s:mkdir(file, ...)
	let f = a:0 ? fnamemodify(a:file, a:1) : a:file
	if !isdirectory(f)
		call mkdir(f, 'p')
	endif
endfunction

call s:mkdir(expand('$HOME/.vim/colors'))

" Backup automatically
set backup
if g:is_windows
	call s:mkdir(expand('$VIM/.backup'))
	set backupdir=$VIM/.backup
	set backupext=.bak
else
	set backupdir=~/.backup/vim
	set viewdir=~/.backup/view
	if has( "autocmd" )
		autocmd BufWritePre * call UpdateBackupFile()
		function! UpdateBackupFile()
			let dir = strftime("~/.backup/vim/%Y/%m/%d", localtime())
			if !isdirectory(dir)
				let retval = system("mkdir -p ".dir)
				let retval = system("chown goth:staff ".dir)
			endif
			exe "set backupdir=".dir
			unlet dir
			let ext = strftime("%H_%M_%S", localtime())
			exe "set backupext=.".ext
			unlet ext
		endfunction
	endif
endif

" Cursor appears if not movement
augroup vimrc-auto-cursorline
	autocmd!
	autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
	autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
	autocmd WinEnter * call s:auto_cursorline('WinEnter')
	autocmd WinLeave * call s:auto_cursorline('WinLeave')

	let s:cursorline_lock = 0
	function! s:auto_cursorline(event)
		if a:event ==# 'WinEnter'
			setlocal cursorline
			let s:cursorline_lock = 2
		elseif a:event ==# 'WinLeave'
			setlocal nocursorline
		elseif a:event ==# 'CursorMoved'
			if s:cursorline_lock
				if 1 < s:cursorline_lock
					let s:cursorline_lock = 1
				else
					setlocal nocursorline
					let s:cursorline_lock = 0
				endif
			endif
		elseif a:event ==# 'CursorHold'
			setlocal cursorline
			let s:cursorline_lock = 1
		endif
	endfunction
augroup END

" Restore cursor position when opening the file
function! s:RestoreCursorPostion()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
augroup vimrc_restore_cursor_position
	autocmd!
	autocmd BufWinEnter * call s:RestoreCursorPostion()
augroup END
" Automatically make directory if it does not exist when storing file {{{
augroup vimrc-auto-mkdir
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)
		if !isdirectory(a:dir) && (a:force ||
			\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction
augroup END

"
" ENCODING:
" =======================================================================================
"

set ambiwidth=double
set fileformat=unix
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8

command! -bang -bar -complete=file -nargs=? Utf8      edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932     edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc       edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16     edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be   edit<bang> ++enc=ucs-2 <args>

if has('multi_byte_ime')
	set iminsert=0 imsearch=0
endif

"
" FILES:
" =======================================================================================
"
syntax on
set number                          "Show a row"
set showmode                        "Show the current mode"
set showmatch                       "Show the matching brace and the parenthesis"
set matchtime=1                     "Set the time to view the matching parenthesis"
set title                           ""
set mousehide                       "Hide mouse pointer on insert mode"
set helpheight=999                  "Open up to fill the help screen"
set matchpairs=(:),{:},[:],<:>      "Jump to the pair with % command"
set wrap                            "Turn up at the edge of display
set textwidth=0                     "Disenable to start a new line at 80 chars"
"set foldmethod=syntax              ""
"let perl_fold=1                    ""
set foldlevel=100                   "Don't autofold anything"
set autoindent                      ""
set cindent                         "Enable indent features of the C language style"
set smartindent                     ""
set smarttab                        "Enable 'tabstop=x' (x is 1..9)"
set tabstop=4                       "Opening TAB file, show TAB as 4 blanks"
set softtabstop=4                   "Pressing TAB, convert 4 blanks to TAB"
set shiftwidth=4                    "Vim's auto indent function"
set backspace=start,eol,indent
set whichwrap=b,s,[,],,~
set nrformats=alpha,hex            "Increments alpha, hex, no octal"
set vb t_vb=                       "No beep"
set list                           "Show the invisibles"
set listchars=eol:<,tab:>.         "Invisible:eol<:tab:>..."
set wildmenu                       "Enable strong complement"
set wildmode=list,full             "List all matches without completing, then each full match"
set hidden                         "Switch the buffer without saving"
set ignorecase                     "No case sensitive"
set smartcase                      "No case sensitive without searching from a capital letter"
set hlsearch                       "Highlight search results"
"set nowrapscan                    "No loop when searching to the top of the file"
set incsearch                      "Enable incremental search"
set cursorline                     "Enable to show cursorline"

" Set filetype automatically
autocmd BufRead,BufNewFile *.md      set filetype=markdown
autocmd BufRead,BufNewFile *.func    set filetype=sh
autocmd BufRead,BufNewFile *.def     set filetype=sh
autocmd BufRead,BufNewFile .bashrc.* set filetype=sh
autocmd BufRead,BufNewFile .vimrc.*  set filetype=vim

"Useclipboardbutneed'+clipboard'
set clipboard+=unnamedplus,unnamed

"Do not insert comment when inputing newline
autocmd FileType * setlocal formatoptions-=ro

"Move current working directory automatically
autocmd BufEnter * execute ":lcd " . expand("%:p:h")

" Display a path in commandline when opening
augroup EchoFilePath
	autocmd WinEnter * execute "normal! 1\<C-g>"
augroup END


" Swap
if !isdirectory(expand('~/.swap'))
	call s:mkdir(expand('~/.swap'))
endif
set swapfile
set directory=~/.swap

"
" APPEARANCE:
"

" Colorscheme
set background=dark
if has('gui_running') && !g:is_windows
	"For MacVim, only
	colorscheme solarized
else
	" Vim for CUI
	if g:is_mac
		" Vim for mac
		colorscheme zellner
		colorscheme jellybeans
	else
		" Vim for unix
		colorscheme luinnar
	endif
endif

" Highlight zenkaku-space
if has('syntax')
	syntax enable
	function! ActivateInvisibleIndicator()
		"highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=#FF0000
		highlight ZenkakuSpace cterm=underline ctermfg=lightblue gui=underline guibg=#666666
		match ZenkakuSpace /　/
	endfunction
	augroup InvisibleIndicator
		autocmd!
		autocmd BufEnter * call ActivateInvisibleIndicator()
	augroup END
endif

"
" STATUSLINE:
" =======================================================================================
"

if !has("gui_running")
	if has('syntax')
		augroup InsertHook
			autocmd!
			autocmd InsertEnter * call s:StatusLine('Enter')
			autocmd InsertLeave * call s:StatusLine('Leave')
		augroup END
	endif
	
	let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=yellow cterm=none'
	let s:slhlcmd = ''
	function! s:StatusLine(mode)
		if a:mode == 'Enter'
			 silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
			 silent exec g:hi_insert
		else
			 highlight clear StatusLine
			 silent exec s:slhlcmd
		endif
	endfunction
	
	function! s:GetHighlight(hi)
		 redir => hl
		 exec 'highlight '.a:hi
		 redir END
		 let hl = substitute(hl, '[\r\n]', '', 'g')
		 let hl = substitute(hl, 'xxx', '', '')
		 return hl
	endfunction
	
	set laststatus=2 "Show two lines at statusline
endif

if !has("gui_running")

	""NeoBundle 'vim-scripts/buftabs'
	if isdirectory(expand('~/.vim/bundle/buftabs'))
		set statusline=%{buftabs}%=%m\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %4l/%4L,%3c\ %3p%%\ (%{g:Date()})
	else
		set statusline=[%n]%t%M%=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %4l/%4L,%3c\ %3p%%\ (%{g:Date()})
	endif
	
	highlight StatusLine cterm=none
	highlight Visual     ctermfg=Black
	
endif

"
" MAPPING:
" =======================================================================================
"

" For US keyborad mapping
if g:is_windows
	nnoremap ; :
	vnoremap ; :
elseif g:is_mac
	nnoremap ; :
	vnoremap ; :
endif

" Easy escaping
inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
onoremap jj <ESC>
inoremap j<Space> j
onoremap j<Space> j

vnoremap v $h

nnoremap <silent> <ESC><ESC> :nohls<CR>
nnoremap Y y$
nnoremap s ^
nnoremap S $
nnoremap j gj
nnoremap k gk
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap ZZ <Nop>
nnoremap <C-g> 1<C-g>
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>
nnoremap <C-q> :bdelete<CR>
nnoremap <C-w> :bdelete<CR>

inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
inoremap <C-m> <Return>
inoremap <C-i> <Tab>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ` ``<LEFT>

cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
cnoremap <C-l> <RIGHT>
cnoremap <C-h> <LEFT>
cnoremap <C-d> <DELETE>
cnoremap <C-m> <CR>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
cnoremap <C-f> <RIGHT>
cnoremap <C-b> <LEFT>
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>

nnoremap <Leader>p "0p
nnoremap <Leader>wc :%s/\i\+/&/gn<CR>
vnoremap <Leader>wc :s/\i\+/&/gn<CR>
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap HP :<C-u>help<Space><C-r><C-w><CR>
nnoremap <F4> <ESC>i<C-R>=strftime("%Y/%m/%d (%a) %H:%M")<CR><CR>
nnoremap <C-s> dd"0P
nnoremap <F5> <CR>q:
nnoremap <F6> <CR>q/
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>
nnoremap <Space>j :MRU<CR>
