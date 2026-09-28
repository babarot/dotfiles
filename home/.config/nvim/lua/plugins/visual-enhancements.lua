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

  -- Breadcrumbs in winbar (LSP + Treesitter); replaces the archived barbecue.nvim
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      sources = {
        path = {
          -- Paths from the git root: the default is the window's cwd, which
          -- the auto-cd autocmd (lua/config/autocmds.lua) sets to the file's
          -- own directory, leaving only the file name
          relative_to = function(buf, win)
            local root = vim.fs.root(buf, '.git')
            if root then
              return root
            end
            local ok, cwd = pcall(vim.fn.getcwd, win)
            return ok and cwd or vim.fn.getcwd()
          end,
        },
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

}
