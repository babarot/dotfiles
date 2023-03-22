local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

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

require('autocmds')
require('keymaps')
require('options')
require('commands')
require('plugins')
