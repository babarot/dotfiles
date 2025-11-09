-- ============================================================================
-- Go Development Tools
-- ============================================================================

return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require('go').setup({
        -- Disable icons (use text instead)
        icons = false,

        -- LSP settings
        lsp_cfg = false, -- Use existing lspconfig setup
        lsp_gofumpt = true,
        lsp_on_attach = true,

        -- Diagnostic settings
        lsp_diag_hdlr = true,
        lsp_diag_virtual_text = { space = 0, prefix = '■' },
        lsp_diag_signs = true,
        lsp_diag_update_in_insert = false,

        -- Code formatting
        lsp_document_formatting = true,
        gopls_cmd = nil, -- Use gopls from PATH
        gopls_remote_auto = true,

        -- Build/test settings
        dap_debug = false, -- Disable DAP integration
        dap_debug_gui = false,
        dap_debug_vt = false,

        -- Other settings
        textobjects = true,
        test_runner = 'go',
        verbose_tests = true,
        run_in_floaterm = false,

        -- Trouble integration
        trouble = false,
        luasnip = false,
      })

      -- Auto format on save with goimports
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end,
    keys = {
      -- Code generation
      { '<leader>gj', '<cmd>GoAddTag json<cr>',      desc = 'Add JSON tags',      ft = 'go' },
      { '<leader>gy', '<cmd>GoAddTag yaml<cr>',      desc = 'Add YAML tags',      ft = 'go' },
      { '<leader>gr', '<cmd>GoRmTag<cr>',            desc = 'Remove tags',        ft = 'go' },
      { '<leader>gf', '<cmd>GoFillStruct<cr>',       desc = 'Fill struct',        ft = 'go' },
      { '<leader>ge', '<cmd>GoIfErr<cr>',            desc = 'Add if err',         ft = 'go' },

      -- Testing
      { '<leader>gt', '<cmd>GoTest<cr>',             desc = 'Run tests',          ft = 'go' },
      { '<leader>gT', '<cmd>GoTestFunc<cr>',         desc = 'Test function',      ft = 'go' },
      { '<leader>gc', '<cmd>GoCoverage<cr>',         desc = 'Test coverage',      ft = 'go' },

      -- Build/Run
      { '<leader>gb', '<cmd>GoBuild<cr>',            desc = 'Build',              ft = 'go' },
      { '<leader>gR', '<cmd>GoRun<cr>',              desc = 'Run',                ft = 'go' },

      -- Code navigation
      { '<leader>gi', '<cmd>GoImpl<cr>',             desc = 'Implement interface', ft = 'go' },
      { '<leader>gI', '<cmd>GoImplements<cr>',       desc = 'Show implements',    ft = 'go' },
    },
  },
}
