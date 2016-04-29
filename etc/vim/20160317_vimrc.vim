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

if 0 | endif

" Use plain vim
" when vim was invoked by 'sudo' command
" or, invoked as 'git difftool'
if exists('$SUDO_USER') || exists('$GIT_DIR')
  finish
endif

" Environment: {{{1
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin  = has('win32unix')
let s:is_mac     = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \    (!executable('xdg-open') &&
      \    system('uname') =~? '^darwin'))
let s:is_linux   = !s:is_mac && has('unix')

function! s:vimrc_environment() "{{{2
  let env = {}

  let env.is_starting = has('vim_starting')
  let env.is_gui      = has('gui_running')
  let env.hostname    = substitute(hostname(), '[^\w.]', '', '')

  " vim
  if s:is_windows
    let vimpath = expand('~/vimfiles')
  else
    let vimpath = expand('~/.vim')
  endif

  " vim-plug
  "let plug    = vimpath . "/autoload/plug.vim"
  "let plugged = vimpath . "/plugged"
  "let env.is_plug = filereadable(plug)

  let env.path = {
        \ 'vim':     vimpath,
        \ }

  let env.bin = {
        \ 'ag':        executable('ag'),
        \ 'osascript': executable('osascript'),
        \ }

  " tmux
  let env.is_tmux_running = !empty($TMUX)
  let env.tmux_proc = system('tmux display-message -p "#W"')

  return env
endfunction "}}}2

" s:env is an environment variable in vimrc
let s:env   = s:vimrc_environment()
let s:true  = 1
let s:false = 0

" vimrc management variables
let s:vimrc_plugin_on                  = get(g:, 'vimrc_plugin_on',                  s:true)
let s:vimrc_suggest_neobundleinit      = get(g:, 'vimrc_suggest_neobundleinit',      s:true)
let s:vimrc_goback_to_eof2bof          = get(g:, 'vimrc_goback_to_eof2bof',          s:false)
let s:vimrc_save_window_position       = get(g:, 'vimrc_save_window_position',       s:false)
let s:vimrc_restore_cursor_position    = get(g:, 'vimrc_restore_cursor_position',    s:true)
let s:vimrc_statusline_manually        = get(g:, 'vimrc_statusline_manually',        s:true)
let s:vimrc_add_execute_perm           = get(g:, 'vimrc_add_execute_perm',           s:false)
let s:vimrc_colorize_statusline_insert = get(g:, 'vimrc_colorize_statusline_insert', s:true)
let s:vimrc_manage_rtp_manually        = get(g:, 's:vimrc_manage_rtp_manually',      s:false)
let s:vimrc_auto_cd_file_parentdir     = get(g:, 's:vimrc_auto_cd_file_parentdir',   s:true)
let s:vimrc_ignore_all_settings        = get(g:, 's:vimrc_ignore_all_settings',      s:false)
let s:vimrc_check_plug_update          = get(g:, 's:vimrc_check_plug_update',        s:true)

" if s:vimrc_manage_rtp_manually is s:true, s:vimrc_plugin_on is disabled.
let s:vimrc_plugin_on = s:vimrc_manage_rtp_manually == s:true ? s:false : s:vimrc_plugin_on

if s:env.is_starting "{{{2
  " Necesary for lots of cool vim things
  "set nocompatible
  " http://rbtnn.hateblo.jp/entry/2014/11/30/174749

  " Define the entire vimrc encoding
  scriptencoding utf-8
  " Initialize runtimepath
  set runtimepath&

  " Check if there are plugins not to be installed
  augroup vimrc-check-plug
    autocmd!
    if s:vimrc_check_plug_update == s:true
      autocmd VimEnter * if !argc() | call s:plug.check_installation() | endif
    endif
  augroup END

  " Vim starting time
  if has('reltime') "&& !exists('g:pluginit')
    let g:startuptime = reltime()
    augroup vimrc-startuptime
      autocmd!
      autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
            \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
    augroup END
  endif
endif "}}}

" Plug: {{{1

let s:plug = {
      \ "plug":   expand(s:env.path.vim) . "/autoload/plug.vim",
      \ "base":   expand(s:env.path.vim) . "/plugged",
      \ "url":    "https://raw.github.com/junegunn/vim-plug/master/plug.vim",
      \ "github": "https://github.com/junegunn/vim-plug",
      \ }

function! s:plug.ready()
  return filereadable(self.plug)
endfunction

if s:plug.ready() && s:vimrc_plugin_on
  " start to manage with vim-plug
  call plug#begin(s:plug.base)

  " file and directory
  Plug 'Shougo/unite.vim'
  Plug '~/Dropbox/b4b4r07/enhancd3/misc/vim'
  " Plug 'junkblocker/unite-tasklist'

  Plug 'b4b4r07/vim-shellutils'
  Plug 'b4b4r07/mru.vim'
  Plug 'junegunn/fzf', {
        \ 'do':     './install --bin',
        \ 'frozen': 0
        \ }
  Plug 'junegunn/fzf.vim'
  Plug 'justinmk/vim-dirvish', { 'on': 'Dirvish' }

  " tpope
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-endwise'

  " compl
  Plug has('lua') ? 'Shougo/neocomplete.vim' : 'Shougo/neocomplcache'
  Plug 'junegunn/vim-emoji'
  Plug 'rhysd/github-complete.vim'
  Plug 'ujihisa/neco-look'

  Plug 'lambdalisue/vim-gita'
  Plug 'tpope/vim-fugitive' | Plug 'idanarye/vim-merginal'

  " useful
  if s:env.is_gui
    Plug 'itchyny/lightline.vim'
  endif
  Plug 'Shougo/vimproc.vim',  { 'do': 'make' }
  Plug 'vim-jp/vimdoc-ja'
  Plug 'osyo-manga/vim-anzu'
  Plug 'tyru/caw.vim'
  Plug 'AndrewRadev/gapply.vim'

  " syntax? language support
  Plug 'cespare/vim-toml',    { 'for': 'toml' }
  Plug 'elzr/vim-json',       { 'for': 'json' }
  Plug 'fatih/vim-go',        { 'for': 'go'   }
  Plug 'jnwhiteh/vim-golang', { 'for': 'go'   }
  "Plug 'zaiste/tmux.vim',     { 'for': 'tmux' }
  Plug 'keith/tmux.vim',      { 'for': 'tmux' }
  Plug 'dag/vim-fish',        { 'for': 'fish' }

  " colorscheme
  Plug 'b4b4r07/solarized.vim'
  Plug 'w0ng/vim-hybrid'
  Plug 'junegunn/seoul256.vim'
  Plug 'nanotech/jellybeans.vim'

  " Add plugins to &runtimepath
  call plug#end()
