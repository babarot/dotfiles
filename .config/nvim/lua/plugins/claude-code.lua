-- ============================================================================
-- Claude Code Integration
-- ============================================================================
--
-- Requirements:
--   - Claude Code CLI installed (brew install claude)
--   - Neovim 0.7+
--
-- Usage:
--   - <C-,> - Toggle Claude Code terminal
--   - <leader>cC - Toggle with --continue flag
--   - <leader>cV - Toggle with --verbose flag
--   - :ClaudeCode - Toggle terminal
--   - :ClaudeCodeContinue - Resume recent conversation
--   - :ClaudeCodeVerbose - Enable verbose logging

return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup({
        -- Window configuration
        window = {
          split_ratio = 0.3,         -- Size of split window (30% of screen)
          position = "botright",     -- "botright", "topleft", "float"
          enter_insert = true,       -- Automatically enter insert mode
          hide_numbers = true,       -- Hide line numbers in terminal
          hide_signcolumn = true,    -- Hide sign column in terminal

          -- Float window configuration (when position = "float")
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },

        -- Auto-refresh configuration
        refresh = {
          enable = true,             -- Enable automatic file reloading
          updatetime = 100,          -- How often to check for changes (ms)
          timer_interval = 1000,     -- Debounce interval (ms)
          show_notifications = true, -- Show reload notifications
        },

        -- Git integration
        git = {
          use_git_root = true,       -- Use git root as working directory
        },

        -- Shell configuration
        shell = {
          separator = '&&',
          pushd_cmd = 'pushd',
          popd_cmd = 'popd',
        },

        -- Claude command configuration
        command = "claude",

        -- Command variants
        command_variants = {
          continue = "--continue",   -- Resume recent conversation
          resume = "--resume",       -- Show conversation selector
          verbose = "--verbose",     -- Enable verbose logging
        },

        -- Keymaps
        keymaps = {
          toggle = {
            normal = "<C-,>",        -- Toggle in normal mode
            terminal = "<C-,>",      -- Toggle in terminal mode
            variants = {
              continue = "<leader>cC",  -- Toggle with --continue
              verbose = "<leader>cV",   -- Toggle with --verbose
            },
          },
          window_navigation = true,  -- Enable <C-h/j/k/l> navigation
          scrolling = true,          -- Enable <C-f>/<C-b> scrolling
        },
      })
    end,
  },
}
