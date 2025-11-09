-- ============================================================================
-- Wilder.nvim - Enhanced Command-Line & Search
-- ============================================================================
--
-- Features:
--   - Fuzzy command-line completion
--   - History filtering (e.g., `:xxx<Up>` shows only commands starting with xxx)
--   - Enhanced search completion
--   - Popup menu with preview

return {
  {
    'gelguy/wilder.nvim',
    event = 'CmdlineEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',  -- Optional: for file icons
    },
    config = function()
      local wilder = require('wilder')

      -- Setup wilder for command-line and search
      wilder.setup({
        modes = { ':', '/', '?' },
        next_key = '<Tab>',
        previous_key = '<S-Tab>',
        accept_key = '<Down>',
        reject_key = '<Up>',
      })

      -- Map <C-p>/<C-n> to <Up>/<Down> using cnoremap
      -- This allows wilder to handle the key press properly
      vim.cmd([[
        cnoremap <expr> <C-p> wilder#in_context() ? "\<Up>" : "\<C-p>"
        cnoremap <expr> <C-n> wilder#in_context() ? "\<Down>" : "\<C-n>"
      ]])

      -- Set up command-line pipeline with fuzzy matching
      wilder.set_option('pipeline', {
        wilder.branch(
          -- For command-line
          wilder.cmdline_pipeline({
            language = 'vim',
            fuzzy = 1,  -- Enable fuzzy matching
          }),
          -- For search
          wilder.search_pipeline()
        ),
      })

      -- Configure renderers
      wilder.set_option('renderer', wilder.renderer_mux({
        [':'] = wilder.popupmenu_renderer({
          highlighter = wilder.basic_highlighter(),
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() },
          pumblend = 20,  -- Transparency (0-100)
        }),
        ['/'] = wilder.wildmenu_renderer({
          highlighter = wilder.basic_highlighter(),
        }),
      }))
    end,
  },
}
