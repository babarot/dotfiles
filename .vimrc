function! s:vimrc()
  let env = {}

  let env.is_windows = has('win16') || has('win32') || has('win64')
  let env.is_cygwin = has('win32unix')
  let env.is_mac = !env.is_windows && !env.is_cygwin
        \ && (has('mac') || has('macunix') || has('gui_macvim') ||
        \    (!executable('xdg-open') &&
        \    system('uname') =~? '^darwin'))
  let env.is_linux = !env.is_mac && has('unix')


  let env.is_starting = has('vim_starting')
  let env.is_gui      = has('gui_running')
  let env.hostname    = substitute(hostname(), '[^\w.]', '', '')

  if env.is_windows
    let vimpath = expand('~/vimfiles')
  else
    let vimpath = expand('~/.vim')
  endif

  let env.path = {
        \ 'vim': vimpath,
        \ }

  let env.is_tmux_running = !empty($TMUX)
  let env.tmux_proc = system('tmux display-message -p "#W"')

  let env.vimrc = {
        \ 'plugin_on': v:true,
        \ 'suggest_neobundleinit': v:true,
        \ 'goback_to_eof2bof': v:false,
        \ 'save_window_position': v:true,
        \ 'restore_cursor_position': v:true,
        \ 'statusline_manually': v:true,
        \ 'add_execute_perm': v:false,
        \ 'colorize_statusline_insert': v:true,
        \ 'manage_rtp_manually': v:true,
        \ 'auto_cd_file_parentdir': v:true,
        \ 'ignore_all_settings': v:true,
        \ 'check_plug_update': v:true,
        \ }

  return env
endfunction

" g:env is an environment variable in vimrc
let g:env = s:vimrc()

let g:plugin = {
      \ "plugs":  get(g:, 'plugs', {}),
      \ "plug":   expand(g:env.path.vim) . "/autoload/plug.vim",
      \ "base":   expand(g:env.path.vim) . "/plugged",
      \ "url":    "https://raw.github.com/junegunn/vim-plug/master/plug.vim",
      \ "github": "https://github.com/junegunn/vim-plug",
      \ }

function! s:mkdir(dir) "{{{1
  if !exists("*mkdir")
    return g:false
  endif

  let dir = expand(a:dir)
  if isdirectory(dir)
    return v:true
  endif

  return mkdir(dir, "p")
endfunction

function! Mkdir(dir) abort
  return s:mkdir(a:dir)
endfunction

tnoremap <silent> <ESC> <C-\><C-n>

scriptencoding utf-8
set runtimepath&

" Check if there are plugins not to be installed
augroup vimrc-check-plug
  autocmd!
  autocmd VimEnter * if !argc() | call g:plugin.check_installation() | endif
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

set number
set clipboard+=unnamed
set pumheight=10
set lazyredraw
set ttyfast
set modeline
set modelines=5
"set keywordprg=:help
"set helplang& helplang=ja
set ignorecase
set smartcase
set incsearch
set hlsearch
set autoread
set autowrite
set switchbuf=useopen,usetab,newtab
set nostartofline
set expandtab
set autoindent
set backspace=indent,eol,start
set wrapscan
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set wildmenu
set wildmode=longest,full
set wildignore&
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store
set ruler
set rulerformat=%m%r%=%l/%L
set shiftwidth=4
set tabstop=4
let &showbreak = '+++ '
set laststatus=2
set cmdheight=2
set showmode
set showcmd
set notitle
set smartindent
set smarttab
set whichwrap=b,s,h,l,<,>,[,]
set hidden
set textwidth=0
set formatoptions&
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set formatoptions-=v
set formatoptions+=l
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<
set listchars=eol:<,tab:>.
set nrformats=alpha,hex
set winaltkeys=no
set novisualbell
set vb t_vb=
set noequalalways
set history=10000
set wrap
set mousehide
set virtualedit=block
set virtualedit& virtualedit+=block
set fileformat=unix
set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif
set encoding=utf-8
set fileencoding=japan
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932
set foldenable
set foldlevel=0
set foldcolumn=2
set iminsert=0 imsearch=0
set noimcmdline
if g:env.is_windows
    set shellslash "Exchange path separator
