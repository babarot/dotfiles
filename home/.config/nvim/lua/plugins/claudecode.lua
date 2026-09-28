-- ============================================================================
-- Claude Code IDE integration
-- ============================================================================
-- Speaks the same protocol as Claude Code's VS Code extension. Claude Code
-- runs in its own herdr pane, not inside Neovim; run /ide there to connect.
-- It then sees the open file, selection and diagnostics, and its edits open
-- here as diffs to accept or reject.

return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    -- Load at startup so the server is up before Claude Code looks for it
    lazy = false,
    opts = {
      terminal = {
        provider = 'none', -- Claude Code is started in herdr, not here
      },
    },
    keys = {
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Claude: send selection' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude: add current file' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Claude: accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Claude: reject diff' },
    },
  },
}