endif

" Add plug's plugins
let s:plug.plugs = get(g:, 'plugs', {})
let s:plug.list  = keys(s:plug.plugs)

" Plug's helper functions "{{{2
if !s:plug.ready()
  function! s:plug.init()
    let ret = system(printf("curl -fLo %s --create-dirs %s", self.plug, self.url))
    "call system(printf("git clone %s", self.github))
    if v:shell_error
      echomsg 's:plug_init: error occured'
      return 1
    endif

    " Restart vim
    "silent! !vim --cmd "let g:pluginit = 1" -c 'echomsg "Run :PlugInstall"'
    silent! !vim
    quit!
  endfunction
  command! PlugInit call s:plug.init()

  if s:vimrc_suggest_neobundleinit == s:true
    autocmd! VimEnter * redraw
          \ | echohl WarningMsg
          \ | echo "You should do ':PlugInit' at first!"
          \ | echohl None
  else
    " Install vim-plug
    PlugInit
  endif
endif

function! s:plug.is_installed(strict, ...)
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
                    \ : s:false
            continue
        else
            return s:false
        endif
    endfor

    return s:true
endfunction

function! s:plug.is_rtp(p)
    return index(split(&rtp, ","), get(self.plugs[a:p], "dir")) != -1
endfunction

function! s:plug.is_loaded(p)
    return s:plug.is_installed(1, a:p) && s:plug.is_rtp(a:p)
endfunction

function! s:plug.check_installation()
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
      silent! close
      " Restart vim
      silent! !vim
      quit!
    endif

  endif
endfunction

" Functions: {{{1
function! s:has_plugin(name) "{{{2
  " Check {name} plugin whether there is in the runtime path
  let nosuffix = a:name =~? '\.vim$' ? a:name[:-5] : a:name
  let suffix   = a:name =~? '\.vim$' ? a:name      : a:name . '.vim'
  return &rtp =~# '\c\<' . nosuffix . '\>'
        \   || globpath(&rtp, suffix, 1) != ''
        \   || globpath(&rtp, nosuffix, 1) != ''
        \   || globpath(&rtp, 'autoload/' . suffix, 1) != ''
        \   || globpath(&rtp, 'autoload/' . tolower(suffix), 1) != ''
endfunction

function! s:mkdir(dir) "{{{2
  if !exists("*mkdir")
    return s:false
  endif

  let dir = expand(a:dir)
  if isdirectory(dir)
    return s:true
  endif

  return mkdir(dir, "p")
endfunction

function! GetBufname(bufnr, ...) "{{{2
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
  if a:0 && a:1 ==# 't'
    return fnamemodify(bufname, ':t')
  elseif a:0 && a:1 ==# 'f'
    return (fnamemodify(bufname, ':~:p'))
  elseif a:0 && a:1 ==# 's'
    return pathshorten(fnamemodify(bufname, ':~:h')).'/'.fnamemodify(bufname, ':t')
  endif
  return bufname
endfunction

" Apperance: {{{1
syntax enable on
set number

if s:env.is_gui
  set background=light
else
  set background=dark
endif

set t_Co=256
if s:plug.is_installed("solarized.vim") && $TERM_PROGRAM ==# "Apple_Terminal"
  colorscheme solarized
"elseif s:plug.is_installed("seoul256.vim")
  "colorscheme seoul256.vim
elseif s:plug.is_installed("hybrid")
  colorscheme hybrid
endif

" StatusLine {{{2
set laststatus=2

highlight BlackWhite ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none
highlight WhiteBlack ctermfg=white ctermbg=black cterm=none guifg=white guibg=black gui=none

function! MakeStatusLine()
  let line = ''
  let line .= '[%n] '
  let line .= '%f'
  let line .= ' %m'
  let line .= '%<'

  let line .= '%='
  let line .= '%#BlackWhite#'
  let line .= '%y'
  let line .= "[%{(&fenc!=#''?&fenc:&enc).(&bomb?'(BOM)':'')}:"
  let line .= "%{&ff.(&bin?'(BIN'.(&eol?'':'-noeol').')':'')}]"
  let line .= '%r'
  let line .= '%h'
  let line .= '%w'
  let line .= ' %l/%LL %2vC'
  let line .= ' %3p%%'

  if s:vimrc_statusline_manually == s:true
    return line
  else
    return ''
  endif
endfunction

function! MakeBigStatusLine()
  if s:vimrc_statusline_manually == s:true
    set statusline=
    set statusline+=%#BlackWhite#
    set statusline+=[%n]:
    if filereadable(expand('%'))
      set statusline+=%{GetBufname(bufnr('%'),'s')}
    else
      set statusline+=%F
    endif
    set statusline+=\ %m
    set statusline+=%#StatusLine#

    set statusline+=%=
    set statusline+=%#BlackWhite#
    if exists('*TrailingSpaceWarning')
      "set statusline+=%{TrailingSpaceWarning()}
    endif
    set statusline+=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
    set statusline+=%r
    set statusline+=%h
    set statusline+=%w
    if exists('*GetFileSize')
      set statusline+=[%{GetFileSize()}]
    endif
    if exists('*GetCharacterCode')
      set statusline+=[%{GetCharacterCode()}]
    endif
    set statusline+=\ %4l/%4LL,%3cC\ %3p%%
    if exists('*WordCount')
      set statusline+=\ [WC=%{WordCount()}]
    endif
    if exists('*GetDate')
      set statusline+=\ (%{GetDate()})
    endif
  endif
endfunction

if !s:plug.is_installed('lightline.vim')
  call MakeBigStatusLine()
  if s:vimrc_statusline_manually == s:true
    " Refresh Manually StatusLine
    augroup automatically-statusline
      autocmd!
      autocmd BufEnter * call MakeBigStatusLine()
    augroup END
  endif

  augroup minimal-statusline
    autocmd!
    autocmd WinEnter,CursorMoved * if winwidth(0) <  &columns | set statusline=%!MakeStatusLine() | endif
  augroup END
endif

" Tabpages {{{2
set showtabline=2
set tabline=%!MakeTabLine()

function! s:tabpage_label(n) "{{{3
  let n = a:n
  let bufnrs = tabpagebuflist(n)
  let curbufnr = bufnrs[tabpagewinnr(n) - 1]

  let hi = n == tabpagenr() ? 'TabLineSel' : 'TabLine'

  let label = ''
  let no = len(bufnrs)
  if no == 1
    let no = ''
  endif
  let mod = len(filter(bufnrs, 'getbufvar(v:val, "&modified")')) ? '+' : ''
  let sp = (no . mod) ==# '' ? '' : ' '
  let fname = GetBufname(curbufnr, 's')

  if no !=# ''
    let label .= '%#' . hi . 'Number#' . no
  endif
  let label .= '%#' . hi . '#'
  let label .= fname . sp . mod

  return '%' . a:n . 'T' . label . '%T%#TabLineFill#'
endfunction

function! MakeTabLine() "{{{3
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' | '
  let tabs = join(titles, sep) . sep . '%#TabLineFill#%T'

  "hi TabLineFill ctermfg=white
  let info = '%#TabLineFill#'
  let info .= fnamemodify(getcwd(), ':~') . ' '
  return tabs . '%=' . info
endfunction

function! GuiTabLabel() "{{{3
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  " Append the tab number
  "let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  "let label .= name
  let label .= GetBufname('%', 't')
  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')

  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in l:bufnrlist
    if getbufvar(bufnr, "&modified")
      let l:label .= ' +'
      break
    endif
  endfor
  let wincount = wincount == 1 ? '' : wincount . ' '

  ""return label . '  [' . wincount . ']'
  return wincount . label
endfunction "}}}

" Emphasize statusline in the insert mode {{{2
if !s:plug.is_installed('lightline.vim')
  augroup colorize-statusline-insert
    autocmd!
    autocmd InsertEnter * call s:colorize_statusline_insert('Enter')
    autocmd InsertLeave * call s:colorize_statusline_insert('Leave')
  augroup END

  function! ReverseHighlight(hi)
    let hl = a:hi
    let hl = substitute(hl, 'fg', 'swp', 'g')
    let hl = substitute(hl, 'bg', 'fg',  'g')
    let hl = substitute(hl, 'swp', 'bg', 'g')
    return hl
  endfunction
  function! GetHighlight(hi)
    redir => hl
    silent execute 'highlight ' . a:hi
    redir END
    return substitute(hl, '.*xxx ', '', '')
  endfunction

  let s:hi_insert = 'highlight StatusLine ' . ReverseHighlight(GetHighlight('ModeMsg'))
  let s:slhlcmd = ''

  function! s:colorize_statusline_insert(mode)
    if a:mode == 'Enter'
      let s:slhlcmd = 'highlight StatusLine ' . GetHighlight('StatusLine')
      silent execute s:hi_insert

    elseif a:mode == 'Leave'
      highlight clear StatusLine
      silent execute s:slhlcmd
    endif
  endfunction

endif

" Cursor line/column {{{2
set cursorline
augroup auto-cursorcolumn-appear
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorcolumn('CursorMoved')
  autocmd CursorHold,CursorHoldI   * call s:auto_cursorcolumn('CursorHold')
  autocmd BufEnter * call s:auto_cursorcolumn('WinEnter')
  autocmd BufLeave * call s:auto_cursorcolumn('WinLeave')

  let s:cursorcolumn_lock = 0
  function! s:auto_cursorcolumn(event)
    if a:event ==# 'WinEnter'
      setlocal cursorcolumn
      let s:cursorcolumn_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorcolumn
    elseif a:event ==# 'CursorMoved'
      setlocal nocursorcolumn
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

augroup multi-window-toggle-cursor "{{{2
  autocmd!
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline nocursorcolumn
augroup END 

augroup cursor-highlight-emphasis "{{{2
  autocmd!
  autocmd CursorMoved,CursorMovedI,WinLeave * hi! link CursorLine CursorLine | hi! link CursorColumn CursorColumn
  autocmd CursorHold,CursorHoldI            * hi! link CursorLine Visual     | hi! link CursorColumn Visual
augroup END

" GUI IME Cursor colors {{{2
if has('multi_byte_ime') || has('xim')
  highlight Cursor guibg=NONE guifg=Yellow
  highlight CursorIM guibg=NONE guifg=Red
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    ""set imactivatekey=s-space
  endif
  inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif

" ZEN-KAKU
" Display zenkaku-space {{{2
augroup hilight-idegraphic-space
  autocmd!
  "autocmd VimEnter,ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  "autocmd WinEnter * match IdeographicSpace /　/
  autocmd VimEnter,ColorScheme * call <SID>hl_trailing_spaces()
  autocmd VimEnter,ColorScheme * call <SID>hl_zenkaku_space()
augroup END

function! s:hl_trailing_spaces()
  highlight! link TrailingSpaces Error
  syntax match TrailingSpaces containedin=ALL /\s\+$/
endfunction

function! s:hl_zenkaku_space()
  highlight! link ZenkakuSpace Error
  syntax match ZenkakuSpace containedin=ALL /　/
endfunction

" Options: {{{1
" Set options (boolean, number, string). General vim behavior.
" For more information about options, see :help 'option-list'.
"==============================================================================

set pumheight=10

" Don't redraw while executing macros
set lazyredraw

" Fast terminal connection
set ttyfast

" Enable the mode line
set modeline

" The length of the mode line
set modelines=5

" Vim internal help with the command K
set keywordprg=:help

" Language help
set helplang& helplang=ja

" Ignore case
set ignorecase

" Smart ignore case
set smartcase

" Enable the incremental search
set incsearch

" Emphasize the search pattern
set hlsearch

" Have Vim automatically reload changed files on disk. Very useful when using
" git and switching between branches
set autoread

" Automatically write buffers to file when current window switches to another
" buffer as a result of :next, :make, etc. See :h autowrite.
set autowrite

" Behavior when you switch buffers
set switchbuf=useopen,usetab,newtab

" Moves the cursor to the same column when cursor move
set nostartofline

" Use tabs instead of spaces
"set noexpandtab
set expandtab

" When starting a new line, indent in automatic
set autoindent

" The function of the backspace
set backspace=indent,eol,start

" When the search is finished, search again from the BOF
set wrapscan

" Emphasize the matching parenthesis
set showmatch

" Blink on matching brackets
set matchtime=1

" Increase the corresponding pairs
set matchpairs& matchpairs+=<:>

" Extend the command line completion
set wildmenu

" Wildmenu mode
set wildmode=longest,full

" Ignore compiled files
set wildignore&
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store

" Show line and column number
set ruler
set rulerformat=%m%r%=%l/%L

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

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

" When you create a new line, perform advanced automatic indentation
set smartindent

" Blank is inserted only the number of 'shiftwidth'.
set smarttab

" Moving the cursor left and right will be modern.
set whichwrap=b,s,h,l,<,>,[,]

" Hide buffers instead of unloading them
set hidden

" The maximum width of the input text
set textwidth=0

set formatoptions&
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set formatoptions-=v
set formatoptions+=l

" Identifying problems and bringing them to the foreground
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<
set listchars=eol:<,tab:>.

" Increase or decrease items
set nrformats=alpha,hex

" Do not use alt key on Win
set winaltkeys=no

" Do not use visualbell
set novisualbell
set vb t_vb=

" Automatically equal size when opening
set noequalalways

" History size
set history=10000
set wrap

"set helpheight=999
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

set foldenable
"set foldmethod=marker
"set foldopen=all
"set foldclose=all
set foldlevel=0
"set foldnestmax=2
set foldcolumn=2

" IM settings
" IM off when starting up
set iminsert=0 imsearch=0
" Use IM always
"set noimdisable
" Disable IM on cmdline
set noimcmdline

" Change some neccesary settings for win
if s:is_windows
  set shellslash "Exchange path separator
endif

if has('persistent_undo')
  set undofile
  let &undodir = s:env.path.vim . '/undo'
  call s:mkdir(&undodir)
endif

" Use clipboard
if has('clipboard')
  set clipboard=unnamed
endif

if has('patch-7.4.338')
  set breakindent
endif

" Map: {{{1
if s:env.is_starting
  mapclear
  mapclear!
endif

" Use backslash
if s:is_mac
  noremap ¥ \
  noremap \ ¥
endif

" Define mapleader
let mapleader = ','
let maplocalleader = ','

" Smart space mapping
" Notice: when starting other <Space> mappings in noremap, disappeared [Space]
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
vnoremap <C-j><C-j> <ESC>
onoremap jj <ESC>
inoremap j[Space] j
onoremap j[Space] j
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

cnoreabbrev w!! w !sudo tee > /dev/null %
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap [Space]h ^
noremap [Space]l $

nnoremap n nzz
nnoremap N Nzz

" Search word under cursor
nnoremap S *zz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" View file information
nnoremap <C-g> 1<C-g>

" Write only when the buffer has been modified
nnoremap <silent><CR> :<C-u>silent update<CR>

" Goto file under cursor
noremap gf gF
noremap gF gf

" Type 'v', select end of line in visual mode
vnoremap v $h

" Make Y behave like other capitals
nnoremap Y y$

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

" expand path
cmap <c-x> <c-r>=expand('%:p:h')<cr>/
" expand file (not ext)
cmap <c-z> <c-r>=expand('%:p:r')<cr>

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

" Commands: {{{1
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

" Plugins: {{{1
if s:plug.is_installed("vim-plug") "{{{2
  function! PlugList(A,L,P)
    return join(s:plug.list, "\n")
  endfunction

  command! -nargs=1 -complete=custom,PlugList PlugHas
        \ if s:plug.is_installed('<args>')
        \ | echo s:plug.plugs['<args>'].dir
        \ | endif
endif

if s:plug.is_installed("caw") "{{{2
  vmap <C-k> <Plug>(caw:i:toggle)
  vmap K     <Plug>(caw:i:toggle)
endif

if s:plug.is_installed("fzf.vim") && s:plug.is_installed("fzf")
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'tab split',
        \ 'ctrl-v': 'tab split' }

  function! s:search_with_ag_under_cursor()
    let s:vimrc_auto_cd_file_parentdir = s:false
    let cwd = expand('%:p:h')
    silent! call s:root()

    call fzf#vim#ag(expand('<cword>'), {
          \ 'sink': 'edit',
          \ 'options': '--ansi --delimiter : --nth 4..,.. --prompt "Ag?> " '.
          \            '--color hl:68,hl+:110 --multi '.
          \            '--bind=ctrl-d:page-down,ctrl-u:page-up ',
          \ 'tmux_height': '40%',
          \ })
    "execute 'lcd' cwd
    execute 'lcd' expand('%:p:h')
    let s:vimrc_auto_cd_file_parentdir = s:true
  endfunction
  nnoremap <silent> K :call <SID>search_with_ag_under_cursor()<CR>

  nnoremap <silent> <Leader>m :call fzf#run({
        \ 'source': 'sed "1d" $HOME/.vim_mru_files',
        \ 'options' : '+s -e -m',
        \ 'tmux_height': '40%',
        \ 'sink': 'tabe'
        \ })<CR>
