" A minimal vim to fall back on when Neovim is broken: read code and fix a
" few lines, with the options and keys of home/.config/nvim/lua/config.
" It is macOS's /usr/bin/vim and needs nothing else: the plugins below are
" optional, and every line works without them.

set nocompatible
filetype plugin indent on
syntax enable

" Plugins: vim-plug itself comes from Nix (nix/home-manager/tools/vim.nix);
" the plugins are mine to install with :PlugInstall. Skipped when plug.vim
" is missing, and a plugin not installed yet is simply not there.
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'ghifarit53/tokyonight-vim'
  call plug#end()
endif

" Options (nvim's options.lua)
let mapleader = ','
let maplocalleader = '\'
set encoding=utf-8
set showmode
set hidden
set confirm
set mouse=a
set clipboard=unnamed
set belloff=all
set number relativenumber
set cursorline
set signcolumn=yes
set scrolloff=8
set laststatus=2
set showmatch
set splitright splitbelow
set incsearch hlsearch ignorecase smartcase
set autoindent smartindent
set expandtab tabstop=2 softtabstop=2 shiftwidth=0
set backspace=indent,eol,start
set list listchars=tab:>·,trail:·,precedes:←,extends:→,eol:↲,nbsp:␣
set nobackup noswapfile
set wildmenu wildmode=longest:full,full wildoptions=pum
set path=.,** wildignore+=*/.git/*,*/node_modules/*
set statusline=%f\ %m%r%=%y\ %l:%c\ %p%%

" Persistent undo, kept out of ~/.vim
let s:undo = expand('~/.local/state/vim/undo')
if !isdirectory(s:undo)
  call mkdir(s:undo, 'p')
endif
let &undodir = s:undo
set undofile

if has('termguicolors')
  set termguicolors
endif
try
  colorscheme tokyonight
catch
  colorscheme habamax
endtry

" Search with git grep, results in the quickfix list. :Grep runs it
" silently, so git grep's output does not flash by with a Press ENTER
set grepprg=git\ grep\ -n\ --no-color
set grepformat=%f:%l:%m
set shellpipe=>
command! -nargs=+ Grep execute 'silent grep! ' . <q-args> | redraw! | cwindow

" Keys (nvim's keymaps.lua)
inoremap jj <Esc>
inoremap <Del> <BS>
inoremap <C-h> <BS>
xnoremap v $h
cnoremap jj <BS><C-c>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <C-h> <BS>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap H ^
noremap L $
nnoremap ; :
xnoremap ; :

" Enter saves, except in special buffers (quickfix, help, netrw)
nnoremap <expr> <CR> &buftype ==# '' ? ':<C-u>w<CR>' : '<CR>'
nnoremap q <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

nnoremap tt :<C-u>tabnew<CR>
nnoremap tc :<C-u>tabclose<CR>
nnoremap <silent> <C-h> :<C-u>bprev<CR>
nnoremap <silent> <C-l> :<C-u>bnext<CR>
nnoremap <silent> <C-q> :<C-u>bdelete<CR>
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

nnoremap n nzz
nnoremap N Nzz
nnoremap S *zz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" zz cycles middle, top and bottom
function! s:Zz() abort
  if winline() == (winheight(0) + 1) / 2
    return 'zt'
  endif
  return winline() == &scrolloff + 1 ? 'zb' : 'zz'
endfunction
nnoremap <expr> zz <SID>Zz()
nnoremap <silent> W :<C-u>keepjumps normal! }<CR>
nnoremap <silent> B :<C-u>keepjumps normal! {<CR>

nnoremap <silent> sp :<C-u>split<CR>
nnoremap <silent> vs :<C-u>vsplit<CR>
nnoremap <expr> ss winnr('$') == 1 ? ':<C-u>vsplit<CR>' : ':<C-u>wincmd w<CR>'

" nvim's pickers and oil, with what vim has built in
nnoremap <Space>f :<C-u>find<Space>
nnoremap <Space>j :<C-u>browse oldfiles<CR>
nnoremap <leader>fb :<C-u>ls<CR>:b<Space>
nnoremap <leader>/ :<C-u>Grep<Space>
nnoremap <Space>G :<C-u>Grep<Space>
nnoremap <silent> <leader>fw :<C-u>Grep -w <C-r><C-w><CR>
nnoremap <silent> - :<C-u>Explore<CR>

" Visual K toggles comments, as in nvim; only with vim-commentary
augroup vimrc-plugins
  autocmd!
  autocmd VimEnter * if exists('g:loaded_commentary') | xmap K gc | endif
augroup END

" Cursor line only in the active window, and not while typing
augroup vimrc-cursorline
  autocmd!
  autocmd InsertLeave,WinEnter * setlocal cursorline
  autocmd InsertEnter,WinLeave * setlocal nocursorline
augroup END

" Create the parent directory on write
augroup vimrc-mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand('<afile>:p:h'), 'p')
augroup END

" netrw: tree view, no banner
let g:netrw_banner = 0
let g:netrw_liststyle = 3
