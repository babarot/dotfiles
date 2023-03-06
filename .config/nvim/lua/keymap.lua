vim.keymap.set('n', '<CR>', ':<C-u>w<CR>',        { noremap = true, silent = true })
vim.keymap.set('n', 'q', ':<C-u>bdelete<CR>',     { noremap = false, silent = true })
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR>',     { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':<C-u>bnext<CR>',   { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', ':<C-u>bprev<CR>',   { noremap = true, silent = true })
vim.keymap.set('n', '<C-q>', ':<C-u>bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc><Esc>', ':nohl<CR>',    { noremap = true, silent = true})

vim.keymap.set({'n', 'v'}, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'gj', 'j', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'gk', 'k', { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'H', '^',  { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'L', '$',  { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, ';', ':',  { noremap = true, silent = false })

vim.keymap.set('i', 'jj', '<Esc>',     { noremap = true, silent = true })
vim.keymap.set('c', 'jj', "<BS><C-c>", { noremap = true, silent = true })
vim.keymap.set('v', 'v', '$h',         { noremap = true, silent = true })

vim.keymap.set('c', '<C-k>', '<Up>',     { noremap = true, silent = true})
vim.keymap.set('c', '<C-j>', '<Down>',   { noremap = true, silent = true})
vim.keymap.set('c', '<C-l>', '<Right>',  { noremap = true, silent = true})
vim.keymap.set('c', '<C-h>', '<Left>',   { noremap = true, silent = true})
vim.keymap.set('c', '<C-d>', '<Delete>', { noremap = true, silent = true})
vim.keymap.set('c', '<C-p>', '<Up>',     { noremap = true, silent = true})
vim.keymap.set('c', '<C-n>', '<Down>',   { noremap = true, silent = true})
vim.keymap.set('c', '<C-f>', '<Right>',  { noremap = true, silent = true})
vim.keymap.set('c', '<C-b>', '<Left>',   { noremap = true, silent = true})
vim.keymap.set('c', '<C-a>', '<Home>',   { noremap = true, silent = true})
vim.keymap.set('c', '<C-e>', '<End>',    { noremap = true, silent = true})
vim.keymap.set('c', '<C-h>', '<BS>',     { noremap = true, silent = true})

vim.keymap.set('n', 'n', 'nzz',    { noremap = true, silent = true})
vim.keymap.set('n', 'N', 'Nzz',    { noremap = true, silent = true})
vim.keymap.set('n', 'S', '*zz',    { noremap = true, silent = true})
vim.keymap.set('n', '*', '*zz',    { noremap = true, silent = true})
vim.keymap.set('n', '#', '#zz',    { noremap = true, silent = true})
vim.keymap.set('n', 'g*', 'g*zz',  { noremap = true, silent = true})
vim.keymap.set('n', 'g#', 'g#zz',  { noremap = true, silent = true})
vim.keymap.set('n', 'ZZ', '<Nop>', { noremap = true, silent = true})
vim.keymap.set('n', 'ZQ', '<Nop>', { noremap = true, silent = true})
vim.keymap.set('n', 'zz',
  -- noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?  'zt' : (winline() == 1) ? 'zb' : 'zz'
  -- return (vim.fn.winline() == (vim.fn.winheight(0)+1)/2) and 'zt' or vim.fn.winline() == scrolloff+1 and 'zb' or 'zz'
  function()
    if vim.fn.winline() == (vim.fn.winheight(0)+1)/2 then
      -- top (zt)
      return 'zt'
    else
      local scrolloff = vim.opt.scrolloff:get()
      -- bottom (zb) or middle (zz)
      return vim.fn.winline() == scrolloff+1 and 'zb' or 'zz'
    end
  end,
  { expr = true, noremap = true })

-- Jump a next blank line
vim.keymap.set('n', 'W', ':<C-u>keepjumps normal! }<CR>', { noremap = true, silent = true})
vim.keymap.set('n', 'B', ':<C-u>keepjumps normal! {<CR>', { noremap = true, silent = true})

-- " Save word and exchange it under cursor
-- nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
-- nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

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
-- nnoremap <silent> <C-x>d     :Delete<CR>
-- nnoremap <silent> <C-x><C-d> :Delete!<CR>
-- nnoremap s <Nop>
-- nnoremap sp :<C-u>split<CR>
-- nnoremap vs :<C-u>vsplit<CR>
--
-- function! s:vsplit_or_wincmdw()
--   if winnr('$') == 1
--     return ":vsplit\<CR>"
--   else
--     return ":wincmd w\<CR>
--   endif
-- endfunction
-- nnoremap <expr><silent> ss <SID>vsplit_or_wincmdw()
