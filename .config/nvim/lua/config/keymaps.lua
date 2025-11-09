-- ============================================================================
-- Keymaps
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ----------------------------------------------------------------------------
-- Insert mode
-- ----------------------------------------------------------------------------
keymap('i', 'jj', '<Esc>', opts)
keymap('i', '<Del>', '<BS>', opts)
keymap('i', '<C-h>', '<BS>', opts)

-- ----------------------------------------------------------------------------
-- Visual mode
-- ----------------------------------------------------------------------------
keymap('v', 'v', '$h', opts)

-- ----------------------------------------------------------------------------
-- Command line mode
-- ----------------------------------------------------------------------------
keymap('c', 'jj', '<BS><C-c>', opts)
keymap('c', '<C-a>', '<Home>', opts)
keymap('c', '<C-e>', '<End>', opts)
keymap('c', '<C-b>', '<Left>', opts)
keymap('c', '<C-f>', '<Right>', opts)
keymap('c', '<C-d>', '<Delete>', opts)
keymap('c', '<C-h>', '<BS>', opts)
keymap('c', '<C-j>', '<Down>', opts)
keymap('c', '<C-k>', '<Up>', opts)

-- ----------------------------------------------------------------------------
-- Normal/Visual mode navigation
-- ----------------------------------------------------------------------------
keymap({ 'n', 'v' }, 'j', 'gj', opts)
keymap({ 'n', 'v' }, 'k', 'gk', opts)
keymap({ 'n', 'v' }, 'gj', 'j', opts)
keymap({ 'n', 'v' }, 'gk', 'k', opts)
keymap({ 'n', 'v' }, 'H', '^', opts)
keymap({ 'n', 'v' }, 'L', '$', opts)
keymap({ 'n', 'v' }, ';', ':', {})

-- ----------------------------------------------------------------------------
-- Normal mode - File operations
-- ----------------------------------------------------------------------------
-- Save with <CR>, but not in special buffers (like Lspsaga peek windows)
keymap('n', '<CR>', function()
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype
  -- Don't save in special buffers
  if buftype ~= '' or filetype:match('^lspsaga') then
    return '<CR>'
  end
  return ':<C-u>w<CR>'
end, { expr = true, noremap = true, silent = true })
keymap('n', 'q', '<Nop>', opts)
keymap('n', 'ZZ', '<Nop>', opts)
keymap('n', 'ZQ', '<Nop>', opts)

-- ----------------------------------------------------------------------------
-- Normal mode - Buffer/Tab management
-- ----------------------------------------------------------------------------
keymap('n', 'tt', ':<C-u>tabnew<CR>', opts)
keymap('n', 'tc', ':<C-u>tabclose<CR>', opts)
keymap('n', '<C-h>', ':<C-u>bprev<CR>', opts)
keymap('n', '<C-l>', ':<C-u>bnext<CR>', opts)
keymap('n', '<C-q>', ':<C-u>bdelete<CR>', opts)

-- ----------------------------------------------------------------------------
-- Normal mode - Search
-- ----------------------------------------------------------------------------
keymap('n', '<Esc><Esc>', ':<C-u>nohl<CR>', opts)
keymap('n', 'n', 'nzz', opts)
keymap('n', 'N', 'Nzz', opts)
keymap('n', 'S', '*zz', opts)
keymap('n', '*', '*zz', opts)
keymap('n', '#', '#zz', opts)
keymap('n', 'g*', 'g*zz', opts)
keymap('n', 'g#', 'g#zz', opts)

-- ----------------------------------------------------------------------------
-- Normal mode - Scrolling
-- ----------------------------------------------------------------------------
-- Smart zz: cycle through top -> middle -> bottom
keymap('n', 'zz', function()
  if vim.fn.winline() == (vim.fn.winheight(0) + 1) / 2 then
    return 'zt' -- top
  else
    local scrolloff = vim.opt.scrolloff:get()
    return vim.fn.winline() == scrolloff + 1 and 'zb' or 'zz' -- bottom or middle
  end
end, { expr = true, noremap = true, silent = true })

-- Jump to blank lines
keymap('n', 'W', ':<C-u>keepjumps normal! }<CR>', opts)
keymap('n', 'B', ':<C-u>keepjumps normal! {<CR>', opts)

-- ----------------------------------------------------------------------------
-- Normal mode - Window splits
-- ----------------------------------------------------------------------------
keymap('n', 'sp', ':<C-u>split<CR>', opts)
keymap('n', 'vs', ':<C-u>vsplit<CR>', opts)

-- Smart window split/switch
keymap('n', 'ss', function()
  if vim.fn.winnr('$') == 1 then
    return ':<C-u>vsplit<CR>'
  else
    return ':<C-u>wincmd w<CR>'
  end
end, { expr = true, noremap = true, silent = true })
