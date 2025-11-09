-- ============================================================================
-- Additional Colorschemes for ftcolor.nvim
-- ============================================================================

return {
  -- Already installed: tokyonight.nvim (in colorscheme.lua)

  -- For vim files
  { 'daschw/leaf.nvim' },

  -- For Go files
  { 'junegunn/seoul256.vim' },

  -- For shell files
  {
    'marko-cerovac/material.nvim',
    config = function()
      vim.g.material_style = 'palenight'
      require('material').setup({
        contrast = {
          terminal = false,
          sidebars = false,
          floating_windows = false,
          cursor_line = false,
          non_current_windows = false,
          filetypes = {},
        },
        styles = {
          comments = { italic = true },
          strings = {},
          keywords = {},
          functions = {},
          variables = {},
          operators = {},
          types = {},
        },
      })
    end,
  },

  -- For bash/zsh files
  { 'projekt0n/github-nvim-theme' },

  -- For HCL/terraform files
  {
    'gbprod/nord.nvim',
    config = function()
      require('nord').setup({
        transparent = false,
        terminal_colors = true,
        diff = { mode = 'bg' },
        borders = true,
        errors = { mode = 'bg' },
        styles = {
          comments = { italic = true },
          keywords = {},
          functions = {},
          variables = {},
        },
      })
    end,
  },

  -- For JSON files
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        terminalColors = true,
        theme = 'wave',
        background = { dark = 'wave', light = 'lotus' },
      })
    end,
  },

  -- Additional colorschemes (optional)
  {
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        options = {
          styles = {
            comments = 'italic',
            keywords = 'bold',
            types = 'italic,bold',
          }
        },
      })
    end,
  },
  { 'akinsho/horizon.nvim' },
  { 'olivercederborg/poimandres.nvim' },
  { 'cocopon/iceberg.vim' },
  { 'voidekh/kyotonight.vim' },
  { 'AlessandroYorba/Despacio' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'maxmx03/solarized.nvim' },
}
