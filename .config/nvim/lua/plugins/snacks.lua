-- ============================================================================
-- Snacks.nvim - QoL UI Plugins Collection
-- ============================================================================

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
      'echasnovski/mini.icons',  -- Icon support (recommended)
    },
    opts = {
      -- Essential features
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      scroll = { enabled = false },  -- Disable smooth scroll (can be heavy)
      statuscolumn = { enabled = true },
      words = { enabled = true },

      -- File/Code navigation (‼️ Essential)
      picker = { enabled = true },     -- Universal picker (replaces Telescope)
      explorer = { enabled = true },   -- File browser
      scope = { enabled = true },      -- Treesitter scope navigation
    },
    keys = {
      -- Space prefix (shows which-key menu)
      { '<Space>',         '<Nop>',                                      desc = '+Space Commands' },

      -- Picker: File/Buffer navigation
      { '<leader><space>', function() Snacks.picker.smart() end,        desc = 'Smart Find (Files/Git)' },
      { '<leader>ff',      function() Snacks.picker.files() end,        desc = 'Find Files' },
      { '<leader>fb',      function() Snacks.picker.buffers() end,      desc = 'Find Buffers' },
      { '<leader>fr',      function() Snacks.picker.recent() end,       desc = 'Recent Files' },
      { '<Space>j',        function() Snacks.picker.recent() end,       desc = 'Recent Files' },
      { '<leader>fg',      function() Snacks.picker.git_files() end,    desc = 'Git Files' },

      -- Picker: Search/Grep
      { '<leader>/',       function() Snacks.picker.grep() end,         desc = 'Grep' },
      { '<leader>fw',      function() Snacks.picker.grep_word() end,    desc = 'Grep Word under Cursor' },
      { 'Q',               function() Snacks.picker.grep_word() end,    desc = 'Grep Word under Cursor' },
      { '<leader>fl',      function() Snacks.picker.lines() end,        desc = 'Buffer Lines' },

      -- Picker: Git operations
      { '<leader>gb',      function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
      { '<leader>gl',      function() Snacks.picker.git_log() end,      desc = 'Git Log' },
      { '<leader>gs',      function() Snacks.picker.git_status() end,   desc = 'Git Status' },

      -- Picker: LSP
      { 'gd',              function() Snacks.picker.lsp_definitions() end,     desc = 'LSP Definitions' },
      { 'gr',              function() Snacks.picker.lsp_references() end,      desc = 'LSP References' },
      { 'gI',              function() Snacks.picker.lsp_implementations() end, desc = 'LSP Implementations' },
      { '<leader>fs',      function() Snacks.picker.lsp_symbols() end,         desc = 'LSP Document Symbols' },
      { 'Ks',              function() Snacks.picker.lsp_symbols() end,         desc = 'LSP: Document Symbols' },

      -- Picker: Misc
      { '<leader>fh',      function() Snacks.picker.help() end,         desc = 'Help Pages' },
      { '<leader>fk',      function() Snacks.picker.keymaps() end,      desc = 'Keymaps' },
      { '<leader>fc',      function() Snacks.picker.commands() end,     desc = 'Commands' },

      -- Explorer
      { '<leader>e',       function() Snacks.explorer() end,            desc = 'File Explorer' },

      -- Utilities
      { '<leader>.',       function() Snacks.scratch() end,              desc = 'Toggle Scratch Buffer' },
      { '<leader>S',       function() Snacks.scratch.select() end,       desc = 'Select Scratch Buffer' },
      { '<leader>n',       function() Snacks.notifier.show_history() end, desc = 'Notification History' },
      { '<leader>bd',      function() Snacks.bufdelete() end,            desc = 'Delete Buffer' },

      -- Git utilities (not picker)
      { '<leader>gB',      function() Snacks.gitbrowse() end,            desc = 'Git Browse (GitHub)' },
      { '<leader>cR',      function() Snacks.rename.rename_file() end,   desc = 'Rename File' },

      -- Terminal
      { '<leader>t',       function() Snacks.terminal() end,             desc = 'Toggle Terminal' },
      { '<c-/>',           function() Snacks.terminal() end,             desc = 'Toggle Terminal' },

      -- Words navigation
      { ']]',              function() Snacks.words.jump(vim.v.count1) end,  desc = 'Next Reference', mode = { 'n', 't' } },
      { '[[',              function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
          Snacks.toggle.diagnostics():map('<leader>ud')
          Snacks.toggle.line_number():map('<leader>ul')
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
          Snacks.toggle.treesitter():map('<leader>uT')
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
          Snacks.toggle.inlay_hints():map('<leader>uh')
        end,
      })
    end,
  },
}
