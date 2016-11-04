if !exists('g:env')
    finish
endif

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

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
if exists('&ambiwidth')
    set ambiwidth=double
endif

" Make it normal in UTF-8 in Unix.
set encoding=utf-8
set fileencoding=japan
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932

" Select newline character (either or both of CR and LF depending on system) automatically
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
if IsWindows()
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

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
