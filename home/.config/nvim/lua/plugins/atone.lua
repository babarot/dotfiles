-- ============================================================================
-- atone.nvim - Modern Undo Tree Visualization
-- ============================================================================
--
-- Features:
--   - Graphical undo tree display
--   - Live diff preview between undo states
--   - Fast and modern UI
--   - Auto-attach to buffers
--
-- Commands:
--   :Atone / :Atone open  - Open undo tree
--   :Atone toggle         - Toggle undo tree
--   :Atone close          - Close undo tree
--   :Atone focus          - Focus undo tree window
--
-- Default keymaps in atone window:
--   j/k       - Navigate nodes
--   <CR>      - Undo to selected node
--   q/<C-c>   - Quit
--   ?/g?      - Show help

return {
  {
    'XXiaoA/atone.nvim',
    cmd = 'Atone',
    keys = {
      { '<Space>u', '<cmd>Atone toggle<cr>', desc = 'Toggle Undo Tree' },
    },
    opts = {
      -- Window layout
      layout = {
        position = 'left',  -- 'left' or 'right'
        width = 30,         -- Width of undo tree window
      },

      -- Diff window
      diff = {
        height = 10,  -- Height of diff window
      },

      -- Auto attach to buffers
      auto_attach = true,

      -- Excluded filetypes
      exclude_filetypes = {
        'help',
        'qf',
        'TelescopePrompt',
      },

      -- UI borders
      border = 'rounded',  -- 'none', 'single', 'double', 'rounded', 'solid', 'shadow'

      -- Graph style
      graph = {
        style = 'unicode',  -- 'unicode' or 'ascii'
      },
    },
  },
}