endif

if s:plug.is_installed("anzu") "{{{2
  nmap n <Plug>(anzu-n)
  nmap N <Plug>(anzu-N)
  nmap * <Plug>(anzu-star)
  nmap # <Plug>(anzu-sharp)
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
  nmap * <Plug>(anzu-star-with-echo)
  nmap # <Plug>(anzu-sharp-with-echo)

  augroup vim-anzu
    autocmd!
    autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
  augroup END
endif

if s:plug.is_installed("fzf.vim")
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'tab split',
        \ 'ctrl-v': 'tab split' }

  function! s:search_with_ag_under_cursor()
    let s:vimrc_auto_cd_file_parentdir = s:false
    let cwd = expand('%:p:h')
    silent! call s:root()

    call fzf#vim#ag(expand('<cword>'), {
          \ 'sink': 'edit',
          \ 'options': '--ansi --delimiter : --nth 4..,.. --prompt "Ag?> " '.
          \            '--color hl:68,hl+:110 --multi '.
          \            '--bind=ctrl-d:page-down,ctrl-u:page-up ',
          \ 'tmux_height': '40%',
          \ })
    "execute 'lcd' cwd
    execute 'lcd' expand('%:p:h')
    let s:vimrc_auto_cd_file_parentdir = s:true
  endfunction
  nnoremap <silent> K :call <SID>search_with_ag_under_cursor()<CR>

  nnoremap <silent> <Leader>m :call fzf#run({
        \ 'source': 'sed "1d" $HOME/.vim_mru_files',
        \ 'options' : '+s -e -m',
        \ 'tmux_height': '40%',
        \ 'sink': 'tabe'
        \ })<CR>
