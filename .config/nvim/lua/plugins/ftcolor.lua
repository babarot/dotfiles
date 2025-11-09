-- ============================================================================
-- ftcolor.nvim - File type based colorscheme switcher
-- ============================================================================

return {
  {
    'babarot/ftcolor.nvim',
    event = 'VeryLazy',
    config = function()
      require('ftcolor').setup({
        enabled = true,
        default_colorscheme = 'tokyonight',
        redraw = true,
        mappings = {
          -- lua = 'leaf',         -- Luaファイルはleafカラースキーム
          -- vim = 'leaf',
          -- go = 'seoul256',
          -- sh = 'material',
          -- bash = 'github_dark',
          -- zsh = 'github_dark',
          hcl = 'nord',
          json = 'kanagawa',
          yaml = 'tokyonight',
          terraform = 'nord',
        },
        exclude_special_buffers = true,
      })
    end,
  },
}
