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

-- ----------------------------------------------------------------------------
-- Auto-change directory to file's parent directory
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('auto-cd-to-buffer-dir', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local buftype = vim.bo[bufnr].buftype
    local filetype = vim.bo[bufnr].filetype

    -- Skip special buffers
    local excluded_buftypes = {
      'help',
      'terminal',
      'quickfix',
      'prompt',
      'nofile',
      'acwrite',
    }

    local excluded_filetypes = {
      'gitcommit',
      'gitrebase',
      'dashboard',
      'alpha',
      'neo-tree',
      'oil',
    }

    -- Check if buffer should be skipped
    if vim.tbl_contains(excluded_buftypes, buftype) then
      return
    end

    if vim.tbl_contains(excluded_filetypes, filetype) then
      return
    end

    -- Get absolute path of the buffer
    local filepath = vim.api.nvim_buf_get_name(bufnr)

    -- Skip empty or unnamed buffers
    if filepath == '' or not filepath then
      return
    end

    -- Skip remote files (fugitive, oil, etc.)
    if filepath:match('^%w+://') then
      return
    end

    -- Get directory path
    local dir = vim.fn.fnamemodify(filepath, ':p:h')

    -- Verify directory exists
    if vim.fn.isdirectory(dir) ~= 1 then
      return
    end

    -- Don't change if already in the same directory
    local current_dir = vim.fn.getcwd(0) -- Get window-local cwd
    if current_dir == dir then
      return
    end

    -- Change to the file's directory (window-local)
    local ok, err = pcall(vim.cmd.lcd, dir)
    if not ok then
      vim.notify(
        string.format('Failed to change directory: %s', err),
        vim.log.levels.WARN
      )
    end
  end,
})