endif

if s:plug.is_installed("vim-dirvish") "{{{2
  " Override netrw
  let g:dirvish_hijack_netrw = 1

  augroup my_dirvish_events
    au!
    " always show hidden files
    au User DirvishEnter let b:dirvish.showhidden = 1
  augroup END

  nnoremap <silent> [Space]d :<C-u>call <SID>toggle_dirvish()<CR>
  function! s:toggle_dirvish()
    if &filetype == 'dirvish'
      if exists('b:dirvish')
        if winnr('$') > 1
          wincmd c
        else
          bdelete
        endif
      endif
    else
      Dirvish
    endif
  endfunction
endif

if s:plug.is_installed("neocomplete.vim") "{{{2
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#enable_camel_case = 1
  let g:neocomplete#enable_underbar_completion = 1
  let g:neocomplete#enable_fuzzy_completion = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#auto_completion_start_length = 2
  let g:neocomplete#manual_completion_start_length = 0
  let g:neocomplete#min_keyword_length = 3
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:jedi#auto_vim_configuration = 0
  let g:neocomplete#sources#omni#input_patterns = {
        \ 'ruby' : '[^. *\t]\.\w*\|\h\w*::',
        \}
  let g:neocomplete#force_omni_input_patterns = {
        \ 'python': '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        \}

  let g:neocomplete#enable_auto_delimiter = 1
  let g:neocomplete#disable_auto_select_buffer_name_pattern =
        \ '\[Command Line\]'
  let g:neocomplete#max_list = 100
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#enable_auto_close_preview = 1

  let g:neocomplete#force_omni_input_patterns.markdown =
        \ ':\w*'
  let g:neocomplete#force_omni_input_patterns.ruby =
        \ '[^. *\t]\.\w*\|\h\w*::\w*'

  let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

  let g:neocomplete#sources#omni#functions.go =
        \ 'gocomplete#Complete'

  let g:neocomplete#sources#omni#input_patterns.php =
        \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  "if !exists('g:neocomplete#keyword_patterns')
  "  let g:neocomplete#keyword_patterns = {}
  "endif
  "let g:neocomplete#keyword_patterns._ = '\h\w*'
  "let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'
  "let g:neocomplete#keyword_patterns.rst =
  "      \ '\$\$\?\w*\|[[:alpha:]_.\\/~-][[:alnum:]_.\\/~-]*\|\d\+\%(\.\d\+\)\+'

  "let g:neocomplete#ignore_source_files = []

  "let g:neocomplete#enable_at_startup = 1
  "let g:neocomplete#disable_auto_complete = 0
  "let g:neocomplete#enable_smart_case = 1
  "let g:neocomplete#enable_camel_case = 1
  "let g:neocomplete#enable_fuzzy_completion = 1
  "let g:neocomplete#auto_completion_start_length = 2
  "let g:neocomplete#manual_completion_start_length = 0
  "let g:neocomplete#min_keyword_length = 3
  "let g:neocomplete#enable_auto_select = 1
  "let g:neocomplete#enable_cursor_hold_i = 0

  "let g:neocomplete#enable_auto_delimiter = 1
  "let g:neocomplete#disable_auto_select_buffer_name_pattern =
  "      \ '\[Command Line\]'
  "let g:neocomplete#max_list = 100
  "if !exists('g:neocomplete#sources#omni#input_patterns')
  "  let g:neocomplete#sources#omni#input_patterns = {}
  "endif
  "if !exists('g:neocomplete#sources#omni#functions')
  "  let g:neocomplete#sources#omni#functions = {}
  "endif
  "if !exists('g:neocomplete#force_omni_input_patterns')
  "  let g:neocomplete#force_omni_input_patterns = {}
  "endif
  "let g:neocomplete#enable_auto_close_preview = 1

  "let g:neocomplete#force_omni_input_patterns.markdown =
  "      \ ':\w*'
  "let g:neocomplete#force_omni_input_patterns.ruby =
  "      \ '[^. *\t]\.\w*\|\h\w*::\w*'

  "let g:neocomplete#force_omni_input_patterns.python =
  "      \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

  "let g:neocomplete#sources#omni#functions.go =
  "      \ 'gocomplete#Complete'

  "let g:neocomplete#sources#omni#input_patterns.php =
  "      \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  "if !exists('g:neocomplete#keyword_patterns')
  "  let g:neocomplete#keyword_patterns = {}
  "endif
  "let g:neocomplete#keyword_patterns._ = '\h\w*'
  "let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'
  "let g:neocomplete#keyword_patterns.rst =
  "      \ '\$\$\?\w*\|[[:alpha:]_.\\/~-][[:alnum:]_.\\/~-]*\|\d\+\%(\.\d\+\)\+'

  "let g:neocomplete#ignore_source_files = []

  "let g:neocomplete#sources#vim#complete_functions = {
  "      \ 'Emoji' : 'emoji#complete',
  "      \ 'Ref' : 'ref#complete',
  "      \ 'Unite' : 'unite#complete_source',
  "      \ 'VimShellExecute' :
  "      \      'vimshell#vimshell_execute_complete',
  "      \ 'VimShellInteractive' :
  "      \      'vimshell#vimshell_execute_complete',
  "      \ 'VimShellTerminal' :
  "      \      'vimshell#vimshell_execute_complete',
  "      \ 'VimShell' : 'vimshell#complete',
  "      \ 'VimFiler' : 'vimfiler#complete',
  "      \ 'Vinarise' : 'vinarise#complete',
  "      \}
  ""call neocomplete#custom#source('look', 'min_pattern_length', 4)

  "" mappings."{{{
  "" <C-f>, <C-b>: page move.
  "inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
  "inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
  "" <C-h>, <BS>: close popup and delete backword char.
  ""inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
  ""inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
  "" <C-n>: neocomplete.
  "inoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
  "" <C-p>: keyword completion.
  "inoremap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
  "inoremap <expr> '  pumvisible() ? "\<C-y>" : "'"

  "inoremap <silent><expr> <C-x><C-f>
  "      \ neocomplete#start_manual_complete('file')

  "inoremap <expr> <C-g>     neocomplete#undo_completion()
  "inoremap <expr> <C-l>     neocomplete#complete_common_string()

  "" <CR>: close popup and save indent.
  ""inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  ""function! s:my_cr_function()
  ""  return neocomplete#smart_close_popup() . "\<CR>"
  ""endfunction

  "" <TAB>: completion.
  "inoremap <silent><expr> <TAB>
  "      \ pumvisible() ? "\<C-n>" :
  "      \ <SID>check_back_space() ? "\<TAB>" :
  "      \ neocomplete#start_manual_complete()
  "function! s:check_back_space() "{{{
  "  let col = col('.') - 1
  "  return !col || getline('.')[col - 1]  =~ '\s'
  "endfunction"}}}
  "" <S-TAB>: completion back.
  "inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

  "" For cursor moving in insert mode(Not recommended)
  "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
  ""}}}

  let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]
