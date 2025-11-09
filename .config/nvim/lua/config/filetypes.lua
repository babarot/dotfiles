-- ============================================================================
-- Filetype Settings
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Filetype detection
-- ----------------------------------------------------------------------------
vim.filetype.add({
  extension = {
    gotmpl  = 'gotmpl',
    tape    = 'vhs',
    tf      = 'terraform',
    tfvars  = 'terraform',
  },
  pattern = {
    [".*/templates/.*%.tpl"]     = "helm",
    [".*/templates/.*%.ya?ml"]   = "helm",
    ["helmfile.*%.ya?ml"]        = "helm",
    [".*/layouts/.*%.html"]      = "gohtmltmpl",
    [".*/nginx/.*%.conf"]        = "nginx",  -- Nginx config files in nginx directories
    ["nginx%.conf"]              = "nginx",  -- nginx.conf specifically
  },
  filename = {
    ["README$"] = function(path, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)[1]
      if first_line and string.find(first_line, "#") then
        return "markdown"
      end
    end,
  },
  literal = {
    Brewfile = 'brewfile',
    ['.tagpr'] = 'ini',
  },
})

-- ----------------------------------------------------------------------------
-- Filetype-specific settings
-- ----------------------------------------------------------------------------

-- Shell scripts: add ':' to keyword characters
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('ft-shell', { clear = true }),
  pattern = { "sh", "zsh" },
  callback = function()
    vim.bo.iskeyword = vim.bo.iskeyword .. ',:'
  end,
})

-- Go: use tabs and 4-space width
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('ft-go', { clear = true }),
  pattern = "go",
  callback = function()
    vim.bo.autoindent = true
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
  end,
})

-- Nginx: register treesitter parser
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('ft-nginx', { clear = true }),
  pattern = "nginx",
  callback = function()
    vim.treesitter.language.register("nginx", "nginx")
  end,
})

-- ----------------------------------------------------------------------------
-- User commands
-- ----------------------------------------------------------------------------

-- Format JSON with jq
vim.api.nvim_create_user_command('JQ', function(opts)
  local arg = opts.args == "" and "." or opts.args
  vim.cmd("%! jq " .. arg)
end, { nargs = '?' })
