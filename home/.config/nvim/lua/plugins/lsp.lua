-- ============================================================================
-- LSP Configuration (Neovim 0.11+ vim.lsp.config / vim.lsp.enable)
-- ============================================================================
-- Servers come from Nix (nix/home/tools/neovim.nix) and are found on PATH.
-- nvim-lspconfig is only the source of per-server defaults (its lsp/*.lua);
-- its old require('lspconfig').xxx.setup() framework is deprecated.
-- Keymaps are Neovim's defaults (K, grn, gra, grr, gri, grt, gO, [d, ]d),
-- plus the Lspsaga ones in lspsaga.lua (peek, call hierarchy, outline).

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

      -- [d / ]d are Neovim's defaults; show the diagnostic jumped to in a
      -- float, as Lspsaga's diagnostic_jump_* did
      vim.diagnostic.config({
        jump = {
          on_jump = function(diagnostic, bufnr)
            if diagnostic then
              vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
            end
          end,
        },
      })
    end,
  },
}
