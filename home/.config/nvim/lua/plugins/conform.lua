-- ============================================================================
-- conform.nvim - Lightweight Code Formatter
-- ============================================================================
--
-- Features:
--   - Minimal diff formatting (preserves folds, marks, cursor position)
--   - Range formatting support for all formatters
--   - Multiple formatters chaining
--   - 200+ formatters support
--
-- Commands:
--   :ConformInfo - Show available formatters
--
-- Keymaps:
--   <leader>fm - Format buffer (normal/visual mode)

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = { 'n', 'v' },
        desc = 'Format buffer',
      },
    },
    opts = {
      -- Formatters by filetype
      formatters_by_ft = {
        -- Lua
        lua = { 'stylua' },

        -- Go
        go = { 'gofmt', 'goimports' },

        -- Python
        python = { 'isort', 'black' },

        -- JavaScript/TypeScript
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },

        -- Web
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },

        -- JSON/YAML
        json = { 'jq' },
        -- yaml = { 'yamlfmt' },  -- Disabled

        -- Markdown
        markdown = { 'prettier' },

        -- Shell
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },

        -- Rust
        rust = { 'rustfmt' },

        -- Terraform/HCL
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        hcl = { 'terraform_fmt' },
      },

      -- Format on save
      format_on_save = function(bufnr)
        -- Disable format on save for YAML files
        if vim.bo[bufnr].filetype == 'yaml' then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,

      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },  -- 2 spaces indent
        },
      },

      -- Notification on format
      notify_on_error = true,
    },
  },
}