endif

if has('persistent_undo')
    set undofile
    let &undodir = g:env.path.vim . '/undo'
    call Mkdir(&undodir)
endif
" Use clipboard
if has('clipboard')
    set clipboard=unnamed
endif

if has('patch-7.4.338')
    set breakindent
endif

function! g:plugin.ready()
  return filereadable(self.plug)
endfunction

" git commit 時にはプラグインは読み込まない
if $HOME != $USERPROFILE && $GIT_EXEC_PATH != ''
  finish
end


" Add plug's plugins
" let g:plugin.plugs = get(g:, 'plugs', {})
" let g:plugin.list  = keys(g:plugin.plugs)

let g:terraform_fmt_on_save = 1

if !g:plugin.ready()
  function! g:plugin.init()
    let ret = system(printf("curl -fLo %s --create-dirs %s", self.plug, self.url))
    if v:shell_error
      return Error('g:plugin.init: error occured')
    endif

    if !g:env.is_gui
      silent! !vim
      quit!
    endif
  endfunction
  command! PlugInit call g:plugin.init()

  if g:env.vimrc.suggest_neobundleinit == g:true
    autocmd! VimEnter * redraw
          \ | echohl WarningMsg
          \ | echo "You should do ':PlugInit' at first!"
          \ | echohl None
  else
    PlugInit
  endif
endif

function! g:plugin.is_installed(strict, ...)
  let list = []
  if type(a:strict) != type(0)
    call add(list, a:strict)
  endif
  let list += a:000

  for arg in list
    let name   = substitute(arg, '^vim-\|\.vim$', "", "g")
    let prefix = "vim-" . name
    let suffix = name . ".vim"

    if a:strict == 1
      let name   = arg
      let prefix = arg
      let suffix = arg
    endif

    if has_key(self.plugs, name)
          \ ? isdirectory(self.plugs[name].dir)
          \ : has_key(self.plugs, prefix)
          \ ? isdirectory(self.plugs[prefix].dir)
          \ : has_key(self.plugs, suffix)
          \ ? isdirectory(self.plugs[suffix].dir)
          \ : v:false
      continue
    else
      return v:false
    endif
  endfor

  return v:true
endfunction

function! g:plugin.installed(name)
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction

function! g:plugin.is_rtp(p)
  return index(split(&rtp, ","), get(self.plugs[a:p], "dir")) != -1
endfunction

function! g:plugin.is_loaded(p)
  return g:plugin.is_installed(1, a:p) && g:plugin.is_rtp(a:p)
endfunction

