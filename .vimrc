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

" basic {{{1

" Necesary for lots of cool vim things
set nocompatible

" Starting time
if has('vim_starting') && has('reltime')
	let g:startuptime = reltime()
	augroup vimrc-startuptime
		autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
					\ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
	augroup END
endif

" Operating System
let g:is_windows = has('win16') || has('win32') || has('win64')
let g:is_cygwin = has('win32unix')
let g:is_mac = !g:is_windows && !g:is_cygwin
			\ && (has('mac') || has('macunix') || has('gui_macvim') ||
			\    (!executable('xdg-open') &&
			\    system('uname') =~? '^darwin'))
let g:is_unix = !g:is_mac && has('unix')

" NeoBundle {{{2
if g:is_windows
	let s:bundle_root = expand('$HOME/AppData/Roaming/vim/bundle')
else
	let s:bundle_root = expand('~/.vim/bundle')
endif
let s:neobundle_root = s:bundle_root . '/neobundle.vim'

function! s:bundled(bundle)
	if !isdirectory(s:bundle_root)
		return 0
	endif
	if stridx(&runtimepath, s:neobundle_root) == -1
		return 0
	endif

	if a:bundle ==# 'neobundle.vim'
		return 1
	else
		return neobundle#is_installed(a:bundle)
	endif
endfunction

filetype off
if has('vim_starting') && isdirectory(s:neobundle_root)
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif 

let s:noplugin = 0
if s:bundled('neobundle.vim')
	call neobundle#rc(s:bundle_root)

	" Taking care of NeoBundle by itself
	NeoBundleFetch 'Shougo/neobundle.vim'

	" NeoBundle List
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/vimproc', {
				\ 'build': {
				\ 'windows': 'make -f make_mingw32.mak',
				\ 'cygwin': 'make -f make_cygwin.mak',
				\ 'mac': 'make -f make_mac.mak',
				\ 'unix': 'make -f make_unix.mak',
				\ }
				\}
	NeoBundle 'b4b4r07/mru.vim'
	NeoBundle 'b4b4r07/buftabs'
	NeoBundle 'thinca/vim-splash'
	NeoBundle 'thinca/vim-quickrun'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'osyo-manga/vim-anzu'
	NeoBundle 'LeafCage/yankround.vim'
	NeoBundle 'junegunn/vim-easy-align'
	NeoBundle 'jiangmiao/auto-pairs'
	NeoBundle 'ujihisa/neco-look'
	NeoBundle 'tpope/vim-fugitive'
	NeoBundle 'mattn/gist-vim'
	NeoBundle 'vim-scripts/Align'
	NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
	NeoBundleLazy 'Shougo/vimshell', {
				\ 'autoload' : { 'commands' : [ 'VimShell', "VimShellPop", "VimShellInteractive" ] }
				\}
	NeoBundleLazy 'basyura/TweetVim', { 'depends' :
				\ ['basyura/twibill.vim', 'tyru/open-browser.vim'],
				\ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }}
	NeoBundleLazy 'sjl/gundo.vim', {
				\ "autoload": {"commands": ["GundoToggle"]}}
	NeoBundleLazy 'mattn/excitetranslate-vim', {
				\ 'depends': 'mattn/webapi-vim',
				\ 'autoload' : { 'commands': ['ExciteTranslate']}
				\ }
	NeoBundleLazy 'Shougo/unite-outline', {
				\ "autoload": {
				\   "unite_sources": ["outline"],
				\ }}
	NeoBundleLazy 'jnwhiteh/vim-golang',{
				\ "autoload" : {"filetypes" : ["go"]}
				\}
	NeoBundleLazy 'Shougo/neomru.vim', { 'autoload' : {
				\ 'unite_sources' : 'file_mru',
				\ }}
	NeoBundleLazy 'mattn/benchvimrc-vim', {
				\ 'autoload' : {
				\   'commands' : [
				\     'BenchVimrc'
				\   ]},
				\ }
	NeoBundle 'b4b4r07/solarized.vim', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'nanotech/jellybeans.vim', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'tomasr/molokai', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'w0ng/vim-hybrid', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'tyru/skk.vim'

	" Japanese help
	NeoBundle 'vim-jp/vimdoc-ja'

	filetype plugin indent on
	NeoBundleCheck

	" Source plugin file for NeoBundle
	let g:plugin_vimrc = expand('~/.vimrc.plugin')
	if filereadable(g:plugin_vimrc)
		execute 'source ' . g:plugin_vimrc
	endif
