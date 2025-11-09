-- ============================================================================
-- Visual Enhancements - 視覚補助プラグイン
-- ============================================================================

return {
  -- TODO/FIXME/NOTE などのコメントをハイライト
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

  -- 末尾空白のハイライトと削除
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

  -- スクロールバー表示
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

  -- ウィンバーにパンくずリスト（Treesitter + LSP）
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

  -- カーソル行の自動表示/非表示（挿入モード時のみ表示など）
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
}
