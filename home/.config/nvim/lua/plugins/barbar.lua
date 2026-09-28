-- ============================================================================
-- Barbar - Tab/Buffer Line
-- ============================================================================

return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- Enable/disable animations
      animation = true,

      -- Enable/disable auto-hiding the tab bar when there is a single buffer
      auto_hide = false,

      -- Enable/disable current/total tabpages indicator (top right corner)
      tabpages = true,

      -- Enable/disable clickable tabs
      clickable = true,

      -- Excludes buffers from the tabline
      exclude_ft = { 'qf' },
      exclude_name = {},

      -- Show every buffer
      hide = { extensions = false, inactive = false },

      -- Disable highlighting alternate buffers
      highlight_alternate = false,

      -- Disable highlighting file icons in inactive buffers
      highlight_inactive_file_icons = false,

      -- Enable highlighting visible buffers
      highlight_visible = true,

      -- Enable/disable icons
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = {
          custom_colors = false,
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        modified = { button = '●' },
        pinned = { button = '車', filename = true },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = false },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },

      -- If true, new buffers will be inserted at the start/end of the list.
      insert_at_end = false,
      insert_at_start = false,

      -- Sets the maximum padding width with which to surround each tab
      maximum_padding = 1,

      -- Sets the minimum padding width with which to surround each tab
      minimum_padding = 1,

      -- Sets the maximum buffer name length.
      maximum_length = 30,

      -- Sets the minimum buffer name length.
      minimum_length = 0,

      -- If set, the letters for each buffer in buffer-pick mode will be
      -- assigned based on their name. Otherwise or in case all letters are
      -- already assigned, the behavior is to assign letters in order of
      -- usability (see order below)
      semantic_letters = true,

      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        -- NvimTree = true,
        -- Or, specify the text used for the offset:
        -- undotree = { text = 'undotree' },
        -- Or, specify the event which the sidebar executes when leaving:
        -- ['neo-tree'] = { event = 'BufWipeout' },
        -- Or, specify both
        -- Outline = { event = 'BufWinLeave', text = 'symbols-outline' },
      },

      -- New buffer letters are assigned in this order. This order is
      -- optimal for the qwerty keyboard layout but might need adjustment
      -- for other layouts.
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

      -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
      -- where X is the buffer number. But only a static string is accepted here.
      no_name_title = nil,
    },
  },

  -- nvim-web-devicons (required by barbar)
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
}