else
	"let s:noplugin = 1
	command! NeoBundleInit call s:neobundle_init()
	function! s:neobundle_init()
		call mkdir(s:bundle_root, 'p')
		execute 'cd' s:bundle_root
		call system('git clone git://github.com/Shougo/neobundle.vim')
		execute 'set runtimepath+=' . s:bundle_root . '/neobundle.vim'
		call neobundle#rc(s:bundle_root)
		NeoBundle 'Shougo/unite.vim'
		NeoBundle 'Shougo/vimproc', { 'build': { 'unix': 'make -f make_unix.mak', }, }
		NeoBundleInstall
		echo "Finish!"
	endfunction
	"call s:neobundle_init()
	autocmd! VimEnter * echohl WarningMsg | echo "You should do ':NeoBundleInit' at first!" | echohl None
endif

filetype plugin indent on

" }}}2

" Option settings {{{2

syntax enable

set modeline
set modelines=3
set keywordprg=:help " Open Vim internal help by K command
set helplang& helplang=ja 

set ignorecase
set smartcase
set incsearch
set hlsearch

set tabstop=4
set noexpandtab
set autoindent
set backspace=indent,eol,start
set nowrapscan
set showmatch
set matchtime=1
set matchpairs+=<:>
set wildmenu
set wildmode=longest,full
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store
set shiftwidth=4
set smartindent
set smarttab
set whichwrap=b,s,h,l,<,>,[,]
set hidden
set textwidth=0
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set formatoptions-=v
set formatoptions+=l
set number
set ruler
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<
set listchars=eol:<,tab:>.
set t_Co=256
set nrformats=alpha,hex
set winaltkeys=no
set visualbell
set vb t_vb=
set noequalalways

set nowrap
set laststatus=2
set cmdheight=2
set showcmd
set title
set lines=50
set previewheight=10
set helpheight=999
set mousehide
set virtualedit=block

set foldenable
"set foldmethod=marker
"set foldopen=all
"set foldclose=all
set foldlevel=0
set foldnestmax=2
set foldcolumn=2

if has('clipboard')
	set clipboard=unnamed
endif

" Function that make its directory if the directory you want to make do not exist
function! s:mkdir(file, ...)
	let f = a:0 ? fnamemodify(a:file, a:1) : a:file
	if !isdirectory(f)
		call mkdir(f, 'p')
	endif
endfunction
call s:mkdir(expand('$HOME/.vim/colors'))

" Backup automatically {{{
set backup
if g:is_windows
	call s:mkdir(expand('$VIM/.backup'))
	set backupdir=$VIM/.backup
	set backupext=.bak
else
	set backupdir=~/.backup/vim
	set viewdir=~/.backup/view
	if has('autocmd')
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
" }}}

" Swap settings {{{
if !isdirectory(expand('~/.swap'))
	call s:mkdir(expand('~/.swap'))
endif
set swapfile
set directory=~/.swap
" }}}

function! s:mkdir(file, ...) "{{{
	let f = a:0 ? fnamemodify(a:file, a:1) : a:file
	if !isdirectory(f)
		call mkdir(f, 'p')
	endif
endfunction
" }}}
call s:mkdir(expand('$HOME/.vim/colors'))

" Encode {{{
if has('gui_running')
	set encoding=utf-8
endif
scriptencoding cp932

set fileformat=unix
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8

