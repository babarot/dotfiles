-- ============================================================================
-- Indent Blankline - インデントガイド表示
-- ============================================================================

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = true,
        highlight = { 'Function', 'Label' },
        priority = 500,
      },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'alpha',
          'neo-tree',
          'lazy',
          'mason',
          'lspinfo',
          'toggleterm',
          'TelescopePrompt',
          'TelescopeResults',
          '',
        },
        buftypes = {
          'terminal',
          'nofile',
        },
      },
    },
  },
}
