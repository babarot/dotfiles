-- ============================================================================
-- lualine.nvim - Status line
-- ============================================================================

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'tokyonight',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        globalstatus = true,  -- Single statusline for all windows
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha' },
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path
            symbols = {
              modified = '[+]',
              readonly = '[RO]',
              unnamed = '[No Name]',
            },
          },
        },
        lualine_x = {
          'encoding',
          {
            'fileformat',
            symbols = {
              unix = 'LF',
              dos = 'CRLF',
              mac = 'CR',
            },
          },
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'lazy', 'mason' },
    },
  },
}
