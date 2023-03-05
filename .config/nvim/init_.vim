function! s:vimrc_environment()
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
  " vim
  if env.is_windows
    let vimpath = expand('~/vimfiles')
  else
    let vimpath = expand('~/.vim')
  endif
  " neovim
  " let vimpath = expand('~/.local/share/nvim/site')
  let env.path = {
        \ 'vim': vimpath,
        \ }
  return env
endfunction

let g:env = s:vimrc_environment()
let g:plug = {
      \ "plug":   expand(g:env.path.vim) . "/autoload/plug.vim",
      \ "url":    "https://raw.github.com/junegunn/vim-plug/master/plug.vim",
      \ "github": "https://github.com/junegunn/vim-plug",
      \ }

function! g:plug.installed(name)
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction

function! g:plug.check_installation()
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

function! g:plug.ready()
  return filereadable(self.plug)
endfunction

if g:plug.ready()
  call plug#begin()
  Plug 'AndrewRadev/gapply.vim'
  Plug 'Dkendal/fzy-vim'
  Plug 'aliou/bats.vim'
  Plug 'b4b4r07/mru.vim'
  Plug 'b4b4r07/vim-ansible-vault'
  Plug 'b4b4r07/vim-hcl'
  Plug 'b4b4r07/vim-shellutils'
  Plug 'b4b4r07/vim-sqlfmt'
  Plug 'b4b4r07/vim-unicode'
  Plug 'chrisbra/csv.vim'
  Plug 'christianrondeau/vim-base64'
  Plug 'cocopon/vaffle.vim'
  Plug 'hashivim/vim-terraform'
  Plug 'haya14busa/vim-gofmt'
  Plug 'hotwatermorning/auto-git-diff'
  Plug 'juliosueiras/vim-terraform-completion'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'juvenn/mustache.vim'
  Plug 'osyo-manga/vim-anzu'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-surround'
  Plug 'tyru/caw.vim'
  Plug 'w0rp/ale'

  " syntax? language support
  Plug 'cespare/vim-toml', { 'for': 'toml' }
  Plug 'chase/vim-ansible-yaml'
  Plug 'dag/vim-fish', { 'for': 'fish' }
  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'fatih/vim-go', { 'for': 'go' }
  Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
  Plug 'jnwhiteh/vim-golang', { 'for': 'go' }
  Plug 'keith/tmux.vim', { 'for': 'tmux' }
  Plug 'maksimr/vim-jsbeautify', { 'for': 'javascript' }
  Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }
  Plug 'rhysd/vim-fixjson', { 'for': 'json' }
  Plug 'tsandall/vim-rego'

  " colorscheme
  Plug 'AlessandroYorba/Despacio'
  Plug 'arcticicestudio/nord-vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'chriskempson/vim-tomorrow-theme'
  Plug 'cocopon/iceberg.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'morhetz/gruvbox'
  Plug 'nanotech/jellybeans.vim'
  Plug 'nightsense/snow'
  Plug 'nightsense/stellarized'
  Plug 'tomasr/molokai'
  Plug 'w0ng/vim-hybrid'
  Plug 'whatyouhide/vim-gotham'
  Plug 'yuttie/hydrangea-vim'
  Plug 'rhysd/wallaby.vim'
  Plug 'rhysd/vim-color-spring-night'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
  Plug 'caglartoklu/ftcolor.vim'


  " Add plugins to &runtimepath
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  " Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'dcampos/nvim-snippy'
  Plug 'dcampos/cmp-snippy'

  Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'stevearc/dressing.nvim'
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'MunifTanjim/nui.nvim'

  call plug#end()
endif

let g:plug.plugs = get(g:, 'plugs', {})

if has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd!
    autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
          \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

if g:plug.installed('caw.vim')
  vmap K <Plug>(caw:i:toggle)
endif

if !g:plug.ready()
  function! g:plug.init()
    let ret = system(printf("curl -fLo %s --create-dirs %s", self.plug, self.url))
    "call system(printf("git clone %s", self.github))
    if v:shell_error
      return Error('g:plug.init: error occured')
    endif

    " Restart vim
    if !g:env.is_gui
      silent! !vim
      quit!
    endif
  endfunction
  command! PlugInit call g:plug.init()

  if g:env.vimrc.suggest_neobundleinit == v:true
    autocmd! VimEnter * redraw
          \ | echohl WarningMsg
          \ | echo "You should do ':PlugInit' at first!"
          \ | echohl None
  else
    " Install vim-plug
    PlugInit
  endif
endif

let g:ftcolor_plugin_enabled = 1
let g:ftcolor_redraw = 1
let g:ftcolor_default_color_scheme = 'seoul256'
let g:ftcolor_color_mappings = {
      \ 'vim': 'Tomorrow-Night',
      \ 'hcl':  'gruvbox',
      \ 'go':   'seoul256',
      \ 'yaml': 'seoul256',
      \ 'bash': 'despacio',
      \ 'zsh':  'despacio',
      \ 'sh':   'seoul256',
      \ }

set number
set showtabline=2
set laststatus=3
set t_Co=256
set pumheight=10
set lazyredraw
set ttyfast
set modeline
set modelines=5
set keywordprg=:help
set helplang& helplang=ja
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
if has('persistent_undo')
  set undofile
  let &undodir = g:env.path.vim . '/undo'
  call mkdir(&undodir, "p")
endif
if has('clipboard')
  set clipboard=unnamed
endif

" Use backslash
""if IsMac()
""  noremap ¥ \
""  noremap \ ¥
""endif

" Define mapleader
let g:mapleader = ','
let g:maplocalleader = ','

nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

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
nnoremap <silent><CR> :<C-u>silent update<CR>
noremap gf gF
noremap gF gf
vnoremap v $h
nnoremap Y y$
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz'
" Jump a next blank line
nnoremap <silent>W :<C-u>keepjumps normal! }<CR>
nnoremap <silent>B :<C-u>keepjumps normal! {<CR>
" Save word and exchange it under cursor
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
" Yank the entire file
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

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

nnoremap <silent> <C-x>d     :Delete<CR>
nnoremap <silent> <C-x><C-d> :Delete!<CR>

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

tnoremap <silent> <ESC> <C-\><C-n>

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

nnoremap <Space>j :History<CR>
nnoremap <Space>k :Files<CR>
nnoremap <Space>b :Buffers<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

" if executable('golsp')
"   augroup LspGo
"     au!
"     autocmd User lsp_setup call lsp#register_server({
"          \ 'name': 'go-lang',
"          \ 'cmd': {server_info->['golsp', '-mode', 'stdio']},
"          \ 'whitelist': ['go'],
"          \ })
"     autocmd FileType go setlocal omnifunc=lsp#complete
"   augroup END
" endif

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number -- '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

augroup vimrc-check-plug
  autocmd!
  autocmd VimEnter * if !argc() | call g:plug.check_installation() | endif
augroup END

lua <<EOF
require("mason").setup()
require("mason-lspconfig").setup()
require('lspconfig').gopls.setup {
  cmd = {"gopls", "serve", "-rpc.trace", "--debug=localhost:6060"};
}

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- -- Set up lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  -- --   capabilities = capabilities
  -- -- }

EOF

