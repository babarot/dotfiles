-- ============================================================================
-- rm.nvim - Safe File Deletion
-- ============================================================================
--
-- Provides :Rm command to delete the current file with confirmation
-- Uses 'gomi' command if available for trash-like deletion
--
-- Commands:
--   :Rm    - Delete with confirmation prompt
--   :Rm!   - Delete without confirmation
--
-- Repository: https://github.com/babarot/rm.nvim

return {
  {
    'babarot/rm.nvim',
    cmd = 'Rm',  -- Load only when :Rm command is used
    opts = {
      -- Use gomi command if available, otherwise fall back to os.remove
      command = vim.fn.executable('gomi') == 1 and 'gomi' or nil,
      -- Show confirmation prompt by default
      confirm = true,
      -- Show notification after deletion
      notify = true,
    },
  },
}
