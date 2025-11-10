-- ============================================================================
-- Visual Enhancements - Visual Aid Plugins
-- ============================================================================

return {
  -- Highlight TODO/FIXME/NOTE comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
      highlight = {
        before = '',
        keyword = 'wide',
        after = 'fg',
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
      },
    },
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO comment' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO comment' },
    },
  },

  -- Highlight and remove trailing whitespace
  {
    'ntpeters/vim-better-whitespace',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
      vim.g.better_whitespace_filetypes_blacklist = { 'diff', 'git', 'gitcommit', 'qf', 'help', 'dashboard' }
    end,
  },

  -- Display scrollbar
  {
    'dstein64/nvim-scrollview',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      excluded_filetypes = { 'dashboard', 'alpha', 'neo-tree' },
      current_only = true,
      signs_on_startup = { 'diagnostics', 'search' },
      diagnostics_severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
    },
  },

  -- Breadcrumb list in winbar (Treesitter + LSP)
  {
    'utilyre/barbecue.nvim',
    dependencies = {
      'SmiteshP/nvim-navic',
      'echasnovski/mini.icons',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      theme = 'tokyonight',
      create_autocmd = false,  -- Manual update for performance
      show_modified = true,
      symbols = {
        separator = '',
      },
      exclude_filetypes = { 'dashboard', 'alpha', 'neo-tree', 'toggleterm' },
    },
    config = function(_, opts)
      require('barbecue').setup(opts)

      -- Update barbecue on certain events for better performance
      vim.api.nvim_create_autocmd({
        'WinResized',
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',
        'BufModifiedSet',
      }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
          require('barbecue.ui').update()
        end,
      })
    end,
  },

  -- Auto show/hide cursor line (e.g., show only in insert mode)
  {
    'tummetott/reticle.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_startup = {
        cursorline = true,
        cursorcolumn = false,
      },
      disable_in_insert = false,
      always = {
        cursorline = { 'TelescopePrompt', 'dashboard' },
      },
      never = {
        cursorline = {},
      },
    },
  },

  -- Automatically highlight cursorline and cursorcolumn after delay
  {
    'babarot/cursor-x.nvim',
    event = { 'BufRead' },
    opts = {
      interval = 3000,  -- Highlight after 3 seconds
      always_cursorline = true,
      filetype_exclude = {
        'snacks_picker_list',
        'neo-tree',
        'yaml',
        'dashboard',
        'alpha',
        'toggleterm',
      },
    },
  },

  {
    'kevinhwang91/nvim-hlslens',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('hlslens').setup({
        calm_down = true,  -- Auto-hide search results after cursor movement
        nearest_only = false,
        nearest_float_when = 'auto',
      })

      -- Integration with search keymaps
      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },
}
