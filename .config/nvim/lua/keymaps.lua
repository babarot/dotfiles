local opt = { noremap = true, silent = true }

vim.keymap.set('i', 'jj', '<Esc>', opt)
vim.keymap.set('i', '<Del>', '<BS>', opt)
vim.keymap.set('i', '<C-h>', '<BS>', opt)
vim.keymap.set('v', 'v', '$h', opt)

vim.keymap.set('c', 'jj', '<BS><C-c>', opt)
vim.keymap.set('c', '<C-a>', '<Home>', opt)
vim.keymap.set('c', '<C-e>', '<End>', opt)
vim.keymap.set('c', '<C-b>', '<Left>', opt)
vim.keymap.set('c', '<C-f>', '<Right>', opt)
vim.keymap.set('c', '<C-d>', '<Delete>', opt)
vim.keymap.set('c', '<C-h>', '<BS>', opt)
vim.keymap.set('c', '<C-j>', '<Down>', opt)
vim.keymap.set('c', '<C-k>', '<Up>', opt)
-- vim.keymap.set('c', '<C-n>', '<Down>', opt)
-- vim.keymap.set('c', '<C-p>', '<Up>', opt)

vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opt)
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opt)
vim.keymap.set({ 'n', 'v' }, 'gj', 'j', opt)
vim.keymap.set({ 'n', 'v' }, 'gk', 'k', opt)
vim.keymap.set({ 'n', 'v' }, 'H', '^', opt)
vim.keymap.set({ 'n', 'v' }, 'L', '$', opt)
vim.keymap.set({ 'n', 'v' }, ';', ':', {})

vim.keymap.set('n', '<CR>', ':<C-u>w<CR>', opt)
-- vim.keymap.set('n', 'q', ':<C-u>bdelete<CR>', { noremap = false, silent = true })
vim.keymap.set('n', 'q', '<Nop>', opt)
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR>', opt)
vim.keymap.set('n', 'tc', ':<C-u>tabclose<CR>', opt)
vim.keymap.set('n', '<C-h>', ':<C-u>bnext<CR>', opt)
vim.keymap.set('n', '<C-l>', ':<C-u>bprev<CR>', opt)
vim.keymap.set('n', '<C-q>', ':<C-u>bdelete<CR>', opt)
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>nohl<CR>', opt)

vim.keymap.set('n', 'n', 'nzz', opt)
vim.keymap.set('n', 'N', 'Nzz', opt)
vim.keymap.set('n', 'S', '*zz', opt)
vim.keymap.set('n', '*', '*zz', opt)
vim.keymap.set('n', '#', '#zz', opt)
vim.keymap.set('n', 'g*', 'g*zz', opt)
vim.keymap.set('n', 'g#', 'g#zz', opt)
vim.keymap.set('n', 'ZZ', '<Nop>', opt)
vim.keymap.set('n', 'ZQ', '<Nop>', opt)
vim.keymap.set('n', 'zz',
  function()
    if vim.fn.winline() == (vim.fn.winheight(0) + 1) / 2 then
      return 'zt' -- top
    else
      local scrolloff = vim.opt.scrolloff:get()
      return vim.fn.winline() == scrolloff + 1 and 'zb' or 'zz' -- bottom or middle
    end
  end,
  { expr = true, noremap = true, silent = true })
-- Jump a next blank line
vim.keymap.set('n', 'W', ':<C-u>keepjumps normal! }<CR>', opt)
vim.keymap.set('n', 'B', ':<C-u>keepjumps normal! {<CR>', opt)
-- Set tabs and windows
vim.keymap.set('n', 'sp', ':<C-u>split<CR>', opt)
vim.keymap.set('n', 'vs', ':<C-uv>split<CR>', opt)
vim.keymap.set('n', 'ss',
  function()
    if vim.fn.winnr('$') == 1 then
      return ':<C-u>vsplit<CR>'
    else
      return ':<C-u>wincmd w<CR>'
    end
  end,
  { expr = true, noremap = true, silent = true })
