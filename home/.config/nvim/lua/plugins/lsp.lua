-- ============================================================================
-- LSP Configuration (Neovim 0.11+ vim.lsp.config / vim.lsp.enable)
-- ============================================================================
-- Servers come from Nix (nix/home/tools/neovim.nix) and are found on PATH.
-- nvim-lspconfig is only the source of per-server defaults (its lsp/*.lua);
-- its old require('lspconfig').xxx.setup() framework is deprecated.
-- Keymaps are Neovim's defaults (K, grn, gra, grr, gri, grt, gO, [d, ]d),
-- plus the Lspsaga ones in lspsaga.lua.

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      vim.lsp.enable({ 'gopls', 'lua_ls' })

      -- Breadcrumbs for barbecue.nvim
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-navic', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method('textDocument/documentSymbol') then
            local ok, navic = pcall(require, 'nvim-navic')
            if ok then
              navic.attach(client, args.buf)
            end
          end
        end,
      })
    end,
  },
}
