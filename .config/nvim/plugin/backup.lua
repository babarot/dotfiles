-- ============================================================================
-- Automatic Backup on Save
-- ============================================================================
--
-- Creates timestamped backups of files when saving
-- Backup location: ~/.backup/vim/YYYY/MM/DD/filename.HH_MM_SS
--
-- Based on: nvim.old/plugin/backup.vim

vim.opt.backup = true

local function backup_files()
  local timestamp = os.date('*t')
  local dir = string.format(
    '%s/.backup/vim/%04d/%02d/%02d',
    vim.fn.expand('~'),
    timestamp.year,
    timestamp.month,
    timestamp.day
  )

  -- Create directory if it doesn't exist
  if vim.fn.isdirectory(dir) ~= 1 then
    vim.fn.mkdir(dir, 'p')
  end

  -- Set backup directory and extension with timestamp
  vim.opt.backupdir = dir
  vim.opt.backupext = string.format('.%02d_%02d_%02d', timestamp.hour, timestamp.min, timestamp.sec)
end

-- Run backup function before writing any file
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('backup-files-automatically', { clear = true }),
  pattern = '*',
  callback = backup_files,
  desc = 'Create timestamped backup before saving',
})
