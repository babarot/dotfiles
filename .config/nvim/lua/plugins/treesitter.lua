-- ============================================================================
-- Treesitter - Syntax Highlighting & Parsing
-- ============================================================================

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- Enable auto_install for missing parsers
        auto_install = true,
        ensure_installed = {
          'bash',
          'go',
          'gosum',
          'gomod',
          'hcl',
          'lua',
          'json',
          'make',
          'markdown',
          'nginx',      -- Nginx configuration files (built-in support)
          'terraform',
          'yaml',
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
