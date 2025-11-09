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

  -- Split/Join code blocks (using Tree-sitter)
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { '<space>m', function() require('treesj').toggle() end, desc = 'Toggle Split/Join' },
      -- { '<space>j', function() require('treesj').join() end, desc = 'Join Code Block' },
      -- { '<space>s', function() require('treesj').split() end, desc = 'Split Code Block' },
    },
    opts = {
      use_default_keymaps = false,  -- Use custom keymaps defined above
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = 'hold',  -- Keep cursor position after split/join
      notify = true,  -- Show notification on split/join
      dot_repeat = true,  -- Enable dot repeat
    },
  },
}
