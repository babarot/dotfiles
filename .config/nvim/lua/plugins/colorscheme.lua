-- ============================================================================
-- Colorscheme
-- ============================================================================

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon", -- storm, moon (default), night, day
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },  -- No italic for keywords (same as old config)
          functions = {},
          variables = {},
        },
        on_highlights = function(hl, colors)
          hl['@keyword'] = { italic = false }
          hl.Comment = { italic = true }
        end,
      })

      -- Load the colorscheme
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
