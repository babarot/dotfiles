--
-- global variables
--
vim.g.mapleader           = ','
vim.g.loaded_gzip         = 1
vim.g.loaded_man          = 1
vim.g.loaded_matchit      = 1
vim.g.loaded_matchparen   = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_tarPlugin    = 1
vim.g.loaded_tar          = 1
vim.g.loaded_zipPlugin    = 1
vim.g.loaded_zip          = 1
vim.g.loaded_netrwPlugin  = 1

--
-- options
--
vim.opt.encoding       = "UTF-8"
vim.opt.cursorline     = true
vim.opt.showmode       = true
vim.opt.hidden         = true
vim.opt.confirm        = true
vim.opt.backup         = false
vim.opt.swapfile       = false
vim.opt.undofile       = true
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.incsearch      = true
vim.opt.hlsearch       = true
vim.opt.smartcase      = true
vim.opt.ignorecase     = true
vim.opt.autoindent     = true
-- vim.opt.autochdir      = true
vim.opt.smartindent    = true
vim.opt.showmatch      = true
vim.opt.laststatus     = 3
vim.opt.scrolloff      = 8
vim.opt.errorbells     = false
vim.opt.pastetoggle    = "<C-\\>"
vim.opt.shiftwidth     = 0
vim.opt.softtabstop    = 2
vim.opt.tabstop        = 2
vim.opt.expandtab      = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.list           = true
vim.opt.listchars      = { tab = ">..", trail = "·", precedes = "←", extends = "→", eol = "↲", nbsp = "␣" }
vim.opt.termguicolors  = true

--
-- keymap
--
vim.keymap.set('n', '<CR>', ':<C-u>w<CR>',        { noremap = true, silent = true })
vim.keymap.set('n', 'q', ':<C-u>bdelete<CR>',     { noremap = false, silent = true })
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR>',     { noremap = true, silent = true })
vim.keymap.set('n', 'tc', ':<C-u>tabclose<CR>',   { noremap = true, silent = true })
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

vim.keymap.set('n', 'ss', function()
  if vim.fn.winnr('$') == 1 then
    return ':<C-u>vsplit<CR>'
  else
    return ':<C-u>wincmd w<CR>'
  end
end, { expr = true, noremap = true, silent = true })
