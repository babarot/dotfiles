-- ============================================================================
-- which-key.nvim - Keybinding hints
-- ============================================================================

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 500,  -- Time in ms to wait before showing which-key
      triggers = {
        { 'K', mode = { 'n', 'v' } },      -- Enable K as a which-key trigger
        { '<Space>', mode = { 'n', 'v' } }, -- Enable Space as a which-key trigger
      },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)

      -- Register prefix groups
      wk.add({
        { 'K', group = 'LSP' },
        { '<Space>', group = 'Space Commands' },
      })
    end,
  },
}
