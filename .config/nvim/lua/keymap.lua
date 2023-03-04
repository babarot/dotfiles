-- Basic keymaps
local set_keymap = vim.keymap.set

vim.keymap.set('n', '<CR>', ':<C-u>w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set('n', 'q', ':<C-u>bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':<C-u>bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', ':<C-u>bprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-q>', ':<C-u>bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true})

vim.keymap.set({'n', 'v'}, 'H', '^', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'L', '$', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, ';', ':', { noremap = true, silent = false })

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('c', 'jj', "<BS><C-c>", { noremap = true, silent = true })
vim.keymap.set('v', 'v', '$h', { noremap = true, silent = true })

-- set_keymap('c', 'j',
--   function()
--     return vim.fn.getcmdline()[vim.fn.getcmdpos()-2] == 'j' and "<BS><C-c>" or 'j'
--   end,
--   { expr = true }
-- )


vim.g.mapleader = ","

vim.keymap.set('c', '<C-k>', '<Up>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-j>', '<Down>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-l>', '<Right>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-h>', '<Left>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-d>', '<Delete>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-p>', '<Up>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-n>', '<Down>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-b>', '<Left>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-h>', '<BS>', { noremap = true, silent = true})

-- nnoremap q: <Nop>
-- nnoremap q/ <Nop>
-- nnoremap q? <Nop>
-- nnoremap <Up> <Nop>
-- nnoremap <Down> <Nop>
-- nnoremap <Left> <Nop>
-- nnoremap <Right> <Nop>
-- nnoremap ZZ <Nop>
-- nnoremap ZQ <Nop>
--
-- inoremap jj <ESC>
-- cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
-- vnoremap <C-j><C-j> <ESC>
-- onoremap jj <ESC>
-- inoremap j[Space] j
-- onoremap j[Space] j
-- nnoremap : ;
-- nnoremap ; :
-- nnoremap q; q:
-- vnoremap : ;
-- vnoremap ; :
-- vnoremap q; q:
-- cnoreabbrev w!! w !sudo tee > /dev/null %
--
-- nnoremap n nzz
-- nnoremap N Nzz
-- nnoremap S *zz
-- nnoremap * *zz
-- nnoremap # #zz
-- nnoremap g* g*zz
-- nnoremap g# g#zz
-- nnoremap <silent><CR> :<C-u>silent update<CR>
-- noremap gf gF
-- noremap gF gf
-- vnoremap v $h
-- nnoremap Y y$
-- noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz'
-- " Jump a next blank line
-- nnoremap <silent>W :<C-u>keepjumps normal! }<CR>
-- nnoremap <silent>B :<C-u>keepjumps normal! {<CR>
-- " Save word and exchange it under cursor
-- nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
-- nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
-- " Yank the entire file
-- nnoremap <Leader>y :<C-u>%y<CR>
-- nnoremap <Leader>Y :<C-u>%y<CR>
--
-- nnoremap t <Nop>
-- nnoremap <silent> [Space]t :<C-u>tabclose<CR>:<C-u>tabnew<CR>
-- nnoremap <silent> tt :<C-u>tabnew<CR>
-- nnoremap <silent> tT :<C-u>tabnew<CR>:<C-u>tabprev<CR>
-- nnoremap <silent> tc :<C-u>tabclose<CR>
-- nnoremap <silent> to :<C-u>tabonly<CR>
-- nnoremap <silent> tm :<C-u>call <SID>move_to_tab()<CR>
-- function! s:move_to_tab()
--   tab split
--   tabprevious
--
--   if winnr('$') > 1
--     close
--   elseif bufnr('$') > 1
--     buffer #
--   endif
--
--   tabnext
-- endfunction
--
-- nnoremap j gj
-- nnoremap k gk
-- vnoremap j gj
-- vnoremap k gk
-- nnoremap gj j
-- nnoremap gk k
-- vnoremap gj j
-- vnoremap gk k
--
-- nnoremap <silent> <C-x>d     :Delete<CR>
-- nnoremap <silent> <C-x><C-d> :Delete!<CR>
--
-- nnoremap s <Nop>
-- nnoremap sp :<C-u>split<CR>
-- nnoremap vs :<C-u>vsplit<CR>
--
-- function! s:vsplit_or_wincmdw()
--   if winnr('$') == 1
--     return ":vsplit\<CR>"
--   else
--     return ":wincmd w\<CR>"
--   endif
-- endfunction
-- nnoremap <expr><silent> ss <SID>vsplit_or_wincmdw()
-- nnoremap sj <C-w>j
-- nnoremap sk <C-w>k
-- nnoremap sl <C-w>l
-- nnoremap sh <C-w>h
--
-- tnoremap <silent> <ESC> <C-\><C-n>
