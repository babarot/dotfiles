vim.opt.encoding       = "UTF-8"
vim.opt.cursorline     = true
vim.opt.showmode       = true
vim.opt.hidden         = true
vim.opt.confirm        = true
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.incsearch      = true
vim.opt.hlsearch       = true
vim.opt.smartcase      = true
vim.opt.ignorecase     = true
vim.opt.autoindent     = true
vim.opt.autochdir      = false
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
vim.opt.listchars      = { tab = ">·", trail = "·", precedes = "←", extends = "→", eol = "↲", nbsp = "␣" }
vim.opt.termguicolors  = true

vim.opt.backup         = false
vim.opt.swapfile       = false
vim.opt.undofile       = false

if vim.fn.has('persistent_undo') then
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
end
