-- ============================================================================
-- Bufferline - Buffer Line
-- ============================================================================

return {
  {
    'akinsho/bufferline.nvim',
    enabled = false,  -- Disabled: using barbar.nvim instead
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'buffers', -- set to "tabs" to only show tabpages instead

          -- Style
          style_preset = require('bufferline').style_preset.default,
          themable = true,
          numbers = 'none',

          -- Mouse support
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          left_mouse_command = 'buffer %d',
          middle_mouse_command = nil,

          -- Buffer management
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '×',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',

          -- Tabs
          max_name_length = 30,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 21,

          -- Diagnostics (LSP integration)
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match('error') and ' ' or ' '
            return ' ' .. icon .. count
          end,

          -- Offsets (for sidebars like nvim-tree)
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              text_align = 'left',
              separator = true,
            },
          },

          -- Color
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,

          -- Separator
          separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
          enforce_regular_tabs = false,
          always_show_bufferline = true,

          -- Sorting
          sort_by = 'insert_after_current',
        },
      })
    end,
  },
}
