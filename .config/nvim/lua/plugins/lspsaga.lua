-- ============================================================================
-- LSPsaga - LSP UI Enhancement
-- ============================================================================

return {
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
      'folke/which-key.nvim',
    },
    config = function()
      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          code_action = '💡',
        },
        lightbulb = {
          enable = false,  -- Disable lightbulb (can be distracting)
        },
        symbol_in_winbar = {
          enable = false,  -- Disable symbol in winbar (use barbecue or other)
        },
        outline = {
          win_position = 'right',
          win_width = 50,
          auto_preview = true,
          detail = true,
          auto_refresh = true,
          auto_close = true,
          keys = {
            jump = '<CR>',
            expand_collapse = 'u',
            quit = 'q',
          },
        },
        definition = {
          keys = {
            edit = '<CR>',
            vsplit = '<C-v>',
            split = '<C-x>',
            quit = 'q',
          },
        },
      })

    end,
    keys = {
      -- K-based LSP operations (K alone shows which-key menu)
      -- K alone: do nothing (prevents default K behavior like go doc)
      { 'K',  '<Nop>',                                     desc = '+LSP' },
      { 'KK', '<cmd>Lspsaga hover_doc<CR>',                desc = 'Hover' },
      { 'Kr', '<cmd>Lspsaga rename<CR>',                   desc = 'Rename' },
      { 'KR', '<cmd>Lspsaga rename ++project<CR>',         desc = 'Rename (Project)' },
      { 'Ko', '<cmd>Lspsaga outline<CR>',                  desc = 'Outline' },
      { 'Ka', '<cmd>Lspsaga code_action<CR>',              desc = 'Code Action', mode = { 'n', 'v' } },
      { 'Kd', '<cmd>Lspsaga show_line_diagnostics<CR>',    desc = 'Line Diagnostics' },
      { 'KD', '<cmd>Lspsaga show_buf_diagnostics<CR>',     desc = 'Buffer Diagnostics' },
      { 'Kp', '<cmd>Lspsaga peek_definition<CR>',          desc = 'Peek Definition' },
      { 'Kt', '<cmd>Lspsaga peek_type_definition<CR>',     desc = 'Peek Type' },
      { 'Ki', '<cmd>Lspsaga incoming_calls<CR>',           desc = 'Incoming Calls' },
      { 'Kc', '<cmd>Lspsaga outgoing_calls<CR>',           desc = 'Outgoing Calls' },
      { 'Ks', function() require('snacks').picker.lsp_symbols() end, desc = 'Document Symbols' },

      -- Alternative: Keep some old bindings for backward compatibility
      { 'gp',         '<cmd>Lspsaga peek_definition<CR>',     desc = 'Peek Definition' },

      -- Diagnostics navigation
      { '[d',         '<cmd>Lspsaga diagnostic_jump_prev<CR>',  desc = 'Prev Diagnostic' },
      { ']d',         '<cmd>Lspsaga diagnostic_jump_next<CR>',  desc = 'Next Diagnostic' },
    },
  },
}
