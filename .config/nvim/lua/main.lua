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

vim.cmd 'set nrformats-=octal'
vim.cmd 'au InsertLeave * set nopaste'
vim.cmd 'au FileType * set formatoptions-=cro'
vim.cmd 'au BufReadPost * lua goto_last_pos()'
vim.cmd 'au FileType yaml setlocal sw=0 sts=2 ts=2 et'

function goto_last_pos()
  local last_pos = vim.fn.line("'\"")
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
  end
end


-- Lines below do not exist in vimrc
-- Config
vim.g.mapleader        = ' '


