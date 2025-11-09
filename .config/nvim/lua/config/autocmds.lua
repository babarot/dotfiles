-- ============================================================================
-- Autocommands
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Show cursor line only in active window
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('auto-cursorline-show', { clear = true }),
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, 'auto-cursorline')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('auto-cursorline-hide', { clear = true }),
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
      vim.wo.cursorline = false
    end
  end,
})

-- ----------------------------------------------------------------------------
-- Auto-create directories when saving files
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto-create-dir', { clear = true }),
  callback = function(event)
    local uv = vim.uv or vim.loop
    local file = uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')

    -- Create backup filename
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})
