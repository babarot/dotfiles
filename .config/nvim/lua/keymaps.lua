--
-- keymap
--
vim.keymap.set('n', '<CR>', ':<C-u>w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'q', ':<C-u>bdelete<CR>', { noremap = false, silent = true })
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'tc', ':<C-u>tabclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', ':<C-u>bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':<C-u>bprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-q>', ':<C-u>bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'gj', 'j', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'gk', 'k', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'L', '$', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, ';', ':', { noremap = true, silent = false })

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', '<Del>', '<BS>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-h>', '<BS>', { noremap = true, silent = true })
vim.keymap.set('v', 'v', '$h', { noremap = true, silent = true })

vim.keymap.set('c', 'jj', '<BS><C-c>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-d>', '<Delete>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-b>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-h>', '<BS>', { noremap = true, silent = true })
-- vim.keymap.set('c', '<C-k>', '<Up>',     { noremap = true, silent = true })
-- vim.keymap.set('c', '<C-j>', '<Down>',   { noremap = true, silent = true })
-- vim.keymap.set('c', '<C-p>', '<Up>',     { noremap = true, silent = true})
-- vim.keymap.set('c', '<C-n>', '<Down>',   { noremap = true, silent = true})
-- cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"
-- cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"
--
-- vim.keymap.set('c', '<C-p>', function() return vim.fn.wildmenumode() and '<C-p>' or '<Up>' end, { noremap = false, silent = false, expr = true })
vim.keymap.set('c', '<C-p>', '<UP>', { noremap = false, silent = false })
-- vim.cmd 'cnoremap <C-p> <Up>'

vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'S', '*zz', { noremap = true, silent = true })
vim.keymap.set('n', '*', '*zz', { noremap = true, silent = true })
vim.keymap.set('n', '#', '#zz', { noremap = true, silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { noremap = true, silent = true })
vim.keymap.set('n', 'g#', 'g#zz', { noremap = true, silent = true })
vim.keymap.set('n', 'ZZ', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', 'ZQ', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', 'zz',
  -- noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?  'zt' : (winline() == 1) ? 'zb' : 'zz'
  -- return (vim.fn.winline() == (vim.fn.winheight(0)+1)/2) and 'zt' or vim.fn.winline() == scrolloff+1 and 'zb' or 'zz'
  function()
    if vim.fn.winline() == (vim.fn.winheight(0) + 1) / 2 then
      -- top (zt)
      return 'zt'
    else
      local scrolloff = vim.opt.scrolloff:get()
      -- bottom (zb) or middle (zz)
      return vim.fn.winline() == scrolloff + 1 and 'zb' or 'zz'
    end
  end,
  { expr = true, noremap = true })

-- Jump a next blank line
vim.keymap.set('n', 'W', ':<C-u>keepjumps normal! }<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'B', ':<C-u>keepjumps normal! {<CR>', { noremap = true, silent = true })

vim.keymap.set('n', 'sp', ':<C-u>split<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'vs', ':<C-uv>split<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'ss', function()
  if vim.fn.winnr('$') == 1 then
    return ':<C-u>vsplit<CR>'
  else
    return ':<C-u>wincmd w<CR>'
  end
end, { expr = true, noremap = true, silent = true })

-- local function show_documentation()
--   local ft = vim.opt.filetype:get()
--   if ft == 'vim' or ft == 'help' then
--     vim.cmd([[execute 'h ' . expand('<cword>') ]])
--   else
--     require('lspsaga.hover').render_hover_doc()
--   end
-- end
-- vim.keymap.set({ 'n' }, 'K', show_documentation)
--
