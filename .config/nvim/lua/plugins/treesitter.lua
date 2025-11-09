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
        -- Disable auto_install to avoid conflicts
        auto_install = false,
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
