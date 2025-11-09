-- ============================================================================
-- LSP Configuration (Minimal)
-- ============================================================================

return {
  -- Mason
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  -- LSPconfig (must be loaded before mason-lspconfig)
  {
    'neovim/nvim-lspconfig',
    lazy = true,
  },

  -- Mason-LSPconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'saghen/blink.cmp',
    },
    config = function()
      -- Capabilities for blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- on_attach function for LSP servers
      local on_attach = function(client, bufnr)
        -- Attach nvim-navic for barbecue.nvim (breadcrumbs)
        if client.server_capabilities.documentSymbolProvider then
          local navic_ok, navic = pcall(require, 'nvim-navic')
          if navic_ok then
            navic.attach(client, bufnr)
          end
        end
      end

      -- Setup servers via mason-lspconfig (v2.0+ API)
      require('mason-lspconfig').setup({
        ensure_installed = { 'gopls', 'lua_ls' },
        automatic_installation = false,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- Custom handler for lua_ls
          ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' },
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
