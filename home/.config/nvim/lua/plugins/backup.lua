-- ============================================================================
-- backup.nvim - Automatic File Backup
-- ============================================================================

return {
  {
    'babarot/backup.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('backup').setup({
        -- Enable automatic backup on save
        enable = true,

        -- Base directory for backups (supports ~ expansion)
        backup_dir = '~/.backup/vim',

        -- Directory structure format using strftime patterns
        -- Default: YYYY/MM/DD (e.g., 2024/03/15)
        dir_structure = '%Y/%m/%d',

        -- Backup file extension format (timestamp)
        -- Default: .HH_MM_SS (e.g., .14_30_45)
        backup_ext = '.%H_%M_%S',

        -- File patterns to exclude from backup (lua patterns)
        exclude_patterns = {
          '%.git/',
          '/tmp/',
          '%.tmp',
          '%.swp',
        },

        -- Maximum number of backups to keep per file (0 = unlimited)
        max_backups = 0,

        -- Automatically clean old backups on startup
        auto_clean = false,

        -- Number of days to keep backups (used with auto_clean)
        keep_days = 30,

        -- Show notification on backup
        notify_on_backup = false,
      })
    end,
  },
}
