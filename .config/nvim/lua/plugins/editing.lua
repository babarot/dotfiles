-- ============================================================================
-- Editing Enhancement
-- ============================================================================

return {
  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt', 'vim' },
      })
    end,
  },

  -- Comment
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('Comment').setup()
      -- Visual mode: K for comment toggle
      vim.keymap.set('v', 'K', 'gc', { silent = true, remap = true })
    end,
  },

  -- Surround
  {
    'kylechui/nvim-surround',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-surround').setup({})
    end,
  },
}