endif

if s:plug.is_installed("mru.vim") "{{{2
  let MRU_Auto_Close = 1
  let MRU_Window_Height = 30
  let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
  let MRU_Max_Entries = 1000
  nnoremap <silent> [Space]j :<C-u>MRU<CR>
else
  " MRU configuration variables {{{3
  if !exists('s:MRU_File')
    if has('unix') || has('macunix')
      let s:MRU_File = $HOME . '/.vim_mru_files'
    else
      let s:MRU_File = $VIM . '/_vim_mru_files'
      if has('win32')
        if $USERPROFILE != ''
          let s:MRU_File = $USERPROFILE . '\_vim_mru_files'
        endif
      endif
    endif
  endif

  function! s:MRU_LoadList() "{{{3
    if filereadable(s:MRU_File)
      let s:MRU_files = readfile(s:MRU_File)
      if s:MRU_files[0] =~# '^#'
        call remove(s:MRU_files, 0)
      else
        let s:MRU_files = []
      endif
    else
      let s:MRU_files = []
    endif
  endfunction

  function! s:MRU_SaveList() "{{{3
    let l = []
    call add(l, '# Most recently used files list')
    call extend(l, s:MRU_files)
    call writefile(l, s:MRU_File)
  endfunction
  function! s:MRU_AddList(buf) "{{{3
    if s:mru_list_locked
      return
    endif

    let fname = fnamemodify(bufname(a:buf + 0), ':p')
    if fname == ''
      return
    endif

    if &buftype != ''
      return
    endif

    if index(s:MRU_files, fname) == -1
      if !filereadable(fname)
        return
      endif
    endif

    call s:MRU_LoadList()
    call filter(s:MRU_files, 'v:val !=# fname')
    call insert(s:MRU_files, fname, 0)

    "let s:MRU_Max_Entries = 100
    "if len(s:MRU_files) > s:MRU_Max_Entries
    " call remove(s:MRU_files, s:MRU_Max_Entries, -1)
    "endif

    call s:MRU_SaveList()

    let bname = '__MRU_Files__'
    let winnum = bufwinnr(bname)
    if winnum != -1
      let cur_winnr = winnr()
      call s:MRU_Create_Window()
      if winnr() != cur_winnr
        exe cur_winnr . 'wincmd w'
      endif
    endif
  endfunction

  function! s:MRU_RemoveList() "{{{3
    call s:MRU_LoadList()
    let lnum = line('.')
    call remove(s:MRU_files, line('.')-1)
    call s:MRU_SaveList()
    close
    call s:MRU_Create_Window()
    call cursor(lnum, 1)
  endfunction

  function! s:MRU_Open_File() range "{{{3
    for f in getline(a:firstline, a:lastline)
      if f == ''
        continue
      endif

      let file = substitute(f, '^.*| ','','')

      let winnum = bufwinnr('^' . file . '$')
      silent quit
      if winnum != -1
        return
      else
        if &filetype ==# 'mru'
          silent quit
        endif
      endif

      exe 'edit ' . fnameescape(substitute(file, '\\', '/', 'g'))
    endfor
  endfunction

  function! s:MRU_Create_Window() "{{{3
    if &filetype == 'mru' && bufname("%") ==# '__MRU_Files__'
      quit
      return
    endif

    call s:MRU_LoadList()
    if empty(s:MRU_files)
      echohl WarningMsg | echo 'MRU file list is empty' | echohl None
      return
    endif

    let bname = '__MRU_Files__'
    let winnum = bufwinnr(bname)
    if winnum != -1
      if winnr() != winnum
        exe winnum . 'wincmd w'
      endif

      setlocal modifiable
      " Delete the contents of the buffer to the black-hole register
      silent! %delete _
    else
      " If the __MRU_Files__ buffer exists, then reuse it. Otherwise open
      " a new buffer
      let bufnum = bufnr(bname)
      if bufnum == -1
        let wcmd = bname
      else
        let wcmd = '+buffer' . bufnum
      endif
      let wcmd = bufnum == -1 ? bname : '+buffer' . bufnum
      let s:MRU_Window_Height = &lines / 3
      exe 'silent! botright ' . s:MRU_Window_Height . 'split ' . wcmd
    endif

    " Mark the buffer as scratch
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal filetype=mru
    setlocal winfixheight
    setlocal modifiable

    let old_cpoptions = &cpoptions
    set cpoptions&vim

    " Create mappings to select and edit a file from the MRU list
    nnoremap <buffer> <silent> <CR>   :call <SID>MRU_Open_File()<CR>
    vnoremap <buffer> <silent> <CR>   :call <SID>MRU_Open_File()<CR>
    nnoremap <buffer> <silent> <S-CR> :call <SID>MRU_Open_File_Tab()<CR>
    vnoremap <buffer> <silent> <S-CR> :call <SID>MRU_Open_File_Tab()<CR>
    nnoremap <buffer> <silent> K      :call <SID>MRU_RemoveList()<CR>
    nnoremap <buffer> <silent> S      :setlocal modifiable<CR>:sort<CR>:setlocal nomodifiable<CR>

    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions

    let output = copy(s:MRU_files)
    let idx = 0
    for file in output
      if !filereadable(file)
        call remove(output, idx)
        continue
      endif
      let idx += 1
    endfor

    silent! 0put =output

    " Delete the empty line at the end of the buffer
    silent! $delete _
    let glist = getline(1, '$')
    let max = 0
    let max_h = 0
    for idx in range(0, len(glist)-1)
      if strlen(fnamemodify(glist[idx], ':t')) > max
        let max = strlen(fnamemodify(glist[idx], ':t'))
      endif
      if strlen(substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', '')) > max_h
        let max_h = strlen(substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', ''))
      endif
    endfor
    for idx in range(0, len(glist)-1)
      let glist[idx] = printf("%-" . max .  "s | %-" . max_h . "s | %s" ,
            \ fnamemodify(glist[idx], ':t'), substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', ''), glist[idx])
    endfor
    silent! %delete _
    call setline(1, glist)
    if glist[idx] == '| '
      silent! $delete _
    endif

    exe 'syntax match Directory display ' . '"'. '|\zs[^|]*\ze|'. '"'
    exe 'syntax match Constant  display ' . '"' . '[^|]*[\/]' . '"'

    " Move the cursor to the beginning of the file
    normal! gg

    setlocal nonumber cursorline nomodifiable
  endfunction

  " MRU Essentials {{{3
  let s:mru_list_locked = 0
  call s:MRU_LoadList()
  command! MRU call s:MRU_Create_Window()
  augroup mru-files-vimrc
    autocmd!
    autocmd BufRead      * call s:MRU_AddList(expand('<abuf>'))
    autocmd BufNewFile   * call s:MRU_AddList(expand('<abuf>'))
    autocmd BufWritePost * call s:MRU_AddList(expand('<abuf>'))
    autocmd QuickFixCmdPre  *grep* let s:mru_list_locked = 1
    autocmd QuickFixCmdPost *grep* let s:mru_list_locked = 0
  augroup END

  " MRU within the vimrc
  "if !s:plug.is_installed('mru.vim') 
  if exists('*s:MRU_Create_Window')
    nnoremap <silent> [Space]j :<C-u>call <SID>MRU_Create_Window()<CR>
  endif
  "endif
endif

" Settings: {{{1
function! s:b4b4r07() "{{{2
  hide enew
  setlocal buftype=nofile nowrap nolist nonumber bufhidden=wipe
  setlocal modifiable nocursorline nocursorcolumn

  let b4b4r07 = []
  call add(b4b4r07, 'Copyright (c) 2014                                 b4b4r07''s vimrc.')
  call add(b4b4r07, '.______    _  _    .______    _  _    .______        ___    ______  ')
  call add(b4b4r07, '|   _  \  | || |   |   _  \  | || |   |   _  \      / _ \  |____  | ')
  call add(b4b4r07, '|  |_)  | | || |_  |  |_)  | | || |_  |  |_)  |    | | | |     / /  ')
  call add(b4b4r07, '|   _  <  |__   _| |   _  <  |__   _| |      /     | | | |    / /   ')
  call add(b4b4r07, '|  |_)  |    | |   |  |_)  |    | |   |  |\  \----.| |_| |   / /    ')
  call add(b4b4r07, '|______/     |_|   |______/     |_|   | _| `._____| \___/   /_/     ')
  call add(b4b4r07, '           #VIM + #ZSH + #TMUX = Best Developer Environmen          ')

  silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2)
  let space = repeat(' ', winwidth(0)/2 - strlen(b4b4r07[0])/2)
  for line in b4b4r07
    put =space . line
  endfor
  silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2 + 1)
  silent file B4B4R07
  1

  execute 'syntax match Directory display ' . '"'. '^\s\+\U\+$'. '"'
  setlocal nomodifiable
  redraw
  let char = getchar()
  silent enew
  call feedkeys(type(char) == type(0) ? nr2char(char) : char)
endfunction
augroup vimrc-without-plugin
  autocmd!
  autocmd VimEnter * if !argc() | call <SID>b4b4r07() | endif
augroup END

"function! s:cd_file_parentdir() "{{{2
"  execute ":lcd " . expand("%:p:h")
"endfunction
"command! Cdcd call <SID>cd_file_parentdir()
"
""if s:vimrc_auto_cd_file_parentdir == s:true
"augroup cd-file-parentdir
"  autocmd!
"  autocmd BufRead,BufEnter * if s:vimrc_auto_cd_file_parentdir == s:true | call <SID>cd_file_parentdir() | endif
"augroup END
""endif

if s:vimrc_auto_cd_file_parentdir == s:true
augroup cd-file-parentdir
  autocmd!
  autocmd BufEnter * call <SID>change_current_dir('', '!')
augroup END
endif

function! s:get_buflists(...) "{{{2
  if a:0 && a:1 ==# 'n'
    silent bnext
  elseif a:0 && a:1 ==# 'p'
    silent bprev
  endif

  let list  = ''
  let lists = []
  for buf in range(1, bufnr('$'))
    if bufexists(buf) && buflisted(buf)
      let list  = bufnr(buf) . "#" . fnamemodify(bufname(buf), ':t')
      let list .= getbufvar(buf, "&modified") ? '+' : ''
      if bufnr('%') ==# buf
        let list = "[" . list . "]"
      else
        let list = " " . list . " "
      endif
      call add(lists, list)
    endif
  endfor
  redraw | echo join(lists, "")
endfunction
if s:plug.is_installed('vim-buftabs')
  nnoremap <silent> <C-j> :<C-u>silent bnext<CR>
  nnoremap <silent> <C-k> :<C-u>silent bprev<CR>
else
  nnoremap <silent> <C-j> :<C-u>silent bnext<CR>:<C-u>call <SID>get_buflists()<CR>
  nnoremap <silent> <C-k> :<C-u>silent bprev<CR>:<C-u>call <SID>get_buflists()<CR>
endif

function! s:smart_foldcloser() "{{{2
  if foldlevel('.') == 0
    normal! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  normal! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  normal! zM
endfunction
nnoremap <silent> <C-_> :<C-u>call <SID>smart_foldcloser()<CR>

function! s:win_tab_switcher(...) "{{{2
  let minus = 0
  if &laststatus == 1 && winnr('$') != 1
    let minus += 1
  elseif &laststatus == 2
    let minus += 1
  endif
  let minus += &cmdheight
  if &showtabline == 1 && tabpagenr('$') != 1
    let minus += 1
  elseif &showtabline == 2
    let minus += 1
  endif

  let is_split   = winheight(0) != &lines - minus
  let is_vsplit  = winwidth(0)  != &columns
  let is_tabpage = tabpagenr('$') >= 2

  let buffer_switcher = get(g:, 'buffer_switcher', 0)
  if a:0 && a:1 ==# 'l'
    if is_tabpage
      if tabpagenr() == tabpagenr('$')
        if !is_split && !is_vsplit
          if buffer_switcher
            silent bnext
          else
            echohl WarningMsg
            echo 'Last tabpages'
            echohl None
          endif
        endif
        if (is_split || is_vsplit) && winnr() == winnr('$')
          if buffer_switcher
            silent bnext
          else
            echohl WarningMsg
            echo 'Last tabpages'
            echohl None
          endif
        elseif (is_split || is_vsplit) && winnr() != winnr('$')
          silent wincmd w
        endif
      else
        if !is_split && !is_vsplit
          silent tabnext
        endif
        if (is_split || is_vsplit) && winnr() == winnr('$')
          silent tabnext
        elseif (is_split || is_vsplit) && winnr() != winnr('$')
          silent wincmd w
        endif
      endif
    else
      if !is_split && !is_vsplit
        if buffer_switcher
          silent bnext
        else
          echohl WarningMsg
          echo 'Last tabpages'
          echohl None
        endif
      endif
      if (is_split || is_vsplit) && winnr() == winnr('$')
        if buffer_switcher
          silent bnext
        else
          echohl WarningMsg
          echo 'Last tabpages'
          echohl None
        endif
      else
        silent wincmd w
      endif
    endif
  endif
  if a:0 && a:1 ==# 'h'
    if is_tabpage
      if tabpagenr() == 1
        if !is_split && !is_vsplit
          if buffer_switcher
            silent bprevious
          else
            echohl WarningMsg
            echo 'First tabpages'
            echohl None
          endif
        endif
        if (is_split || is_vsplit) && winnr() == 1
          if buffer_switcher
            silent bprevious
          else
            echohl WarningMsg
            echo 'First tabpages'
            echohl None
          endif
        elseif (is_split || is_vsplit) && winnr() != 1
          silent wincmd W
        endif
      else
        if !is_split && !is_vsplit
          silent tabprevious
        endif
        if (is_split || is_vsplit) && winnr() == 1
          silent tabprevious
        elseif (is_split || is_vsplit) && winnr() != 1
          silent wincmd W
        endif
      endif
    else
      if !is_split && !is_vsplit
        if buffer_switcher
          silent bprevious
        else
          echohl WarningMsg
          echo 'First tabpages'
          echohl None
        endif
      endif
      if (is_split || is_vsplit) && winnr() == 1
        if buffer_switcher
          silent bprevious
        else
          echohl WarningMsg
          echo 'First tabpages'
          echohl None
        endif
      else
        silent wincmd W
      endif
    endif
  endif

  if s:plug.is_installed("vim-buftabs")
  else
    redraw
    call <SID>get_buflists()
  endif
endfunction
nnoremap <silent> <C-l> :<C-u>call <SID>win_tab_switcher('l')<CR>
nnoremap <silent> <C-h> :<C-u>call <SID>win_tab_switcher('h')<CR>

function! s:root() "{{{2
  let me = expand('%:p:h')
  let gitd = finddir('.git', me.';')
  if empty(gitd)
    echo "Not in git repo"
  else
    let gitp = fnamemodify(gitd, ':h')
    echo "Change directory to: ".gitp
    execute 'lcd' gitp
  endif
endfunction
command! Root call <SID>root()

" Restore cursor position {{{2
if s:vimrc_restore_cursor_position == s:true
  function! s:restore_cursor_postion()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction
  augroup restore-cursor-position
    autocmd!
    autocmd BufWinEnter * call <SID>restore_cursor_postion()
  augroup END
endif
" Backup automatically {{{2
if s:is_windows
  set nobackup
else
  set backup
  call s:mkdir('~/.vim/backup')
  augroup backup-files-automatically
    autocmd!
    autocmd BufWritePre * call s:backup_files()
  augroup END

  function! s:backup_files()
    let dir = strftime("~/.backup/vim/%Y/%m/%d", localtime())
    if !isdirectory(dir)
      call system("mkdir -p " . dir)
      call system("chown goth:staff " . dir)
    endif
    execute "set backupdir=" . dir
    execute "set backupext=." . strftime("%H_%M_%S", localtime())
  endfunction
endif

" __END__ {{{1

command! -nargs=? -complete=dir -bang CD call s:change_current_dir('<args>', '<bang>')
function! s:change_current_dir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . expand(a:directory)
    endif
    if a:bang == ''
        redraw
        call s:ls('', '')
    endif
endfunction

command! -nargs=? -complete=file -bang Ls2 call s:ls('<args>', '<bang>')
function! s:ls(path, bang)
  let path = empty(a:path) ? getcwd() : expand(a:path)
  if filereadable(path)
    if executable("ls")
      echo system("ls -l " . path)
      return v:shell_error ? s:false : s:true
    else
      return s:error('ls: command not found')
    endif
  endif

  if !isdirectory(path)
    return s:error(path.":No such file or directory")
  endif

  let save_ignore = &wildignore
  set wildignore=
  let filelist = glob(path . "/*")
  if !empty(a:bang)
    let filelist .= "\n".glob(path . "/.*[^.]")
  endif
  let &wildignore = save_ignore
  let filelist = substitute(filelist, '', '^M', 'g')

  if empty(filelist)
    return s:error("no file")
  endif

  let lists = []
  for file in split(filelist, "\n")
    if isdirectory(file)
      call add(lists, fnamemodify(file, ":t") . "/")
    else
      if executable(file)
        call add(lists, fnamemodify(file, ":t") . "*")
      elseif getftype(file) == 'link'
        call add(lists, fnamemodify(file, ":t") . "@")
      else
        call add(lists, fnamemodify(file, ":t"))
      endif
    endif
  endfor

  echohl WarningMsg | echon len(lists) . ":\t" | echohl None
  highlight LsDirectory  cterm=bold ctermfg=NONE ctermfg=26        gui=bold guifg=#0096FF   guibg=NONE
  highlight LsExecutable cterm=NONE ctermfg=NONE ctermfg=Green     gui=NONE guifg=Green     guibg=NONE
  highlight LsSymbolick  cterm=NONE ctermfg=NONE ctermfg=LightBlue gui=NONE guifg=LightBlue guibg=NONE

  let max = 0
  for item in lists
    let max += len(item)
    if max > &columns * 1.5
      echon "...more"
      break
    endif
    if item =~ '/'
      echohl LsDirectory | echon item[:-2] | echohl NONE
      echon item[-1:-1] . " "
    elseif item =~ '*'
      echohl LsExecutable | echon item[:-2] | echohl NONE
      echon item[-1:-1] . " "
    elseif item =~ '@'
      echohl LsSymbolick | echon item[:-2] | echohl NONE
      echon item[-1:-1] . " "
    else
      echon item . " "
    endif
  endfor

  return s:true
endfunction

if s:env.is_tmux_running
  augroup titlesettings
    autocmd!
    autocmd BufEnter * call system("tmux rename-window " . "'[vim] " . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux rename-window ".s:env.tmux_proc)
    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
  augroup END
endif

augroup MyAutoCmd
    autocmd!
augroup END

autocmd GUIEnter * call s:gui()
function! s:gui()
  "colorscheme solarized
  set background=light
  syntax enable

  " Tabpages
  set guitablabel=%{GuiTabLabel()}

  " Change cursor color if IME works.
  if has('multi_byte_ime') || has('xim')
    "highlight Cursor   guibg=NONE guifg=Yellow
    "highlight CursorIM guibg=NONE guifg=Red
    set iminsert=0 imsearch=0
    inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
  endif
  "autocmd VimEnter,ColorScheme * highlight Cursor   guibg=Yellow guifg=Black
  "autocmd VimEnter,ColorScheme * highlight CursorIM guibg=Red    guifg=Black
  autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight Cursor   guibg=Yellow guifg=Black | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight CursorIM guibg=Red    guifg=Black | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight Cursor   guibg=Black  guifg=NONE  | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight CursorIM guibg=Red    guifg=Black | endif
  inoremap <silent> <ESC><ESC>:set iminsert=0<CR>

  " Remove all menus.
  try
    source $VIMRUNTIME/delmenu.vim
  catch
  endtry

  " Font
  if s:is_mac
    set guifont=Andale\ Mono:h12
  endif
endfunction
autocmd MyAutoCmd BufReadPost *
\ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ | setlocal fileencoding=
\ | endif

nmap <silent> gZZ :set t_te= t_ti= <cr>:quit<cr>:set t_te& t_ti&<cr>
nmap <silent> gsh :set t_te= t_ti= <cr>:sh<cr>:set t_te& t_ti&<cr>

" Must be written at the last.  see :help 'secure'.
set secure

" vi:set ts=2 sw=2 sts=2:
" vim:fdt=substitute(getline(v\:foldstart),'\\(.\*\\){\\{3}','\\1',''):
" vim:fdm=marker expandtab fdc=3:
