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

" Coding Rules {{{
" Author:   <B4B4R07> Plz call me BABAROT.
" Contacts: <b4b4r07@gmail.com>.
"  Naming rules {{{2
" - Functions
" -- Global function => CamelCase
" -- Local function => snake_case
" - Mapping prefix
" -- <Space> is vim-wise
" -- <Leader> is plugin-wise
"}}}2
" - License {{{2
"  The MIT License (MIT)
"  
"  Copyright (c) 2014 B4B4R07
"  
"  Permission is hereby granted, free of charge, to any person obtaining a copy of
"  this software and associated documentation files (the "Software"), to deal in
"  the Software without restriction, including without limitation the rights to
"  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
"  of the Software, and to permit persons to whom the Software is furnished to do
"  so, subject to the following conditions:
"  
"  The above copyright notice and this permission notice shall be included in all
"  copies or substantial portions of the Software.
"  
"  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
"  SOFTWARE.
"}}}2

"}}}

" Initial: {{{1
" Skip initialization for vim-tiny or vim-small
if !1 | finish | endif

" Use plain vim
" when vim was invoked by 'sudo' command.
" or, invoked as 'git difftool'
if exists('$SUDO_USER') || exists('$GIT_DIR')
	finish
endif

" Only once execution when starting vim
if has('vim_starting')
	" Necesary for lots of cool vim things
	set nocompatible
	" Define entire file encoding
	scriptencoding utf-8

	" Vim starting time
	if has('reltime')
		let g:startuptime = reltime()
		augroup vimrc-startuptime
			autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
						\ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
		augroup END
	endif
endif

" Operating System {{{2
let g:is_windows = has('win16') || has('win32') || has('win64')
let g:is_cygwin = has('win32unix')
let g:is_mac = !g:is_windows && !g:is_cygwin
			\ && (has('mac') || has('macunix') || has('gui_macvim') ||
			\    (!executable('xdg-open') &&
			\    system('uname') =~? '^darwin'))
let g:is_unix = !g:is_mac && has('unix')
"}}}2

" Define neobundle runtimepath
if g:is_windows
	let $DOTVIM=expand('~/vimfiles')
else
	let $DOTVIM=expand('~/.vim')
endif
let $VIMBUNDLE=$DOTVIM . '/bundle'
let $NEOBUNDLEPATH=$VIMBUNDLE . '/neobundle.vim'

" Environment variable
let $MYVIMRC = expand('~/.vimrc')

" Initialize autocmd
augroup MyAutoCmd
	autocmd!
augroup END

" Enable/Disable {{{2
let s:true = 1
let s:false = 0

let s:enable_sujest_neobundleinit = s:true
let s:enable_eof_to_bof = s:true
let g:enable_auto_highlight_cursorline = s:true
let g:enable_buftabs = s:true
let s:enable_restore_cursor_position = s:false
"}}}2

function! s:bundled(bundle) "{{{2
	if !isdirectory($VIMBUNDLE)
		return 0
	endif
	if stridx(&runtimepath, $NEOBUNDLEPATH) == -1
		return 0
	endif

	if a:bundle ==# 'neobundle.vim'
		return 1
	else
		return neobundle#is_installed(a:bundle)
	endif
endfunction "}}}2
"}}}1

" NeoBundle: {{{1
filetype off

" Add neobundle to runtimepath
if has('vim_starting') && isdirectory($NEOBUNDLEPATH)
	set runtimepath+=$NEOBUNDLEPATH
endif

if s:bundled('neobundle.vim') "{{{2
	let g:neobundle#enable_tail_path = 1
	let g:neobundle#default_options = {
				\ 'same' : { 'stay_same' : 1, 'overwrite' : 0 },
				\ '_' : { 'overwrite' : 0 },
				\ }
	call neobundle#rc($VIMBUNDLE)

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
				\ }}
	NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
	NeoBundleLazy 'Shougo/vimshell', {
				\ 'autoload' : { 'commands' : [ 'VimShell', "VimShellPop", "VimShellInteractive" ] }
				\}
	NeoBundleLazy 'Shougo/unite-outline', {
				\ 'depends' : 'Shougo/unite.vim',
				\ 'autoload' : {
				\   'unite_sources' : 'outline' },
				\ }
	NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
				\ 'unite_sources' : 'help'
				\ }}
	NeoBundleLazy 'Shougo/neomru.vim', { 'autoload' : {
				\ 'unite_sources' : 'file_mru',
				\ }}
	NeoBundle 'Shougo/vimfiler'
	call neobundle#config('vimfiler', {
				\ 'lazy' : 1,
				\ 'depends' : 'Shougo/unite.vim',
				\ 'autoload' : {
				\    'commands' : [{ 'name' : 'VimFiler',
				\                    'complete' : 'customlist,vimfiler#complete' },
				\                  'VimFilerExplorer',
				\                  'Edit', 'Read', 'Source', 'Write'],
				\    'mappings' : ['<Plug>(vimfiler_switch)']
				\ }
				\ })
	NeoBundle 'Shougo/vimshell'
	call neobundle#config('vimshell', {
				\ 'lazy' : 1,
				\ 'autoload' : {
				\   'commands' : [{ 'name' : 'VimShell',
				\                   'complete' : 'customlist,vimshell#complete'},
				\                 'VimShellExecute', 'VimShellInteractive',
				\                 'VimShellTerminal', 'VimShellPop'],
				\   'mappings' : ['<Plug>(vimshell_switch)']
				\ }})
	NeoBundleLazy 'glidenote/memolist.vim', { 'autoload' : {
				\ 'commands' : ['MemoNew', 'MemoGrep']
				\ }}
	NeoBundleLazy 'thinca/vim-scouter', '', 'same', { 'autoload' : {
				\ 'commands' : 'Scouter'
				\ }}
	NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
				\ 'commands' : 'Ref'
				\ }}
	NeoBundle 'thinca/vim-quickrun'
	NeoBundle 'thinca/vim-unite-history', '', 'same'
	NeoBundle 'thinca/vim-splash'
	NeoBundle 'thinca/vim-portal'
	NeoBundle 'thinca/vim-poslist'
	NeoBundleLazy 'thinca/vim-qfreplace', '', 'same', { 'autoload' : {
				\ 'filetypes' : ['unite', 'quickfix'],
				\ }}
	NeoBundle 'tyru/nextfile.vim'
	NeoBundle 'tyru/skk.vim'
	NeoBundleLazy 'tyru/eskk.vim', { 'autoload' : {
				\ 'mappings' : [['i', '<Plug>(eskk:toggle)']],
				\ }}
	NeoBundleLazy 'tyru/open-browser.vim', '', 'same', { 'autoload' : {
				\ 'mappings' : '<Plug>(open-browser-wwwsearch)',
				\ }}
	NeoBundleLazy 'tyru/restart.vim', '', 'same', {
				\ 'gui' : 1,
				\ 'autoload' : {
				\  'commands' : 'Restart'
				\ }}
	NeoBundleLazy 'sjl/gundo.vim', '', 'same', { 'autoload' : {
				\ 'commands' : 'GundoToggle'
				\ }}
	NeoBundle 'ujihisa/neco-look'
	NeoBundleLazy 'ujihisa/unite-colorscheme', '', 'same'
	NeoBundle 'b4b4r07/mru.vim'
	NeoBundle 'b4b4r07/vim-autocdls'
	if !has('gui_running')
		NeoBundle 'b4b4r07/buftabs'
	endif
	if has('gui_running')
		NeoBundle 'itchyny/lightline.vim'
	endif
	NeoBundle 'scrooloose/syntastic'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'tpope/vim-repeat'
	NeoBundleLazy 'tpope/vim-markdown', { 'autoload' : {
				\ 'filetypes' : ['markdown'] }}
	NeoBundleLazy 'tpope/vim-fugitive', { 'autoload': {
				\ 'commands': ['Gcommit', 'Gblame', 'Ggrep', 'Gdiff'] }}
	NeoBundle 'osyo-manga/vim-anzu'
	NeoBundle 'LeafCage/yankround.vim'
	NeoBundle 'LeafCage/foldCC'
	NeoBundle 'junegunn/vim-easy-align'
	NeoBundle 'jiangmiao/auto-pairs'
	NeoBundleLazy 'mattn/gist-vim', {
				\ 'depends': ['mattn/webapi-vim' ],
				\ 'autoload' : {
				\   'commands' : 'Gist' }}
	NeoBundleLazy 'mattn/webapi-vim', {
				\ 'autoload' : {
				\   'function_prefix': 'webapi'
				\ }}
	NeoBundleLazy 'mattn/benchvimrc-vim', {
				\ 'autoload' : {
				\   'commands' : [
				\     'BenchVimrc'
				\   ]},
				\ }
	NeoBundle 'vim-scripts/Align'
	NeoBundle 'vim-scripts/FavEx'
	NeoBundleLazy 'DirDiff.vim', { 'autoload' : {
				\ 'commands' : 'DirDiff'
				\ }}
	NeoBundleLazy 'mattn/excitetranslate-vim', {
				\ 'depends': 'mattn/webapi-vim',
				\ 'autoload' : { 'commands': ['ExciteTranslate']}
				\ }
	NeoBundleLazy 'jnwhiteh/vim-golang',{
				\ "autoload" : {"filetypes" : ["go"]}
				\}
	NeoBundleLazy 'basyura/TweetVim', { 
				\'depends' : ['basyura/twibill.vim', 'tyru/open-browser.vim'],
				\ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }
				\ }
	NeoBundle 'kana/vim-gf-user'
	NeoBundle 'yomi322/unite-tweetvim'
	NeoBundle 'kien/ctrlp.vim'

	" Japanese help
	NeoBundle 'vim-jp/vimdoc-ja'

	" Colorscheme plugins
	NeoBundle 'b4b4r07/solarized.vim', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'nanotech/jellybeans.vim', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'tomasr/molokai', { "base" : $HOME."/.vim/colors" }
	NeoBundle 'w0ng/vim-hybrid', { "base" : $HOME."/.vim/colors" }

	" Disable plugins
	if g:enable_buftabs == s:true && !has('gui_running')
		NeoBundleDisable lightline.vim
	endif
	NeoBundleDisable ctrlp.vim

	filetype plugin indent on

	NeoBundleCheck

	" Source plugin file for NeoBundle
	let g:plugin_vimrc = expand('~/.vimrc.plugin')
	if filereadable(g:plugin_vimrc)
		execute 'source ' . g:plugin_vimrc
	endif
else "}}}2
	" Set neobundle rootdirectory
	if g:is_windows
		let s:bundle_root = expand('$HOME/AppData/Roaming/vim/bundle')
	else
		let s:bundle_root = expand('~/.vim/bundle')
	endif
	let s:neobundle_root = s:bundle_root . '/neobundle.vim'

	" If neobundle doesn't exist
	command! NeoBundleInit call s:neobundle_init()
	function! s:neobundle_init() "{{{2
		echon "Installing neobundle.vim..."
		call mkdir(s:bundle_root, 'p')
		execute 'cd' s:bundle_root
		call system('git clone git://github.com/Shougo/neobundle.vim')
		if v:shell_error
			echoerr "neobundle.vim installation has failed!"
			finish
		endif
		execute 'set runtimepath+=' . s:bundle_root . '/neobundle.vim'
		call neobundle#rc(s:bundle_root)
		NeoBundleInstall
		echo "Finish!"
	endfunction "}}}2

	"call s:neobundle_init()
	if s:enable_sujest_neobundleinit == s:true
		autocmd! VimEnter * echohl WarningMsg | echo "You should do ':NeoBundleInit' at first!" | echohl None
	endif
endif

" Filetype start
filetype plugin indent on
"}}}1

" Utilities: {{{1
function! s:SID() "{{{
	return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfunction "}}}

function! s:has_plugin(name) "{{{
	let nosuffix = a:name =~? '\.vim$' ? a:name[:-5] : a:name
	let suffix   = a:name =~? '\.vim$' ? a:name      : a:name . '.vim'
	return &rtp =~# '\c\<' . nosuffix . '\>'
				\   || globpath(&rtp, suffix, 1) != ''
				\   || globpath(&rtp, nosuffix, 1) != ''
				\   || globpath(&rtp, 'autoload/' . suffix, 1) != ''
				\   || globpath(&rtp, 'autoload/' . tolower(suffix), 1) != ''
endfunction "}}}

function! s:echomsg(hl, msg) "{{{
	execute 'echohl' a:hl
	try
		echomsg a:msg
	finally
		echohl None
	endtry
endfunction "}}}

function! s:Confirm(msg) "{{{
	return input(printf('%s [y/N]: ', a:msg)) =~? '^y\%[es]$'
endfunction "}}}

function! s:ErrorMsg(msg) "{{{
	echohl ErrorMsg
	echo 'ERROR: ' . a:msg
	echohl None
endfunction "}}}

function! s:WarningMsg(msg) "{{{
	echohl WarningMsg
	echo 'WARNING: ' . a:msg
	echohl None
endfunction "}}}

function! s:ExecuteKeepView(expr) "{{{
	let wininfo = winsaveview()
	execute a:expr
	call winrestview(wininfo)
endfunction "}}}

function! s:MoveMiddleOfLine() "{{{
	let strwidth = strdisplaywidth(getline('.'))
	let winwidth  = winwidth(0)

	if strwidth < winwidth
		call cursor(0, col('$') / 2)
	else
		normal! gm
	endif
endfunction "}}}

function! s:check_flag(flag) "{{{
	if exists('b:' . a:flag)
		return b:{a:flag}
	endif
	if exists('g:' . a:flag)
		return g:{a:flag}
	endif
	return 0
endfunction "}}}

function! s:mkdir(file, ...) "{{{
	let f = a:0 ? fnamemodify(a:file, a:1) : a:file
	if !isdirectory(f)
		call mkdir(f, 'p')
	endif
endfunction "}}}

function! s:auto_mkdir(dir, force) "{{{
	if !isdirectory(a:dir) && (a:force ||
				\ input(printf('"%s" does not exist. Create? [y/N] ', a:dir)) =~? '^y\%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction "}}}

function! s:smart_foldcloser() "{{{
	if foldlevel('.') == 0
		norm! zM
		return
	endif

	let foldc_lnum = foldclosed('.')
	norm! zc
	if foldc_lnum == -1
		return
	endif

	if foldclosed('.') != foldc_lnum
		return
	endif
	norm! zM
endfunction
"}}}

function! s:AllWipeout() "{{{
	for i in range(1, bufnr('$'))
		if bufexists(i)
			execute 'bwipeout ' . i
		endif
	endfor
endfunction "}}}

function! s:BdKeepWin() "{{{
	if bufname('%') != ''
		let curbuf = bufnr('%')
		let altbuf = bufnr('#')
		let buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && curbuf != v:val')
		if len(buflist) == 0
			enew
		elseif curbuf != altbuf
			execute 'buffer ' . (buflisted(altbuf) ? altbuf : buflist[0])
		else
			execute 'buffer ' . buflist[0]
		endif
		if buflisted(curbuf) && bufwinnr(curbuf) == -1
			execute 'bdelete ' . curbuf
		endif
	endif
endfunction "}}}

function! s:delete_with_confirm(file, force) "{{{
	let file = a:file ==# '' ? expand('%') : a:file
	if !a:force
		echo 'Delete "' . file . '"? [y/N]: '
	endif
	if a:force || nr2char(getchar()) ==? 'y'
		call delete(file)
		echo 'Deleted "' . file . '"!'
	else
		echo 'Cancelled.'
	endif
endfunction "}}}

function! s:Rename() "{{{
	let filename = input('New filename: ', expand('%:p:h') . '/', 'file')
	if filename != '' && filename !=# 'file'
		execute 'file' filename
		write
		call delete(expand('#'))
	endif
endfunction "}}}

function! s:RenameExt() "{{{
	let ext = input('New ext: ', '', 'filetype')
	let filename = expand('%:p:t:r')
	if !empty(ext)
		let filename = filename . '.' . ext
	endif
	if filename != '' && filename !=# 'file'
		execute 'file' filename
		write
		let ext = expand('%:e')
		execute 'setlocal filetype=' . ext
		call delete(expand('#'))
	endif
endfunction "}}}

function! s:move(file, bang, base) "{{{
	let pwd = getcwd()
	cd `=a:base`
	try
		let from = expand('%:p')
		let to = simplify(expand(a:file))
		let bang = a:bang
		if isdirectory(to)
			let to .= '/' . fnamemodify(from, ':t')
		endif
		if filereadable(to) && !bang
			echo '"' . to . '" is exists. Overwrite? [yN]'
			if nr2char(getchar()) !=? 'y'
				echo 'Cancelled.'
				return
			endif
			let bang = '!'
		endif
		let dir = fnamemodify(to, ':h')
		call s:mkdir(dir)
		execute 'saveas' . bang '`=to`'
		call delete(from)
	finally
		cd `=pwd`
	endtry
endfunction "}}}

function! s:open_junk_file() "{{{
	let junk_dir = $HOME . '/.vim/junk'. strftime('/%Y/%m/%d')
	if !isdirectory(junk_dir)
		call mkdir(junk_dir, 'p')
	endif

	let ext = input('Junk Ext: ')
	let filename = junk_dir . tolower(strftime('/%A')) . strftime('_%H%M%S')
	if !empty(ext)
		let filename = filename . '.' . ext
	endif
	execute 'edit ' . filename
endfunction "}}}

function! s:copy_current_path() "{{{
	if g:is_windows
		let @*=substitute(expand('%:p'), '\\/', '\\', 'g')
	else
		let @*=expand('%:p')
	endif
	echon expand('%:p')
endfunction "}}}

function! s:copy_current_dir() "{{{
	if g:is_windows
		let @*=substitute(expand('%:p:h'), '\\/', '\\', 'g')
	else
		let @*=expand('%:p:h')
	endif
	echon expand('%:p:h')
endfunction "}}}

function! s:find_tabnr(bufnr) "{{{
	for tabnr in range(1, tabpagenr("$"))
		if index(tabpagebuflist(tabnr), a:bufnr) !=# -1
			return tabnr
		endif
	endfor
	return -1
endfunction "}}}

function! s:find_winnr(bufnr) "{{{
	for winnr in range(1, winnr("$"))
		if a:bufnr ==# winbufnr(winnr)
			return winnr
		endif
	endfor
	return 1
endfunction "}}}

function! s:recycle_open(default_open, path) "{{{
	let default_action = a:default_open . ' ' . a:path
	if bufexists(a:path)
		let bufnr = bufnr(a:path)
		let tabnr = s:find_tabnr(bufnr)
		if tabnr ==# -1
			execute default_action
			return
		endif
		execute 'tabnext ' . tabnr
		let winnr = s:find_winnr(bufnr)
		execute winnr . 'wincmd w'
	else
		execute default_action
	endif
endfunction "}}}

function! s:safeQuit(bang) "{{{
	if !(tabpagenr('$') == 1 && winnr('$') == 1)
		execute 'quit'.a:bang
		return
	endif

	echohl WarningMsg
	let l:input = input('Are you sure to quit vim?[y/n]: ')
	echohl None
	redraw!

	if l:input ==? 'y'
		execute 'quit'.a:bang
	endif
endfunction "}}}

function! s:load_source(path) "{{{
	let path = expand(a:path)
	if filereadable(path)
		execute "source ".path
	endif
endfunction "}}}

function! s:system(command) "{{{
	let _ = system(a:command)
	if v:shell_error != 0
		echoerr 'Command failed:' string(a:command)
		let _ = ''
	endif
	return _
endfunction "}}}

function! s:Grep(pattern, target) "{{{
	execute 'grep ' . a:pattern . ' ' . a:target
	Unite -no-quit -direction=botright quickfix
endfunction "}}}

function! s:get_list(...) "{{{
	let l:pwd = getcwd()
	if a:0 == 1
		if !isdirectory(a:1)
			echohl ErrorMsg | echo a:1 ": No such file or directory" | echohl NONE
			return
		endif
		execute ":lcd " . expand(a:1)
	endif
	let filelist = glob(getcwd() . "/*")

	let splitted = split(filelist, "\n")
	for file in splitted
		if isdirectory(file)
			echon fnamemodify(file, ":t") . "/" . " "
			"echo fnamemodify(file, ":t") . "/"
		else
			echon fnamemodify(file, ":t") . " "
			"echo fnamemodify(file, ":t")
		endif
	endfor
	execute ":lcd " . expand(l:pwd)
endfunction "}}}

function! S(f, ...) "{{{
	" Ref: http://goo.gl/S4JFkn
	" Call a script local function.
	" Usage:
	" - S('local_func')
	"   -> call s:local_func() in current file.
	" - S('plugin/hoge.vim:local_func', 'string', 10)
	"   -> call s:local_func('string', 10) in *plugin/hoge.vim.
	" - S('plugin/hoge:local_func("string", 10)')
	"   -> call s:local_func("string", 10) in *plugin/hoge(.vim)?.
	let [file, func] =a:f =~# ':' ?  split(a:f, ':') : [expand('%:p'), a:f]
	let fname = matchstr(func, '^\w*')

	" Get sourced scripts.
	redir =>slist
	silent scriptnames
	redir END

	let filepat = '\V' . substitute(file, '\\', '/', 'g') . '\v%(\.vim)?$'
	for s in split(slist, "\n")
		let p = matchlist(s, '^\s*\(\d\+\):\s*\(.*\)$')
		if empty(p)
			continue
		endif
		let [nr, sfile] = p[1 : 2]
		let sfile = fnamemodify(sfile, ':p:gs?\\?/?')
		if sfile =~# filepat &&
					\    exists(printf("*\<SNR>%d_%s", nr, fname))
			let cfunc = printf("\<SNR>%d_%s", nr, func)
			break
		endif
	endfor

	if !exists('nr')
		echoerr 'Not sourced: ' . file
		return
	elseif !exists('cfunc')
		let file = fnamemodify(file, ':p')
		echoerr printf(
					\    'File found, but function is not defined: %s: %s()', file, fname)
		return
	endif

	return 0 <= match(func, '^\w*\s*(.*)\s*$')
				\      ? eval(cfunc) : call(cfunc, a:000)
endfunction "}}}

function! Sourcefile(file) "{{{
	let l:file = a:file
	if empty(a:file)
		let l:file = expand('%:p')
	endif

	try
		execute "source " . l:file
		echo "Success!"
	catch
		echohl WarningMsg | echo "ERROR!" | echohl NONE
	endtry
endfunction "}}}

function! HomedirOrBackslash() "{{{
	if getcmdtype() == ':' && (getcmdline() =~# '^e ' || getcmdline() =~? '^r\?!' || getcmdline() =~? '^cd ')
		return '~/'
	else
		return '\'
	endif
endfunction "}}}

function! Date() "{{{
	return strftime("%Y/%m/%d %H:%M")
endfunction "}}}

function! GetDocumentPosition() "{{{
	return float2nr(str2float(line('.')) / str2float(line('$')) * 100) . "%"
endfunction "}}}

function! GetTildaPath(full) "{{{
	if a:full
		return expand('%:~')
	else
		return expand('%:~:h')
	endif
endfunction "}}}

function! GetCharacterCode() "{{{
	let str = iconv(matchstr(getline('.'), '.', col('.') - 1), &enc, &fenc)
	let out = '0x'
	for i in range(strlen(str))
		let out .= printf('%02X', char2nr(str[i]))
	endfor
	if str ==# ''
		let out .= '00'
	endif
	return out
endfunction "}}}

function! GetFileSize() "{{{
	let size = &encoding ==# &fileencoding || &fileencoding ==# ''
				\        ? line2byte(line('$') + 1) - 1 : getfsize(expand('%'))

	if size < 0
		let size = 0
	endif
	for unit in ['B', 'KB', 'MB']
		if size < 1024
			return size . unit
		endif
		let size = size / 1024
	endfor
	return size . 'GB'
endfunction "}}}

function! GetBufname(bufnr, tail) "{{{
	let bufname = bufname(a:bufnr)
	if bufname =~# '^[[:alnum:].+-]\+:\\\\'
		let bufname = substitute(bufname, '\\', '/', 'g')
	endif
	let buftype = getbufvar(a:bufnr, '&buftype')
	if bufname ==# ''
		if buftype ==# ''
			return '[No Name]'
		elseif buftype ==# 'quickfix'
			return '[Quickfix List]'
		elseif buftype ==# 'nofile' || buftype ==# 'acwrite'
			return '[Scratch]'
		endif
	endif
	if buftype ==# 'nofile' || buftype ==# 'acwrite'
		return bufname
	endif
	if a:tail
		return fnamemodify(bufname, ':t')
	endif
	let fullpath = fnamemodify(bufname, ':p')
	if exists('b:lcd') && b:lcd !=# ''
		let bufname = matchstr(fullpath, '^\V\(' . escape(b:lcd, '\')
					\ . '\v)?[/\\]?\zs.*')
	endif
	return bufname
endfunction "}}}

function! GetFileInfo() "{{{
	let line  = ''
	if bufname(bufnr("%")) == ''
		let line .= 'No name'
	else
		let line .= '"'
		let line .= expand('%:p:~')
		let line .= ' (' . line('.') . '/' . line('$') . ') '
		"let line .= '--' . 100 * line('.') / line('$') . '%--'
		let line .= GetDocumentPosition()
		let line .= '"'
	endif
	return line
endfunction "}}}

function! GetGitBranchName() "{{{
	let dir = expand('%:p:h')
	let branch = ""
	let r = system('cd ' . dir . ' && git symbolic-ref HEAD 2> /dev/null')
	if r != ""
		let branch = split(r,"/")[-1][:-2]
	endif
	return branch
endfunction "}}}

function! DoSource(...) "{{{
	if a:0
		let l:target = a:1
	else
		let l:target = expand('%:p')
	endif
	execute 'source ' . l:target
endfunction "}}}

function! GetFileList(...) "{{{
	if a:0
		let filelist = glob("**")
	else
		let filelist = glob("*")
	endif
	let splitted = split(filelist, "\n")
	for file in splitted
		echo file
	endfor
endfunction "}}}

function! QuitIfNameless() "{{{
	if empty(bufname('%'))
		setlocal nomodified
	endif
	execute 'confirm quit'
endfunction " }}}

function! Scouter(file, ...) "{{{
	" Measure fighting power of Vim!
	" :echo len(readfile($MYVIMRC))
	let pat = '^\s*$\|^\s*"'
	let lines = readfile(a:file)
	if !a:0 || !a:1
		let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
	endif
	return len(filter(lines,'v:val !~ pat'))
endfunction " }}}

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

function! GetBufInfo() "{{{
	echo '[ fpath ]' expand('%:p')
	echo '[ bufnr ]' bufnr('%')
	if filereadable(expand('%'))
		echo '[ mtime ]' strftime('%Y-%m-%d %H:%M:%S', getftime(expand('%')))
	endif
	echo '[ fline ]' line('$') 'lines'
	"echo '[ fsize ]' s:GetBufByte() 'bytes'
	echo '[ fsize ]' GetFileSize()
	echo '[ power ]' Scouter($MYVIMRC)
endfunction "}}}

function! SelectInteractive(question, candidates) "{{{
	try
		let a:candidates[0] = toupper(a:candidates[0])
		let l:select = 0
		while index(a:candidates, l:select, 0, 1) == -1
			let l:select = input(a:question . ' [' . join(a:candidates, '/') . '] ')
			if l:select == ''
				let l:select = a:candidates[0]
			endif
		endwhile
		return tolower(l:select)
	finally
		redraw!
	endtry
endfunction "}}}

function! BufferWipeoutInteractive() "{{{
	if &modified == 1
		let l:selected = SelectInteractive('Buffer is unsaved. Force quit?', ['n', 'w', 'y'])
		if l:selected == 'w'
			if bufname(bufnr("%")) == ''
				call s:ErrorMsg("This buffer is [No name]. Should do ':q!'")
				return
				"quit!
			else
				write
				bwipeout
			endif
		elseif l:selected == 'y'
			bwipeout!
		endif
	else
		bwipeout
	endif
endfunction "}}}

function! ToggleOption(option_name) "{{{
	execute 'setlocal' a:option_name.'!'
	execute 'setlocal' a:option_name.'?'
endfunction "}}}

function! ToggleVariable(variable_name) "{{{
	if eval(a:variable_name)
		execute 'let' a:variable_name.' = 0'
	else
		execute 'let' a:variable_name.' = 1'
	endif
	echo printf('%s = %s', a:variable_name, eval(a:variable_name))
endfunction "}}}
"}}}1

" Appearance: {{{1
" English interface {{{
if g:is_windows
	language message en
else
	language mes C
endif "}}}

" Colorscheme "{{{2
set background=dark
set t_Co=256
if &t_Co < 256
	colorscheme default
else
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
endif "}}}2

set laststatus=2  statusline=%!MakeStatusLine()
set showtabline=2 tabline=%!MakeTabLine()

" Cursor color on when IME ON {{{
if has('multi_byte_ime') || has('xim')
	highlight Cursor guibg=NONE guifg=Yellow
	highlight CursorIM guibg=NONE guifg=Red
	set iminsert=0 imsearch=0
	if has('xim') && has('GUI_GTK')
		""set imactivatekey=s-space
	endif
	inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif "}}}

" Display JISX0208Space {{{
if has("syntax")
	" the line is required for POD bug fix
	syntax on
	function! ActivateInvisibleIndicator()
		syntax match InvisibleJISX0208Space "　" display containedin=ALL
		highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
	endfunction
	autocmd MyAutoCmd BufNew,BufRead * call ActivateInvisibleIndicator()
endif
"augroup hilightIdegraphicSpace
"  autocmd!
"  autocmd VimEnter,ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
"  autocmd WinEnter * match IdeographicSpace /　/
"augroup END
"}}}

" Yellow statusline at Insert mode {{{
if !s:bundled('lightline.vim')
	if has('syntax')
		augroup InsertHook
			autocmd!
			autocmd InsertEnter * call s:StatusLine('Enter')
			autocmd InsertLeave * call s:StatusLine('Leave')
		augroup END
	endif
	"highlight StatusLine ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none

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
endif
" }}}

" Cursor {{{
set cursorline
"set cursorcolumn
"set colorcolumn=80

augroup vimrc-auto-cursorcolumn
	autocmd!
	autocmd CursorMoved,CursorMovedI * call s:auto_cursorcolumn('CursorMoved')
	autocmd CursorHold,CursorHoldI * call s:auto_cursorcolumn('CursorHold')
	autocmd WinEnter * call s:auto_cursorcolumn('WinEnter')
	autocmd WinLeave * call s:auto_cursorcolumn('WinLeave')

	let s:cursorcolumn_lock = 0
	function! s:auto_cursorcolumn(event)
		if a:event ==# 'WinEnter'
			setlocal cursorcolumn
			let s:cursorcolumn_lock = 2
		elseif a:event ==# 'WinLeave'
			setlocal nocursorcolumn
		elseif a:event ==# 'CursorMoved'
			if s:cursorcolumn_lock
				if 1 < s:cursorcolumn_lock
					let s:cursorcolumn_lock = 1
				else
					setlocal nocursorcolumn
					let s:cursorcolumn_lock = 0
				endif
			endif
		elseif a:event ==# 'CursorHold'
			setlocal cursorcolumn
			let s:cursorcolumn_lock = 1
		endif
	endfunction
augroup END
"}}}

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
function! StatuslineTrailingSpaceWarning()
  if !exists("b:statusline_trailing_space_warning")
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '[SPC:' . search('\s\+$', 'nw') . ']'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction

function! StatusLineExtra() "{{{
	let extra = ''
	for scope in ['w:', 'b:', 't:', 'g:']
		if exists(scope . 'statusline_extra')
			let extra .= {scope . 'statusline_extra'}
		endif
	endfor
	return extra
endfunction "}}}

function! MakeStatusLine() "{{{
	" There are three patterns
	" 1. If buftabs.vim doesn't exist
	" 2. If buftabs.vim exists [*]
	" 3. buftabs.vim exists, but if it is disabled
	" (1) is MakeStatusLine
	" (2) is buftabs.vim (g:enable_buftabs == s:true)
	" (3) is buftabs.vim (g:enable_buftabs == s:false)

	" MyColor {{{
	highlight StatusMyColor0 ctermfg=black ctermbg=white cterm=bold guifg=black guibg=white gui=none
	highlight StatusMyColor1 ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none
	highlight StatusMyColor2 ctermfg=white ctermbg=black cterm=none guifg=white guibg=black gui=none
	highlight link StatusDefaultColor StatusLine
	"}}}

	let line = ''
	"let line .= '%<'       " Truncate point.
	let line .= '%#StatusMyColor1#'
	let line .= '[%n] '
	"let line .= '%{getcwd()}/'
	let line .= '%{GetTildaPath(0)}/'
	let line .= '%#StatusMyColor0#'
	let line .= '%{GetBufname("", 0)} '
	let line .= '%#StatusDefaultColor#'

	let line .= '%m'       " Modified flag.
	let line .= '%y'       " Filetype.
	let line .= '%r'       " Readonly flag.
	let line .= '%h'       " Help buffer hlag.
	let line .= '%w'       " Preview window flag.
	" Character encoding
	let line .= "[%{(&fenc!=#''?&fenc:&enc).(&bomb?'(BOM)':'')}:"
	" File format (+ &binary and &endofline)
	let line .= "%{&ff.(&bin?'(BIN'.(&eol?'':'-noeol').')':'')}]"

	" The state of SKK.
	let line .= "%{exists('b:skk_on')&&b:skk_on?SkkGetModeStr():''}"
	if exists('*eskk#statusline')
		let line .= '%{eskk#statusline()}'
	endif
	if exists('*SyntasticStatuslineFlag')
		let line .= '%{SyntasticStatuslineFlag()}'
	endif
	let line .= '%{StatusLineExtra()}'
	if has('multi_statusline') && 2 <= &statuslineheight
		let line .= '%@'       " Separation point.
	else
		let line .= '%='       " Separation point.
	endif

	let line .= '%#StatusMyColor1#'
	let line .= '[%{GetFileSize()}]' " Rough file size.
	let line .= '[%{GetCharacterCode()}]' " Character code under the cursor.
	let line .= $LANG =~# '^ja' ? ' %l/%L行 %3v桁'
				\               : ' %l/%LL %2vC'   " Line and column.
	let line .= ' %3p%%'         " Percentage through file in lines.

	"let line .= [WC=%{exists('*WordCount') ? WordCount() : []}]
	if exists('*WordCount')
		let line .= ' [WC=%{WordCount()}]'
	endif
	let line .= ' (%{Date()})'
	let line .= '%{exists("b:git_branch") && b:git_branch != "" ? "[Git:" . b:git_branch . "]" : ""}'

	return line
endfunction "}}}

function! s:tabpage_label(n) "{{{
	let n = a:n
	let bufnrs = tabpagebuflist(n)
	let curbufnr = bufnrs[tabpagewinnr(n) - 1]  " first window, first appears

	let hi = n == tabpagenr() ? 'TabLineSel' : 'TabLine'

	let label = ''
	if getbufvar(curbufnr, '&filetype') =~# '^lingr-'
		" lingr-vim
		let unread = lingr#unread_count()
		let status = lingr#status()

		let label .= '%#' . hi . '#'
		let label .= 'lingr - ' . status
		if unread != 0
			let label .= '(' . unread . ')'
		endif

	else
		let no = len(bufnrs)
		if no == 1
			let no = ''
		endif
		let mod = len(filter(bufnrs, 'getbufvar(v:val, "&modified")')) ? '+' : ''
		let sp = (no . mod) ==# '' ? '' : ' '
		let fname = GetBufname(curbufnr, 1)

		if no !=# ''
			let label .= '%#' . hi . 'Number#' . no
		endif
		let label .= '%#' . hi . '#'
		let label .= mod . sp . fname
	endif

	return '%' . a:n . 'T' . label . '%T%#TabLineFill#'
endfunction "}}}

function! MakeTabLine() "{{{
	let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
	let sep = ' | '

	let tabs = join(titles, sep) . sep . '%#TabLineFill#%T'
	let info = '%#TabLine#'
	if exists('t:tabline_extra')
		let info .= t:tabline_extra . sep
	endif
	" if s:has_plugin('cfi')
	"   let info .= cfi#format('%s()' . sep, '')
	" endif
	if exists('*Uptime')
		let info .= Uptime(2) . sep
	endif
	if s:has_plugin('reanimate') && reanimate#is_saved()
		let info .= reanimate#last_point() . sep
	endif
	let info .= fnamemodify(getcwd(), ":~") . ' '
	return tabs . '%=' . info
endfunction "}}}
"}}}1

" Options: {{{1
syntax enable

set lazyredraw
set ttyfast

set modeline
set modelines=4
set keywordprg=:help " Open Vim internal help by K command
set helplang& helplang=ja

set ignorecase
set smartcase
set incsearch
set hlsearch

" Have Vim automatically reload changed files on disk. Very useful when using
" git and switching between branches
set autoread

" Automatically write buffers to file when current window switches to another
" buffer as a result of :next, :make, etc. See :h autowrite.
set autowrite

set switchbuf=useopen,usetab,newtab


set nostartofline
set tabstop=4
set noexpandtab
set autoindent
set backspace=indent,eol,start
set wrapscan
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

" Hide buffers instead of unloading them
set hidden

set textwidth=0
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set formatoptions-=v
set formatoptions+=l
set number

" Show line and column number
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
set history=10000

set wrap

" String to put at the start of lines that have been wrapped.
let &showbreak = '+++ '

" Always display a status line
set laststatus=2

" Set command window height to reduce number of 'Press ENTER...' prompts
set cmdheight=2

" Show current mode (insert, visual, normal, etc.)
set showmode

" Show last command in status line
set showcmd

" Lets vim set the title of the console
set notitle

set lines=50
set columns=160
set previewheight=10
set helpheight=999
set mousehide
set virtualedit=block
set virtualedit& virtualedit+=block

" Make it normal in UTF-8 in Unix.
set encoding=utf-8

" Select newline character (either or both of CR and LF depending on system) automatically
" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
if exists('&ambiwidth')
	set ambiwidth=double
endif

set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8

" Foldings {{{
set foldenable
"set foldmethod=marker
"set foldopen=all
"set foldclose=all
set foldlevel=0
set foldnestmax=2
set foldcolumn=2
"}}}

" IM settings
" IM off when starting up
set iminsert=0 imsearch=0
" Use IM always
"set noimdisable
" Disable IM on cmdline
set noimcmdline

" Change some neccesary settings for win
if g:is_windows
	set shellslash "Exchange path separator
endif

if has('persistent_undo')
	set undofile
	let &undodir = $DOTVIM . '/undo'
	"silent! call mkdir(&undodir, 'p')
	call s:mkdir(&undodir)
endif

" Use clipboard
if has('clipboard')
	set clipboard=unnamed
endif

if has('patch-7.4.338')
	set breakindent
endif

" GUI options {{{
" No menubar
set guioptions-=m
" No frame
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
"}}}

" Always only one window when opening files
augroup file-only
	autocmd!
	autocmd BufRead * execute ":only"
augroup END

"Move current working directory automatically
augroup cd-filepath
	autocmd!
	"autocmd BufRead,BufEnter * lcd %:p:h
	autocmd BufRead,BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

" Display a path in commandline when opening
augroup echo-file-path
	autocmd!
	autocmd WinEnter * execute "normal! 1\<C-g>"
augroup END

"Do not insert comment when inputing newline
augroup no-comment
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
augroup END

augroup gvim-window-siz
	autocmd!
	autocmd GUIEnter * setlocal lines=50
	autocmd GUIEnter * setlocal columns=160
augroup END

"}}}1

" Mappings: {{{1
" It is likely to be changed by $VIM/vimrc.
if has('vim_starting')
	mapclear
	mapclear!
endif

if g:is_mac
	noremap ¥ \
	noremap \ ¥
endif

let mapleader = ","
let maplocalleader = ","

" function's commands {{{2
" Smart folding close
nnoremap <silent><C-_> :<C-u>call <SID>smart_foldcloser()<CR>

" Use ,q to quit nameless buffers without confirmation or !
nnoremap <silent> <Leader>q :<C-u>call QuitIfNameless()<CR>

" Kill buffer
nnoremap <C-x>k :call BufferWipeoutInteractive()<CR>

" Move middle of current line.(not middle of screen)
nnoremap <silent> gm :<C-u>call <SID>MoveMiddleOfLine()<CR>

" Open vimrc with tab
nnoremap <Space>. :call <SID>recycle_open('tabedit', $MYVIMRC)<CR>

" Make junkfile
"nnoremap <silent> <Space>e  :<C-u>JunkFile<CR>

" Easy typing tilda insted of backslash
cnoremap <expr> <Bslash> HomedirOrBackslash()
"}}}

" swap ; and : {{{
nnoremap ; :
vnoremap ; :
nnoremap q; q:
vnoremap q; q:
nnoremap : ;
vnoremap : ;
"}}}

" Easy escaping jj {{{
inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
vnoremap <C-j><C-j> <ESC>
onoremap jj <ESC>
inoremap j<Space> j
onoremap j<Space> j
"}}}

" switch j,k and gj,gk {{{
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k
"}}}

" Warp EOF to BOF {{{
if s:enable_eof_to_bof == s:true
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
endif "}}}

" virtual replace mode {{{
nnoremap R gR
nnoremap gR R
"}}}

" Buffer and Tabs {{{
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>
nnoremap <C-h> :tabnext<CR>
nnoremap <C-l> :tabprev<CR>
nnoremap <silent> tt  :<C-u>tabe<CR>
"nnoremap <C-p>  gT
"nnoremap <C-n>  gt
"}}}

" Auto pair {{{
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ` ``<LEFT>
"}}}

" Cursor like Emacs {{{
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
nnoremap <C-a> ^
nnoremap <C-e> $
nnoremap + <C-a>
nnoremap - <C-x>
"}}}

" Disable features {{{
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"}}}

" Window split {{{
nnoremap s <Nop>
nnoremap sp <C-u>:split<CR>
nnoremap vs <C-u>:vsplit<CR>
nnoremap ss <C-w>w
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" _ : Quick horizontal splits
nnoremap _  :sp<CR>
" | : Quick vertical splits
nnoremap <bar>  :vsp<CR>

"}}}

" Encoding commands {{{
" Command group opening with a specific character code again
" In particular effective when I am garbled in a terminal
command! -bang -bar -complete=file -nargs=? Utf8      edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932     edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc       edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16     edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be   edit<bang> ++enc=ucs-2 <args>
command! -bang -bar -complete=file -nargs=? Jis       Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis      Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode   Utf16<bang> <args>

" Tried to make a file note version
" Don't save it because dangerous.
command! WUtf8      setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932     setlocal fenc=cp932
command! WEuc       setlocal fenc=euc-jp
command! WUtf16     setlocal fenc=ucs-2le
command! WUtf16be   setlocal fenc=ucs-2
command! WJis       WIso2022jp
command! WSjis      WCp932
command! WUnicode   WUtf16

" Appoint a line feed
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos  write<bang> ++fileformat=dos <args>  | edit <args>
command! -bang -complete=file -nargs=? WMac  write<bang> ++fileformat=mac <args>  | edit <args>
"}}}

" Like an Emacs {{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
"}}}

" Folding {{{
nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
nnoremap <expr>h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <silent>z0 :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR><CR>
"}}}

" Commands! {{{

" Show all runtimepaths
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

command! -bar -bang -nargs=? -complete=file Scouter
			\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)

command! -nargs=? -bang -bar -complete=file Delete call s:delete_with_confirm(<q-args>, <bang>0)
command! -nargs=0 Rename call s:Rename()
command! -nargs=0 RenameExt call s:RenameExt()
"command! -nargs=0 JunkFile call s:open_junk_file()

command! -nargs=1 Mkdir call s:mkdir(expand(<q-args>, ':p'))

command! -nargs=? Source call Sourcefile(<q-args>)

" Remove ^M
command! RemoveCr call s:ExecuteKeepView('silent! %substitute/\r$//g | nohlsearch')

" Remove EOL space
command! RemoveEolSpace call s:ExecuteKeepView('silent! %substitute/ \+$//g | nohlsearch')

" Remove blank line
command! RemoveBlankLine silent! global/^$/delete | nohlsearch | normal! ``

" Remove all Buffer wipeout
command! -nargs=0 AllWipeout call s:AllWipeout()

command! -nargs=0 BdKeepWin call s:BdKeepWin()

command! CopyCurrentPath :call s:copy_current_path()
command! CopyCurrentDir :call s:copy_current_dir()

command! -nargs=1 -bang -bar -complete=file Rename
			\        call s:move(<q-args>, <q-bang>, expand('%:h'))

command! -nargs=1 -bang -bar -complete=file Move
			\        call s:move(<q-args>, <q-bang>, getcwd())

command! -bang SafeQuit call s:safeQuit('<bang>')

command! -nargs=+ Grep call s:Grep(<f-args>)

command! -nargs=? -bar -bang -complete=dir Ls call s:get_list(<f-args>)

command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>

command! -bar DeleteHideBuffer :call s:delete_hide_buffer()

command! -bar DeleteNoFileBuffer :call s:delete_no_file_buffer()
"}}}

" Useful settings {{{2
inoremap <silent> <C-CR> <Esc>:set expandtab<CR>a<CR> <Esc>:set noexpandtab<CR>a<BS>

nnoremap <Leader>wc :%s/\i\+/&/gn<CR>
vnoremap <Leader>wc :s/\i\+/&/gn<CR>
nnoremap gs :<C-u>%s///g<Left><Left><Left>
vnoremap gs :s///g<Left><Left><Left>

" Add a relative number toggle
nnoremap <silent> <Leader>r :<C-u>set relativenumber!<CR>

" Add a spell check toggle
nnoremap <silent> <Leader>s :<C-u>set spell!<CR>

" Goto {num} row like a {num}gg, {num}G and :{num}<CR>
nnoremap <expr><Tab> v:count !=0 ? "G" : "\<Tab>"

nnoremap <silent>~ :let &tabstop = (&tabstop * 2 > 16) ? 2 : &tabstop * 2<CR>:echo 'tabstop:' &tabstop<CR>

" Move to top/center/bottom
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?
			\ 'zt' : (winline() == 1)? 'zb' : 'zz'

" Reset highlight searching
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
"}}}2

" Go to last last changes
nnoremap <C-g> zRg;zz

" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap <Space>h ^
noremap <Space>l $

" Type 'v', select end of line in visual mode
vnoremap v $h

nnoremap Y y$
nnoremap n nzz
nnoremap N Nzz

nnoremap <Space>/  *<C-o>
nnoremap g<Space>/ g*<C-o>
nnoremap S *zz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"noremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
"nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>

nnoremap <C-g> 1<C-g>
noremap g<CR> g;
nnoremap <CR> :<C-u>w<CR>

" swap gf and gF
noremap gf gF
noremap gF gf

" IM off when breaking insert-mode
inoremap <ESC> <ESC>
inoremap <C-[> <ESC>

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" Insert null line
"nnoremap <silent><CR> :<C-u>call append(expand('.'), '')<CR>j

nnoremap <silent>W :<C-u>keepjumps normal! }<CR>
nnoremap <silent>B :<C-u>keepjumps normal! {<CR>
"}}}1

" Plugins: {{{1
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
" lightline.vim {{{2
if s:bundled('lightline.vim')
	let s:use_buftabs = 0
	let g:lightline = {
				\ 'colorscheme': 'solarized',
				\ 'mode_map': {'c': 'NORMAL'},
				\ 'active': {
				\   'left':  [ [ 'mode', 'paste' ], [ 'fugitive', 'filepath'], [ 'filename' ] ],
				\   'right' : [ [ 'date' ], [ 'lineinfo', 'percent' ], [ 'filetype', 'fileencoding', 'fileformat' ] ],
				\ },
				\ 'component_function': {
				\   'modified': 'MyModified',
				\   'readonly': 'MyReadonly',
				\   'fugitive': 'MyFugitive',
				\   'filepath': 'MyFilepath',
				\   'filename': 'MyFilename',
				\   'fileformat': 'MyFileformat',
				\   'filetype': 'MyFiletype',
				\   'fileencoding': 'MyFileencoding',
				\   'mode': 'MyMode',
				\   'date': 'MyDate'
				\ }
				\ }

	function! MyDate()
		return strftime("%Y/%m/%d %H:%M")
	endfunction

	function! MyModified()
		return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
	endfunction

	function! MyReadonly()
		return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
	endfunction

	function! MyFilepath()
		"return expand('%:p:h')
		return expand('%:~:h') . "/"
	endfunction

	function! MyFilename()
		return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
					\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
					\  &ft == 'unite' ? unite#get_status_string() :
					\  &ft == 'vimshell' ? vimshell#get_status_string() :
					\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
					\ ('' != MyModified() ? ' ' . MyModified() : '')
	endfunction

	function! MyFugitive()
		try
			if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
				return fugitive#head()
			endif
		catch
		endtry
		return ''
	endfunction

	function! MyFileformat()
		return winwidth(0) > 70 ? &fileformat : ''
	endfunction

	function! MyFiletype()
		return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'NONE') : ''
	endfunction

	function! MyFileencoding()
		return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
	endfunction

	function! MyMode()
		return winwidth(0) > 60 ? lightline#mode() : ''
	endfunction

	" http://ac-mopp.blogspot.jp/2014/03/lightlinevim.html {{{
	let g:mline_bufhist_queue = []
	let g:mline_bufhist_limit = 4
	let g:mline_bufhist_exclution_pat = '^$\|.jax$\|vimfiler:\|\[unite\]\|tagbar'
	let g:mline_bufhist_enable = 1
	command! Btoggle :let g:mline_bufhist_enable = g:mline_bufhist_enable ? 0 : 1 | :redrawstatus!

	function! Mline_buflist()
		if &filetype =~? 'unite\|vimfiler\|tagbar' || !&modifiable || len(g:mline_bufhist_queue) == 0 || g:mline_bufhist_enable == 0
			return ''
		endif

		let current_buf_nr = bufnr('%')
		let buf_names_str = ''
		let last = g:mline_bufhist_queue[-1]
		for i in g:mline_bufhist_queue
			let t = fnamemodify(i, ':t')
			let n = bufnr(t)

			if n != current_buf_nr
				let buf_names_str .= printf('[%d]:%s' . (i == last ? '' : ' | '), n, t)
			endif
		endfor

		return buf_names_str
	endfunction

	function! s:update_recent_buflist(file)
		if a:file =~? g:mline_bufhist_exclution_pat
			" exclusion from queue
			return
		endif

		if len(g:mline_bufhist_queue) == 0
			" init
			for i in range(min( [ bufnr('$'), g:mline_bufhist_limit + 1 ] ))
				let t = bufname(i)
				if bufexists(i) && t !~? g:mline_bufhist_exclution_pat
					call add(g:mline_bufhist_queue, fnamemodify(t, ':p'))
				endif
			endfor
		endif

		" update exist buffer
		let idx = index(g:mline_bufhist_queue, a:file)
		if 0 <= idx
			call remove(g:mline_bufhist_queue, idx)
		endif

		call insert(g:mline_bufhist_queue, a:file)

		if g:mline_bufhist_limit + 1 < len(g:mline_bufhist_queue)
			call remove(g:mline_bufhist_queue, -1)
		endif
	endfunction

	augroup general
		autocmd!
		autocmd TabEnter,BufWinEnter * call s:update_recent_buflist(expand('<amatch>'))
	augroup END
	"}}}
endif
" }}}2
" buftabs.vim {{{2
if s:bundled('buftabs')
	" MyColor {{{
	highlight StatusMyColor1 ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none
	highlight StatusMyColor2 ctermfg=white ctermbg=black cterm=none guifg=white guibg=black gui=none
	highlight link StatusDefaultColor StatusLine
	"}}}

	set laststatus=2
	set statusline=
	if exists('g:enable_buftabs') && g:enable_buftabs == s:true
		set statusline+=%{buftabs}
	else
		set statusline+=%#StatusMyColor1#
		"set statusline+=%{getcwd()}/
		set statusline+=%{pathshorten(getcwd())}/
		set statusline+=%f
		set statusline+=\ %m
		set statusline+=%#StatusDefaultColor#
	endif
	set statusline+=%=
	set statusline+=%#StatusMyColor1#
	set statusline+=%{StatuslineTrailingSpaceWarning()}
	set statusline+=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
	set statusline+=%r
	set statusline+=%h
	set statusline+=%w
	set statusline+=[%{GetFileSize()}]
	set statusline+=[%{GetCharacterCode()}]
	set statusline+=\ %4l/%4LL,%3cC\ %3p%%
	if exists('*WordCount')
		set statusline+=\ [WC=%{WordCount()}]
	endif
	set statusline+=\ (%{Date()})

	let g:buftabs_in_statusline   = 1
	let g:buftabs_only_basename   = 1
	let g:buftabs_marker_start    = "["
	let g:buftabs_marker_end      = "]"
	let g:buftabs_separator       = "#"
	let g:buftabs_marker_modified = "+"
	let g:buftabs_active_highlight_group = "Visual"
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
	nmap n <Plug>(anzu-n-with-echo)zz
	nmap N <Plug>(anzu-N-with-echo)zz
	nmap * <Plug>(anzu-star-with-echo)zz
	nmap # <Plug>(anzu-sharp-with-echo)zz
	"nmap n <Plug>(anzu-mode-n)
	"nmap N <Plug>(anzu-mode-N)
endif
" }}}2
" yankround.vim {{{2
if s:bundled('yankround.vim')
	nmap p <Plug>(yankround-p)
	xmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap gp <Plug>(yankround-gp)
	xmap gp <Plug>(yankround-gp)
	nmap gP <Plug>(yankround-gP)
	nmap <C-p> <Plug>(yankround-prev)
	nmap <C-n> <Plug>(yankround-next)
	let g:yankround_max_history = 100
	if s:bundled('unite.vim')
		nnoremap <Space>p :Unite yankround -direction=botright -toggle<CR>
	endif
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
" foldCC {{{2
if s:bundled('foldCC')
	set foldtext=foldCC#foldtext()
	let g:foldCCtext_head = 'v:folddashes. " "'
	let g:foldCCtext_tail = 'printf(" %s[%4d lines Lv%-2d]%s", v:folddashes, v:foldend-v:foldstart+1, v:foldlevel, v:folddashes)'
	let g:foldCCtext_enable_autofdc_adjuster = 1
endif
" }}}2
" portal.vim {{{2
if s:bundled('vim-portal')
	nmap <Leader>pb <Plug>(portal-gun-blue)
	nmap <Leader>po <Plug>(portal-gun-orange)
	nnoremap <Leader>pr :<C-u>PortalReset<CR>
endif
" }}}2
" vim-gf-user {{{2
if s:bundled('vim-gf-user')
	function! GfUserCLAngleBracket()
		let path = matchstr(getline("."), '\v\<\zs([^>]+)\ze\>')
		let path = fnamemodify(path, '%:p')
		let [whole, path, linecol; rest] = matchlist(path, '\v^([^"]+)(".+)?$')
		if path == ''
			return 0
		endif
		let path = split(expand(path), '\n')[0]
		if linecol =~ ','
			let [whole, line, column; rest] = matchlist(linecol, '\v^"(.+),(.+)$')
			return {'path': path, 'line': str2nr(line), 'col': str2nr(column)}
		else
			return {'path': path, 'line': str2nr(linecol[1:]), 'col': 0}
		endif
	endfunction
	call gf#user#extend('GfUserCLAngleBracket', 1000)
endif
" }}}2
" restart.vim {{{2
if s:bundled('restart.vim')
	if has('gui_running')
		let g:restart_sessionoptions
					\ = 'blank,buffers,curdir,folds,help,localoptions,tabpages'
		command!
					\   RestartWithSession
					\   -bar
					\   let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
					\   | Restart
	endif
endif
" }}}2
" vim-poslist {{{2
if s:bundled('vim-poslist')
	map <C-o> <Plug>(poslist-prev-pos)
	map <C-i> <Plug>(poslist-next-pos)
endif
" }}}2
" }}}1

" Misc: {{{1
call s:mkdir(expand('$HOME/.vim/colors'))

"let g:junkmemo_path = '$HOME/junk2'
"let g:junkmemo_memotitle = 'test'
"let g:junkmemo_suffix = 'vim'

" CD {{{
"command! -complete=customlist,<SID>CommandComplete_cdpath -nargs=1
"       \ CD  cd <args>
"
"function! s:CommandComplete_cdpath(arglead, cmdline, cursorpos)
"  return  split(globpath(&cdpath, a:arglead . '*/'), "\n")
"endfunction
"
"let s:CMapABC_Entries = []
"function! s:CMapABC_Add(original_pattern, alternate_name)
"  call add(s:CMapABC_Entries, [a:original_pattern, a:alternate_name])
"endfunction
"
"cnoremap <expr> <Space>  <SID>CMapABC()
"function! s:CMapABC()
"  let cmdline = getcmdline()
"  for [original_pattern, alternate_name] in s:CMapABC_Entries
"    if cmdline =~# original_pattern
"      return "\<C-u>" . alternate_name . ' '
"    endif
"  endfor
"  return ' '
"endfunction
"
"call s:CMapABC_Add('^cd', 'CD')
"}}}

augroup show-git-branch "{{{
	autocmd!
	autocmd BufEnter * let b:git_branch = GetGitBranchName()
augroup END "}}}

augroup vim-startup-nomodified "{{{
	autocmd!
	autocmd VimEnter * set nomodified
augroup END "}}}

augroup auto-make-directory "{{{
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END "}}}

augroup word-count "{{{
	autocmd!
	autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
"}}}

augroup get-file-info "{{{
	autocmd!
	"autocmd CursorHold,CursorHoldI * execute "normal! 1\<C-g>"
	autocmd CursorHold,CursorHoldI * execute "echo GetFileInfo()"
augroup END "}}}

augroup vimrc-auto-mkdir "{{{
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)
		if !isdirectory(a:dir)
					\   && (a:force
					\       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction
augroup END "}}}

" Launched with -b option {{{
if has('vim_starting') && &binary
	augroup vimrc-xxd
		autocmd!
		autocmd BufReadPost * if &l:binary | setlocal filetype=xxd | endif
	augroup END
endif "}}}

" Add execute permission {{{
if executable('chmod')
	augroup vimrc-autoexecutable
		autocmd!
		autocmd BufWritePost * call s:add_permission_x()
	augroup END

	function! s:add_permission_x()
		let file = expand('%:p')
		if !executable(file)
			if getline(1) =~# '^#!'
						\ || &ft =~ "\\(z\\|c\\|ba\\)\\?sh$"
						\ && input(printf('"%s" is not perm 755. Change mode? [y/N] ', expand('%:t'))) =~? '^y\%[es]$'
				call system("chmod 755 " . shellescape(file))
				dcho " "
				echo "Set permission 755!"
			endif
		endif
	endfunction
endif "}}}

" Restore cursor position {{{
function! s:RestoreCursorPostion()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
if s:enable_restore_cursor_position == s:true
	augroup restore-cursor-position
		autocmd!
		autocmd BufWinEnter * call s:RestoreCursorPostion()
	augroup END
endif "}}}

" View directory {{{
call s:mkdir(expand('$HOME/.vim/view'))
set viewdir=~/.vim/view
set viewoptions-=options
set viewoptions+=slash,unix
augroup vimrc-view
	autocmd!
	autocmd BufLeave * if expand('%') !=# '' && &buftype ==# ''
				\    |   mkview
				\    | endif
	autocmd BufReadPost * if !exists('b:view_loaded') &&
				\           expand('%') !=# '' && &buftype ==# ''
				\       |   silent! loadview
				\       |   let b:view_loaded = 1
				\       | endif
	autocmd VimLeave * call map(split(glob(&viewdir . '/*'), "\n"),
				\                           'delete(v:val)')
augroup END "}}}

" Backup automatically {{{
set backup
if g:is_windows
	set backupdir=$VIM/backup
	set backupext=.bak
else
	call s:mkdir(expand('~/.vim/backup'))
	autocmd BufWritePre * call UpdateBackupFile()

	function! UpdateBackupFile()
		let dir = strftime("~/.backup/vim/%Y/%m/%d", localtime())
		if !isdirectory(dir)
			let retval = system("mkdir -p " . dir)
			let retval = system("chown goth:staff " . dir)
		endif
		execute "set backupdir=" . dir
		unlet dir
		let ext = strftime("%H_%M_%S", localtime())
		execute "set backupext=." . ext
		unlet ext
	endfunction
endif
" }}}

" Swap settings {{{
call s:mkdir(expand('~/.vim/swap'))
set swapfile
set directory=~/.vim/swap
" }}}

" Automatically save and restore window size {{{
"let g:save_window_file = expand('$HOME/.vimwinpos')
"augroup SaveWindow
"	autocmd!
"	autocmd VimLeavePre * call s:save_window()
"	function! s:save_window()
"		let options = [
"			\ 'set columns=' . &columns,
"			\ 'set lines=' . &lines,
"			\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
"			\ ]
"		call writefile(options, g:save_window_file)
"	endfunction
"augroup END
"if filereadable(g:save_window_file)
"  execute 'source' g:save_window_file
"endif "}}}

" Loading divided files {{{
let g:local_vimrc = expand('~/.vimrc.local')
if filereadable(g:local_vimrc)
	execute 'source ' . g:local_vimrc
endif
"}}}

" must be written at the last.  see :help 'secure'.
set secure

" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
"}}}1