command! -bang -bar -complete=file -nargs=? Sjis      edit<bang> ++enc=sjis <args>
command! -bang -bar -complete=file -nargs=? Utf8      edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932     edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc       edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16     edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be   edit<bang> ++enc=ucs-2 <args>

if has('multi_byte_ime')
	set iminsert=0 imsearch=0
endif

if exists('&ambiwidth')
	set ambiwidth=double
endif
" }}}

" Initialize autocmd
augroup MyAutoCmd
	autocmd!
augroup END

" Always only one window when opening files
augroup MyAutoCmd
	autocmd BufRead * execute ":only"
augroup END

"Move current working directory automatically
augroup MyAutoCmd
	"autocmd BufRead,BufEnter * lcd %:p:h
	autocmd BufRead,BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

" Display a path in commandline when opening
augroup MyAutoCmd
	autocmd WinEnter * execute "normal! 1\<C-g>"
augroup END

"Do not insert comment when inputing newline
augroup MyAutoCmd
	autocmd FileType * setlocal formatoptions-=ro
augroup END

augroup MyAutoCmd
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)
		if !isdirectory(a:dir) && (a:force ||
					\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction
augroup END

" highlight cursorline and cursorcolumn only current window
augroup MyAutoCmd
	autocmd BufWinEnter,WinEnter * setlocal cursorline cursorcolumn
	autocmd BufWinLeave,WinLeave * setlocal nocursorline nocursorcolumn
augroup END

" }}}2

" Appearance {{{2

" Change some neccesary settings for win
if g:is_windows
	set shellslash "Exchange path separator
	let $HOME=$VIM "Change home directory
endif

" TMUX Cursor
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Use English interface
if g:is_windows
	language message en
else
	language mes C
endif

" Colorscheme
set t_ut=
set t_Co=256
set background=dark
if has('gui_running') && !g:is_windows
	" For MacVim, only
	if s:bundled('solarized.vim')
		colorscheme solarized
	endif
else
	" Vim for CUI
	if s:bundled('solarized.vim')
		colorscheme solarized
	elseif s:bundled('vim-hybrid')
		colorscheme hybrid
	elseif s:bundled('jellybeans.vim')
		colorscheme jellybeans
	else
		colorscheme desert
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
	augroup MyAutoCmd
		autocmd BufEnter * call ActivateInvisibleIndicator()
	augroup END
endif

" Restore cursor position
function! s:RestoreCursorPostion()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
augroup MyAutoCmd
	autocmd BufWinEnter * call s:RestoreCursorPostion()
augroup END

" CursorColumn appears if it does'nt move
augroup MyAutoCmd
	autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorcolumn
	autocmd CursorHold,CursorHoldI * setlocal cursorcolumn
augroup END
"augroup MyAutoCmd
"	autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
"	autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
"	autocmd WinEnter * call s:auto_cursorline('WinEnter')
"	autocmd WinLeave * call s:auto_cursorline('WinLeave')
"
"	let s:cursorline_lock = 0
"	function! s:auto_cursorline(event)
"		if a:event ==# 'WinEnter'
"			setlocal cursorline
"			let s:cursorline_lock = 2
"		elseif a:event ==# 'WinLeave'
"			setlocal nocursorline
"		elseif a:event ==# 'CursorMoved'
"			if s:cursorline_lock
"				if 1 < s:cursorline_lock
"					let s:cursorline_lock = 1
"				else
"					"setlocal nocursorline
"					setlocal nocursorcolumn
"					let s:cursorline_lock = 0
"				endif
"			endif
"		elseif a:event ==# 'CursorHold'
"			"setlocal cursorline
"			setlocal cursorcolumn
"			let s:cursorline_lock = 1
"		endif
"	endfunction
"augroup END

set cursorline
"set cursorcolumn
"set colorcolumn=80

" Change CursorLine color
augroup MyAutoCmd
	autocmd InsertEnter * highlight CursorLine ctermfg=236 ctermbg=24               | highlight CursorColumn ctermfg=236 ctermbg=24
	autocmd InsertLeave * highlight CursorLine ctermbg=236 ctermfg=24 guibg=#303030 | highlight CursorColumn ctermbg=236 ctermfg=24 guibg=#303030
augroup END

highlight StatusLine ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none
highlight Visual     term=reverse cterm=reverse ctermfg=darkyellow ctermbg=black

" Yellow statusline at Insert mode
if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let g:hi_insert = 'highlight StatusLine guifg=black guibg=darkyellow gui=none ctermfg=black ctermbg=yellow cterm=none'
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

" Show two lines at statusline
set laststatus=2
"set statusline=[%n]%t%M%=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %4l/%4L,%3c\ %3p%%\ (%{g:Date()})
set statusline=[%n]%t%M%=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
set statusline+=\ %4l/%4L,%3c\ %3p%%
set statusline+=\ [WC=%{exists('*WordCount')?WordCount():[]}]
set statusline+=\ (%{g:Date()})
function! g:Date()
	return strftime("%Y/%m/%d %H:%M")
endfunction

" }}}2

" Tab pages {{{2
if v:version >= 700
	" Anywhere SID.
	function! s:SID_PREFIX()
		return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
	endfunction

	" Set tabline.
	function! s:my_tabline()  "{{{
		let s = ''
		for i in range(1, tabpagenr('$'))
			let bufnrs = tabpagebuflist(i)
			let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
			let no = i  " display 0-origin tabpagenr.
			let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
			let title = fnamemodify(bufname(bufnr), ':t')
			let title = '[' . title . ']'
			let s .= '%'.i.'T'
			let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
			let s .= no . ':' . title
			let s .= mod
			let s .= '%#TabLineFill# '
		endfor
		let s .= '%#TabLineFill#%T%=%#TabLine#'
		return s
	endfunction "}}}
	let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
	set showtabline=2

	" The prefix key.
	nnoremap [Tag] <Nop>
	nmap T [Tag]

	for n in range(1, 9)
		execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
	endfor

	map <silent> [Tag]c :tablast <bar> tabnew<CR>
	map <silent> [Tag]x :tabclose<CR>
	map <silent> [Tag]n :tabnext<CR>
	map <silent> [Tag]p :tabprevious<CR>
	nnoremap <silent> tc :tablast <bar> tabnew<CR>
	nnoremap <silent> tx :tabclose<CR>
	nnoremap <silent> tn :tabnext<CR>
	nnoremap <silent> tp :tabprevious<CR>
endif

" kana's useful tab function {{{
function! s:move_window_into_tab_page(target_tabpagenr)
	" Move the current window into a:target_tabpagenr.
	" If a:target_tabpagenr is 0, move into new tab page.
	if a:target_tabpagenr < 0  " ignore invalid number.
		return
	endif
	let original_tabnr = tabpagenr()
	let target_bufnr = bufnr('')
	let window_view = winsaveview()

	if a:target_tabpagenr == 0
		tabnew
		tabmove  " Move new tabpage at the last.
		execute target_bufnr 'buffer'
		let target_tabpagenr = tabpagenr()
	else
		execute a:target_tabpagenr 'tabnext'
		let target_tabpagenr = a:target_tabpagenr
		topleft new  " FIXME: be customizable?
		execute target_bufnr 'buffer'
	endif
	call winrestview(window_view)

	execute original_tabnr 'tabnext'
	if 1 < winnr('$')
		close
	else
		enew
	endif

	execute target_tabpagenr 'tabnext'
endfunction " }}}

" move current buffer into a new tab.
nnoremap <silent> <C-w><C-t> :<C-u>call <SID>move_window_into_tab_page(0)<CR>
nnoremap <silent> <C-w>t     :<C-u>call <SID>move_window_into_tab_page(0)<CR>

" }}}2

" Key map {{{2

let mapleader = ","
let maplocalleader = ","

" swap ; and :
nnoremap ; :
vnoremap ; :
nnoremap q; q:
vnoremap q; q:
nnoremap : ;
vnoremap : ;

" Easy escaping
inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
onoremap jj <ESC>
inoremap j<Space> j
onoremap j<Space> j

" switch j,k and gj,gk
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k
function! Up(key)
	if line(".") == 1
		return ":call cursor(line('$'), col('.'))\<CR>"
	else
		return a:key
	endif
endfunction
function! Down(key)
	if line(".") == line("$")
		return ":call cursor(1, col('.'))\<CR>"
	else
		return a:key
	endif
endfunction
nnoremap <expr><silent> k Up("gk")
nnoremap <expr><silent> j Down("gj")

" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap <Space>h ^
noremap <Space>l $

" Type 'v', select end of line in visual mode
vnoremap v $h

" virtual replace mode
nnoremap R gR

nnoremap <silent> <ESC><ESC> :nohls<CR>
nnoremap Y y$
nnoremap <Space>h  ^
nnoremap <Space>l  $
""nnoremap n nzz
""nnoremap N Nzz
nnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
nnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
vnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
vnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'

function! s:search_forward_p()
	return exists('v:searchforward') ? v:searchforward : 1
endfunction

nnoremap <Space>/  *<C-o>
nnoremap g<Space>/ g*<C-o>
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q gq

noremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
"nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>

" Buffer and Tab
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>
nnoremap <C-q> :bdelete<CR>
nnoremap <silent> tt  :<C-u>tabe<CR>
"nnoremap <C-p>  gT
"nnoremap <C-n>  gt

inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ` ``<LEFT>

" Cursor like Emacs
inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
inoremap <C-m> <Return>
inoremap <C-i> <Tab>
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
nnoremap <C-g> 1<C-g>
nnoremap gs :<C-u>%s///g<Left><Left><Left>
vnoremap gs :s///g<Left><Left><Left>
nnoremap HP :<C-u>help<Space><C-r><C-w><CR>

" Disable features
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" Window split
nnoremap s <Nop>
nnoremap sp <C-u>:split<CR>
nnoremap vs <C-u>:vsplit<CR>
nnoremap ss <C-w>w
nnoremap S <C-w>w
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h

" edit vimrc
if has('gui')
	nnoremap <silent> <Space>.   :<C-u>execute 'tab drop ' . escape(resolve($MYVIMRC), ' ')<CR>
else
	nnoremap <silent> <Space>.   :<C-u>execute 'tabe ' . escape(resolve($MYVIMRC), ' ')<CR>
endif

" swap gf and gF
noremap gf gF
noremap gF gf

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" }}}2

" Functions {{{2

" Count Char
function! s:CountChar(c) "{{{
	let line = getline('.')
	let match = stridx(line, a:c)
	let cnt = 0
	while match != -1
		let cnt = cnt + 1
		let match = stridx(line, a:c, match + 1)
	endwhile

	echo cnt . " '" . a:c . "' in current line."
endfunction "}}}
command! -nargs=1 CountChar call s:CountChar(<f-args>)

augroup MyAutoCmd
	autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...) "{{{
	if a:0 == 0
		return s:WordCountStr
	endif
	let cidx = 3
	silent! let cidx = s:WordCountDict[a:1]
	let s:WordCountStr = ''
	let s:saved_status = v:statusmsg
	exec "silent normal! g\<c-g>"
	if v:statusmsg !~ '^--'
		let str = ''
		silent! let str = split(v:statusmsg, ';')[cidx]
		let cur = str2nr(matchstr(str, '\d\+'))
		let end = str2nr(matchstr(str, '\d\+\s*$'))
		if a:1 == 'char'
			let cr = &ff == 'dos' ? 2 : 1
			let cur -= cr * (line('.') - 1)
			let end -= cr * line('$')
		endif
		let s:WordCountStr = printf('%d/%d', cur, end)
		let s:WordCountStr = printf('%d', end)
	endif
	let v:statusmsg = s:saved_status
	return s:WordCountStr
endfunction "}}}

" }}}2

" }}}1

" plugins {{{1

" mru.vim {{{2
if s:bundled('mru.vim')
	let MRU_Use_Alt_useopen = 1         "Open MRU by line number
	let MRU_Window_Height   = 15
	let MRU_Max_Entries     = 100
	let MRU_Use_CursorLine  = 1
	nnoremap <silent><Space>j :MRU<CR>
endif
" }}}2

" unite.vim {{{2
if s:bundled('unite.vim')
	let g:unite_winwidth                   = 40
	let g:unite_source_file_mru_limit      = 300
	let g:unite_enable_start_insert        = 0            "off is zero
	let g:unite_enable_split_vertically    = 0
	let g:unite_source_history_yank_enable = 1            "enable history/yank
	let g:unite_source_file_mru_filename_format  = ''
	let g:unite_kind_jump_list_after_jump_scroll = 0
	"nnoremap <silent><Space>j :Unite file_mru -direction=botright -toggle<CR>
	"nnoremap <silent><Space>o :Unite outline  -direction=botright -toggle<CR>
	let g:unite_split_rule = 'botright'
	nnoremap <silent><Space>o :Unite outline -vertical -winwidth=40 -toggle<CR>
	"nnoremap <silent><Space>o :Unite outline -vertical -no-quit -winwidth=40 -toggle<CR>
endif
" }}}

" neocomplete.vim {{{2
if s:bundled('neocomplete')
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#disable_auto_complete = 0
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case = 1
	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif s:bundled('neocomplcache')
	let g:neocomplcache_enable_at_startup = 1
	let g:Neocomplcache_disable_auto_complete = 0
	let g:neocomplcache_enable_ignore_case = 1
	let g:neocomplcache_enable_smart_case = 1
	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns._ = '\h\w*'
	let g:neocomplcache_enable_camel_case_completion = 1
	let g:neocomplcache_enable_underbar_completion = 1
endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

highlight Pmenu      ctermbg=lightcyan ctermfg=black
highlight PmenuSel   ctermbg=blue      ctermfg=black
highlight PmenuSbari ctermbg=darkgray
highlight PmenuThumb ctermbg=lightgray
" }}}2

" buftabs.vim {{{2
"if exists("g:buftabs_enabled")
"	set statusline=%{buftabs}%=%m\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %4l/%4L,%3c\ %3p%%\ (%{g:Date()})
"else
"	set statusline=[%n]%t%M%=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %4l/%4L,%3c\ %3p%%\ (%{g:Date()})
"endif
if s:bundled('buftabs')
	set statusline=%{buftabs}%=%m\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
	set statusline+=\ %4l/%4L,%3c\ %3p%%
	set statusline+=\ [WC=%{exists('*WordCount')?WordCount():[]}]
	set statusline+=\ (%{g:Date()})

	let w:buftabs_enabled         = 0
	let g:buftabs_only_basename   = 1
	let g:buftabs_in_statusline   = 1
	let g:buftabs_marker_start    = "["
	let g:buftabs_marker_end      = "]"
	let g:buftabs_separator       = "#"
	let g:buftabs_marker_modified = "+"
	let g:buftabs_active_highlight_group = "Visual"
	let w:original_statusline = matchstr(&statusline, "%=.*")
	
	if &diff
		finish
	endif
	
	function! Buftabs_enable()
		let w:buftabs_enabled = 1
	endfunction
	
	let s:Pecho=''
	function! s:Pecho(msg)
		if &ut!=1|let s:hold_ut=&ut|let &ut=1|en
		let s:Pecho=a:msg
		aug Pecho
			au CursorHold * if s:Pecho!=''|echo s:Pecho
						\|let s:Pecho=''|let &ut=s:hold_ut|en
					\|aug Pecho|exe 'au!'|aug END|aug! Pecho
		aug END
	endf
	
	function! Buftabs_show(deleted_buf)
		let l:i = 1
		let s:list = ''
		let l:start = 0
		let l:end = 0
		if ! exists("w:from") 
			let w:from = 0
		endif
	
		"if ! exists("w:buftabs_enabled")
	endfunction
endif
" }}}2

" splash.vim {{{2
if s:bundled('vim-splash')
	"let g:loaded_splash = 1
	let s:vim_intro = $HOME . "/.vim/bundle/vim-splash/sample/intro"
	if !isdirectory(s:vim_intro)
		call mkdir(s:vim_intro, 'p')
		execute ":lcd " . s:vim_intro . "/.."
		call system('git clone https://gist.github.com/OrgaChem/7630711 intro')
	endif
	let g:splash#path = expand(s:vim_intro . '/vim_intro.txt')
endif
" }}}2

" vim-anzu {{{2
if s:bundled('vim-anzu')
	"nmap n <Plug>(anzu-n-with-echo)
	"nmap N <Plug>(anzu-N-with-echo)
	"nmap * <Plug>(anzu-star-with-echo)
	"nmap # <Plug>(anzu-sharp-with-echo)
	nmap n <Plug>(anzu-mode-n)
	nmap N <Plug>(anzu-mode-N)
endif
" }}}2

" yankround.vim {{{2
if s:bundled('yankround.vim')
	nmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap <C-p> <Plug>(yankround-prev)
	nmap <C-n> <Plug>(yankround-next)
	let g:yankround_max_history = 50
	nnoremap <Space>k :Unite yankround -direction=botright -toggle<CR>
endif
" }}}2

" vim-gist {{{2
if s:bundled('gist-vim')
	let g:github_user = 'b4b4r07'
	let g:github_token = '0417d1aeeb1016c444c5'
	let g:gist_curl_options = "-k"
	let g:gist_detect_filetype = 1
endif
" }}}2

" excitetranslate-vim {{{2
if s:bundled('excitetranslate-vim')
	xnoremap E :ExciteTranslate<CR>
endif
" }}}

" gundo.vim {{{2
if s:bundled('gundo.vim')
	nmap U :<C-u>GundoToggle<CR>
	let g:gundo_auto_preview = 0
endif
" }}}2

" quickrun.vim {{{2
if s:bundled('vim-quickrun')
	let g:quickrun_config = {}
	let g:quickrun_config.markdown = {
				\ 'outputter' : 'null',
				\ 'command'   : 'open',
				\ 'cmdopt'    : '-a',
				\ 'args'      : 'Marked',
				\ 'exec'      : '%c %o %a %s',
				\ }
endif
" }}}2

" vimshell {{{2
if s:bundled('vimshell')
	let g:vimshell_prompt_expr = 'getcwd()." > "'
	let g:vimshell_prompt_pattern = '^\f\+ > '
	augroup my-vimshell
		autocmd!
		autocmd FileType vimshell
					\ imap <expr> <buffer> <C-n> pumvisible() ? "\<C-n>" : "\<Plug>(vimshell_history_neocomplete)"
	augroup END
endif
" }}}2

" skk.vim {{{2
if s:bundled('skk.vim')
	set imdisable
	let skk_jisyo = '~/SKK_JISYO.L'
	let skk_large_jisyo = '~/SKK_JISYO.L'
	let skk_auto_save_jisyo = 1
	let skk_keep_state =0
	let skk_egg_like_newline = 1
	let skk_show_annotation = 1
	let skk_use_face = 1
endif
" }}}2

" eskk.vim {{{2
if s:bundled('eskk.vim')
	set imdisable
	let g:eskk#directory = '~/SKK_JISYO.L'
	let g:eskk#dictionary = { 'path': "~/SKK_JISYO.L", 'sorted': 0, 'encoding': 'utf-8', }
	let g:eskk#large_dictionary = { 'path': "~/SKK_JISYO.L", 'sorted': 1, 'encoding': 'utf-8', }
	let g:eskk#enable_completion = 1
endif

" }}}2
" }}}1

" Loading divided files
let g:local_vimrc = expand('~/.vimrc.local')
if filereadable(g:local_vimrc)
	execute 'source ' . g:local_vimrc
endif

" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
