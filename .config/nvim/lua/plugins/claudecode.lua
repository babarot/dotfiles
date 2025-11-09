-- ============================================================================
-- ClaudeCode.nvim - Advanced Claude Code Integration (WebSocket + MCP)
-- ============================================================================
--
-- Requirements:
--   - Claude Code CLI installed (brew install claude)
--   - Neovim 0.8+
--   - folke/snacks.nvim (for terminal support)
--
-- How it works:
--   - Creates WebSocket server that Claude CLI connects to
--   - Implements Model Context Protocol (MCP) like VS Code extension
--   - Real-time file and selection context sharing
--   - Native diff support for accepting/rejecting changes
--
-- Usage:
--   - <leader>ac - Toggle Claude terminal
--   - <leader>af - Focus Claude terminal
--   - <leader>as - Send selection to Claude (visual mode)
--   - <leader>aa - Accept diff changes
--   - <leader>ad - Deny diff changes
--   - :ClaudeCode - Toggle terminal
--   - :ClaudeCodeAdd <file> - Add file to context

return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",  -- For enhanced terminal support
    },
    opts = {
      -- Logging level: "trace", "debug", "info", "warn", "error"
      log_level = "info",

      -- Track current cursor selection in real-time
      track_selection = true,

      -- Use git repository root as working directory
      git_repo_cwd = true,

      -- Terminal configuration
      terminal = {
        -- Terminal provider: "snacks", "native", "external", "none", or custom table
        provider = "snacks",

        -- Snacks.nvim terminal options
        snacks_win_opts = {
          position = "float",  -- "float", "bottom", "top", "left", "right"
          width = 0.85,        -- Float window width (85% of screen)
          height = 0.85,       -- Float window height (85% of screen)
          border = "rounded",  -- Border style
        },

        -- Working directory options
        -- cwd = vim.fn.getcwd(),  -- Static path (uncomment to use)
        -- cwd_provider = function(ctx) return ctx.cwd end,  -- Dynamic function

        -- For external terminal (when provider = "external")
        -- provider_opts = {
        --   external_terminal_cmd = "alacritty -e %s",
        -- },
      },

      -- Optional: Path to local Claude installation
      -- terminal_cmd = "~/.claude/local/claude",
    },

    keys = {
      -- Main commands
      {
        "<leader>ac",
        "<cmd>ClaudeCode<cr>",
        desc = "ClaudeCode: Toggle",
      },
      {
        "<leader>af",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "ClaudeCode: Focus",
      },

      -- Send selection to Claude
      {
        "<leader>as",
        "<cmd>ClaudeCodeSend<cr>",
        mode = "v",
        desc = "ClaudeCode: Send Selection",
      },

      -- Diff management
      {
        "<leader>aa",
        "<cmd>ClaudeCodeDiffAccept<cr>",
        desc = "ClaudeCode: Accept Diff",
      },
      {
        "<leader>ad",
        "<cmd>ClaudeCodeDiffDeny<cr>",
        desc = "ClaudeCode: Deny Diff",
      },
    },

    config = function(_, opts)
      require("claudecode").setup(opts)
    end,
  },
}