function! g:plugin.check_installation()
  if empty(self.plugs)
    return
  endif

  let list = []
  for [name, spec] in items(self.plugs)
    if !isdirectory(spec.dir)
      call add(list, spec.uri)
    endif
  endfor

  if len(list) > 0
    let unplugged = map(list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')
    " Ask whether installing plugs like NeoBundle
    echomsg 'Not installed plugs: ' . string(unplugged)
    if confirm('Install plugs now?', "yes\nNo", 2) == 1
      PlugInstall
      " Close window for vim-plug
      "silent! close
      "" Restart vim
      "if !g:env.is_gui
      "     silent! !vim
      "     quit!
      "endif
    endif
  endif
endfunction

if g:plugin.ready() && g:env.vimrc.plugin_on
  function! PlugList(A,L,P)
    return join(g:plugin.list, "\n")
  endfunction

  command! -nargs=1 -complete=custom,PlugList PlugHas
        \ if g:plugin.is_installed('<args>')
        \ | echo g:plugin.plugs['<args>'].dir
        \ | endif
endif

if executable('golsp')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'go-lang',
          \ 'cmd': {server_info->['golsp', '-mode', 'stdio']},
          \ 'whitelist': ['go'],
          \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
  augroup END
endif
set showtabline=2
set laststatus=2

""" Fern
" Show hidden files
let g:fern#default_hidden=1

" Show file tree with Ctrl+n
nnoremap <C-f> :Fern . -reveal=% -drawer -toggle -width=40<CR>

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

command! RemoveBlankLine silent! global/^$/delete | nohlsearch | normal! ``

" Show all runtimepaths.
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>
" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap [Space]h ^
noremap [Space]l $

inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
cnoremap <C-l> <RIGHT>
cnoremap <C-h> <LEFT>
cnoremap <C-d> <DELETE>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
cnoremap <C-f> <RIGHT>
cnoremap <C-b> <LEFT>
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-n> <Up>
inoremap <C-p> <Down>
inoremap <C-m> <CR>

nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
vnoremap <C-j><C-j> <ESC>
onoremap jj <ESC>
inoremap j[Space] j
onoremap j[Space] j
nnoremap : ;
nnoremap ; :
nnoremap q; q:
vnoremap : ;
vnoremap ; :
vnoremap q; q:
cnoreabbrev w!! w !sudo tee > /dev/null %
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

nnoremap n nzz
nnoremap N Nzz
nnoremap S *zz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <C-g> 1<C-g>
nnoremap <silent><CR> :<C-u>silent update<CR>
noremap gf gF
noremap gF gf
vnoremap v $h
nnoremap Y y$
cmap <c-x> <c-r>=expand('%:p:h')<cr>/
cmap <c-z> <c-r>=expand('%:p:r')<cr>
nnoremap <silent> <Leader>r :<C-u>call <SID>toggle_option('relativenumber')<CR>
nnoremap <silent> <Leader>s :<C-u>call <SID>toggle_option('spell')<CR>
nnoremap <silent> ~ :let &tabstop = (&tabstop * 2 > 16) ? 2 : &tabstop * 2<CR>:echo 'tabstop:' &tabstop<CR>
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz'
nnoremap <silent>W :<C-u>keepjumps normal! }<CR>
nnoremap <silent>B :<C-u>keepjumps normal! {<CR>
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <Leader>y :<C-u>%y<CR>
nnoremap <Leader>Y :<C-u>%y<CR>
nnoremap t <Nop>
nnoremap <silent> [Space]t :<C-u>tabclose<CR>:<C-u>tabnew<CR>
nnoremap <silent> tt :<C-u>tabnew<CR>
nnoremap <silent> tT :<C-u>tabnew<CR>:<C-u>tabprev<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>
nnoremap <silent> tm :<C-u>call <SID>move_to_tab()<CR>
function! s:move_to_tab()
    tab split
    tabprevious
    if winnr('$') > 1
        close
    elseif bufnr('$') > 1
        buffer #
    endif
    tabnext
endfunction
nnoremap <silent> <C-t>L  :<C-u>call <SID>move_tabpage("right")<CR>
nnoremap <silent> <C-t>H  :<C-u>call <SID>move_tabpage("left")<CR>
nnoremap <silent> <C-t>dh :<C-u>call <SID>close_all_left_tabpages()<CR>
nnoremap <silent> <C-t>dl :<C-u>call <SID>close_all_right_tabpages()<CR>
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

nnoremap <silent> <C-x>u :<C-u>call <SID>buf_restore()<CR>
nnoremap <silent> <C-x>d     :Delete<CR>
nnoremap <silent> <C-x><C-d> :Delete!<CR>

" Windows
nnoremap s <Nop>
nnoremap sp :<C-u>split<CR>
nnoremap vs :<C-u>vsplit<CR>
function! s:vsplit_or_wincmdw()
  if winnr('$') == 1
    return ":vsplit\<CR>"
  else
    return ":wincmd w\<CR>"
  endif
endfunction
nnoremap <expr><silent> ss <SID>vsplit_or_wincmdw()
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap t <Nop>
nnoremap <silent> [Space]t :<C-u>tabclose<CR>:<C-u>tabnew<CR>
nnoremap <silent> tt :<C-u>tabnew<CR>
nnoremap <silent> tT :<C-u>tabnew<CR>:<C-u>tabprev<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>

nnoremap <silent>z0 :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR><CR>
nnoremap <silent> [Space]g :<C-u>!tig blame +<C-r>=line('.')<CR> %<CR>:redraw!<CR>

if g:plugin.ready()
  call plug#begin()
  Plug 'caglartoklu/ftcolor.vim'
  Plug 'AndrewRadev/gapply.vim'
  Plug 'b4b4r07/vim-xcursor'
  Plug 'b4b4r07/vim-ansible-vault'
  Plug 'b4b4r07/vim-hcl'
  Plug 'b4b4r07/vim-shellutils'
  Plug 'b4b4r07/vim-sqlfmt'
  Plug 'b4b4r07/vim-unicode'
  Plug 'chrisbra/csv.vim'
  Plug 'christianrondeau/vim-base64'
  Plug 'fatih/vim-hclfmt'
  Plug 'haya14busa/vim-gofmt'
  Plug 'hotwatermorning/auto-git-diff'
  Plug 'juliosueiras/vim-terraform-completion'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'cocopon/vaffle.vim'
  Plug 'lambdalisue/vim-gista'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  "Plug 'lambdalisue/fern-hijack.vim'
  Plug 'yuki-yano/fern-preview.vim'
  Plug 'mattn/goplayground-vim'
  Plug 'nanotech/jellybeans.vim'
  Plug 'osyo-manga/vim-anzu'
  Plug 'raphael/vim-present-simple'
  Plug 'thinca/vim-quickrun'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-surround'
  Plug 'tyru/caw.vim'
  Plug 'tyru/open-browser-github.vim'
  Plug 'tyru/open-browser.vim'
  Plug 'w0ng/vim-hybrid'
  Plug 'whatyouhide/vim-gotham'

  Plug 'fatih/vim-go',                 { 'for': 'go' }
  Plug 'jnwhiteh/vim-golang',          { 'for': 'go' }
  Plug 'keith/tmux.vim',               { 'for': 'tmux' }
  Plug 'dag/vim-fish',                 { 'for': 'fish' }
  Plug 'chase/vim-ansible-yaml',       { 'for': 'ansible' }
  Plug 'cespare/vim-toml',             { 'for': 'toml' }
  Plug 'elzr/vim-json',                { 'for': 'json' }
  Plug 'b4b4r07/vim-ltsv',             { 'for': 'ltsv' }
  Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
  Plug 'maksimr/vim-jsbeautify',       { 'for': 'javascript' }
  Plug 'plasticboy/vim-markdown',      { 'for': 'markdown' }
  Plug 'hashivim/vim-terraform'
  Plug 'rhysd/vim-fixjson', { 'for': 'json' }

  " color
  Plug 'AlessandroYorba/Despacio'
  Plug 'altercation/vim-colors-solarized'
  Plug 'arcticicestudio/nord-vim'
  Plug 'chriskempson/vim-tomorrow-theme'
  Plug 'cocopon/iceberg.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'morhetz/gruvbox'
  Plug 'nanotech/jellybeans.vim'
  Plug 'nightsense/snow'
  Plug 'nightsense/stellarized'
  Plug 'rhysd/vim-color-spring-night'
  Plug 'tomasr/molokai'
  Plug 'w0ng/vim-hybrid'
  Plug 'whatyouhide/vim-gotham'
  Plug 'yuttie/hydrangea-vim'


  "New
  Plug 'Shougo/ddc.vim'
  Plug 'vim-denops/denops.vim'
  Plug 'Shougo/ddc-ui-native'
  Plug 'Shougo/ddc-source-around'
  Plug 'Shougo/ddc-matcher_head'
  Plug 'Shougo/ddc-sorter_rank'

  call plug#end()
endif

let g:plugin.plugs = get(g:, 'plugs', {})

call map(sort(split(globpath(&runtimepath, '_config/*.vim'))), {->[execute('exec "source" v:val')]})

command! -nargs=? JQ call s:jq(<f-args>)
function! s:jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction
