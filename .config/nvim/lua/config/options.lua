-- ============================================================================
-- Options
-- ============================================================================

-- Leader keys (must be set before loading other configs)
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

-- Disable built-in plugins
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

-- General
vim.opt.encoding       = "UTF-8"
vim.opt.showmode       = true
vim.opt.hidden         = true
vim.opt.confirm        = true
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"  -- Use system clipboard
vim.opt.errorbells     = false
vim.opt.termguicolors  = true

-- UI
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.cursorcolumn   = false
vim.opt.signcolumn     = "yes"
vim.opt.scrolloff      = 8
vim.opt.laststatus     = 3
vim.opt.showmatch      = true

-- Splits
vim.opt.splitright     = true
vim.opt.splitbelow     = true

-- Search
vim.opt.incsearch      = true
vim.opt.hlsearch       = true
vim.opt.smartcase      = true
vim.opt.ignorecase     = true

-- Indentation
vim.opt.autoindent     = true
vim.opt.smartindent    = true
vim.opt.expandtab      = true
vim.opt.shiftwidth     = 0
vim.opt.softtabstop    = 2
vim.opt.tabstop        = 2

-- Whitespace display
vim.opt.list           = true
vim.opt.listchars      = {
  tab      = ">·",
  trail    = "·",
  precedes = "←",
  extends  = "→",
  eol      = "↲",
  nbsp     = "␣",
}

-- Files
vim.opt.backup         = false
vim.opt.swapfile       = false
vim.opt.undofile       = false
vim.opt.autochdir      = false

-- Persistent undo
if vim.fn.has('persistent_undo') == 1 then
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
end
