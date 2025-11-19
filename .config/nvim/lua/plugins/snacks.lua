-- ============================================================================
-- Snacks.nvim - QoL UI Plugins Collection
-- ============================================================================

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
      'echasnovski/mini.icons', -- Icon support (recommended)
      'folke/which-key.nvim',   -- Required for toggle keymaps
    },
    opts = {
      -- Essential features
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        width = 60,
        formats = {
          key = function(item)
            return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
          end,
        },
        sections = {
          -- { section = "header" },
          { title = "MRU",            padding = 1 },
          { section = "recent_files", limit = 8,                            padding = 1 },
          { title = "MRU ",           file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
          { section = "recent_files", cwd = true,                           limit = 8,  padding = 1 },
          -- { title = "Sessions", padding = 1 },
          -- { section = "projects", padding = 1 },
          { title = "Bookmarks",      padding = 1 },
          { section = "keys",         padding = 1 },
          -- { title = "Status", padding = 1 },
          -- { section = 'terminal', cmd = 'git status --short --branch', height = 5, padding = 1, ttl = 5 * 60 },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      scroll = { enabled = false }, -- Disable smooth scroll (can be heavy)
      statuscolumn = { enabled = true },
      words = { enabled = true },
      -- File/Code navigation (‼️ Essential)
      picker = {
        enabled = true,
        focus = "list", -- Start in Normal mode (focus on list, not input)
        layout = function(source)
          local layouts = {
            files = "vertical",               -- Top-bottom layout for files
            git_files = "vertical",           -- Top-bottom layout for git files
            recent = "vertical",              -- Top-bottom layout for recent files
          }
          return layouts[source] or "default" -- Default: side-by-side layout
        end,
        sources = {
          explorer = {
            -- Explorer Keymaps:
            --   <CR>  : Open file / Enter directory (cd into it)
            --   l     : Open file / Toggle directory expand/collapse
            --   h     : Close directory (collapse)
            --   <BS>  : Go to parent directory
            --   /     : Filter/search items
            --   .     : Focus on current directory (alternative to Enter)
            --   H     : Toggle hidden files
            --   I     : Toggle ignored files (gitignore)
            --   a     : Add new file/directory
            --   d     : Delete file/directory
            --   r     : Rename file/directory
            --   c     : Copy file/directory
            --   m     : Move file/directory
            --   y     : Yank (copy) file path
            --   u     : Update/refresh file tree
            auto_close = true,    -- Auto-close explorer when opening a file
            layout = {
              preset = "default", -- Use default floating layout instead of sidebar
              preview = false,    -- Disable preview window
            },
            actions = {
              -- Custom action: Enter opens file or cd into directory
              smart_enter = function(picker)
                local item = picker:current()
                if not item then return end

                -- Check if it's a directory
                local is_directory = item.file and vim.fn.isdirectory(item.file) == 1

                if is_directory then
                  -- For directory: focus on it (cd into it)
                  picker:action("explorer_focus")
                else
                  -- For file: open it
                  picker:action("confirm")
                end
              end,
            },
            win = {
              list = {
                keys = {
                  ["<CR>"] = "smart_enter", -- Enter: Smart open (file) or cd (directory)
                  ["l"] = "confirm",        -- l: Open file or toggle directory
                  ["h"] = "explorer_close", -- h: Close directory
                },
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-p>"] = { "history_back", mode = { "i", "n" } },
            },
          },
        },
      },
      explorer = { enabled = true },
      scope = { enabled = true }, -- Treesitter scope navigation
      -- GitHub integration
      gh = {
        enabled = true,
        win = {
          border = "rounded",
        },
      },
    },
    keys = {
      -- Space prefix (shows which-key menu)
      { '<Space>',        '<Nop>',                                  desc = '+Space Commands' },

      -- Picker: File/Buffer navigation
      { '<space><space>', function() Snacks.picker.smart() end,     desc = 'Smart Find (Files/Git)' },
      { '<Space>f',       function() Snacks.picker.files() end,     desc = 'Find Files' },
      { '<Space>j',       function() Snacks.picker.recent() end,    desc = 'Recent Files' },
      { '<leader>fb',     function() Snacks.picker.buffers() end,   desc = 'Find Buffers' },
      { '<leader>fg',     function() Snacks.picker.git_files() end, desc = 'Git Files' },

      -- Picker: Search/Grep
      { '<leader>/',      function() Snacks.picker.grep() end,      desc = 'Grep (All Files)' },
      { '<Space>G',       function() Snacks.picker.git_grep() end,  desc = 'Git Grep (Tracked Files)' },
      {
        '<Space>g',
        function()
          local word = vim.fn.expand('<cword>')
          Snacks.picker.git_grep({ search = word })
        end,
        desc = 'Git Grep Word under Cursor'
      },
      { '<leader>fw', function() Snacks.picker.grep_word() end,           desc = 'Grep Word under Cursor' },
      { 'Q',          function() Snacks.picker.grep_word() end,           desc = 'Grep Word under Cursor' },
      { '<leader>fl', function() Snacks.picker.lines() end,               desc = 'Buffer Lines' },

      -- Picker: Git operations
      { '<leader>gb', function() Snacks.picker.git_branches() end,        desc = 'Git Branches' },
      { '<leader>gl', function() Snacks.picker.git_log() end,             desc = 'Git Log' },
      { '<leader>gs', function() Snacks.picker.git_status() end,          desc = 'Git Status' },

      -- GitHub (snacks.nvim/gh)
      { '<leader>gi', function() Snacks.picker.gh_issue() end,            desc = 'GitHub: List Issues' },
      { '<leader>gp', function() Snacks.picker.gh_pr() end,               desc = 'GitHub: List PRs' },

      -- Picker: LSP
      { 'gd',         function() Snacks.picker.lsp_definitions() end,     desc = 'LSP Definitions' },
      { 'gr',         function() Snacks.picker.lsp_references() end,      desc = 'LSP References' },
      { 'gI',         function() Snacks.picker.lsp_implementations() end, desc = 'LSP Implementations' },
      { '<leader>fs', function() Snacks.picker.lsp_symbols() end,         desc = 'LSP Document Symbols' },
      { 'Ks',         function() Snacks.picker.lsp_symbols() end,         desc = 'LSP: Document Symbols' },

      -- Picker: Misc
      { '<leader>fh', function() Snacks.picker.help() end,                desc = 'Help Pages' },
      { '<leader>fk', function() Snacks.picker.keymaps() end,             desc = 'Keymaps' },
      { '<leader>fc', function() Snacks.picker.commands() end,            desc = 'Commands' },

      -- Explorer
      { '<leader>e',  function() Snacks.explorer() end,                   desc = 'File Explorer' },
      {
        '<Space>k',
        function()
          -- Try to find git root, fallback to current directory
          local current_dir = vim.fn.expand('%:p:h')
          local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(current_dir) .. ' rev-parse --show-toplevel')
              [1]

          if vim.v.shell_error == 0 and git_root then
            -- Open at git root if in a git repository
            Snacks.explorer({ cwd = git_root })
          else
            -- Fallback to current directory
            Snacks.explorer()
          end
        end,
        desc = 'File Explorer (Git Root or Current)'
      },

      -- Utilities
      { '<leader>.',  function() Snacks.scratch() end,                 desc = 'Toggle Scratch Buffer' },
      { '<leader>S',  function() Snacks.scratch.select() end,          desc = 'Select Scratch Buffer' },
      { '<leader>n',  function() Snacks.notifier.show_history() end,   desc = 'Notification History' },
      { '<leader>bd', function() Snacks.bufdelete() end,               desc = 'Delete Buffer' },

      -- Utilities (not picker)
      { '<leader>cR', function() Snacks.rename.rename_file() end,      desc = 'Rename File' },

      -- Terminal
      { '<leader>t',  function() Snacks.terminal() end,                desc = 'Toggle Terminal' },
      { '<c-/>',      function() Snacks.terminal() end,                desc = 'Toggle Terminal' },

      -- Words navigation
      { ']]',         function() Snacks.words.jump(vim.v.count1) end,  desc = 'Next Reference',       mode = { 'n', 't' } },
      { '[[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference',       mode = { 'n', 't' } },
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
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            '<leader>uc')
          Snacks.toggle.treesitter():map('<leader>uT')
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
          Snacks.toggle.inlay_hints():map('<leader>uh')

          -- Create :GH command (migrated from ruanyl/vim-gh-line plugin)
          -- Opens current file/line in Git browser (GitHub, GitLab, Bitbucket, Sourcehut)
          -- Usage: :GH, :10,20GH, or visual mode selection + :GH
          vim.api.nvim_create_user_command('GH', function(opts)
            local line_start, line_end
            if opts.range > 0 then
              line_start = opts.line1
              line_end = opts.line2
            end
            Snacks.gitbrowse({
              line_start = line_start,
              line_end = line_end,
            })
          end, { range = true, desc = 'Open file/line in Git browser' })
        end,
      })
    end,
  },
}
