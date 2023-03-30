local opt = {
  root = vim.fn.stdpath('data') .. '/lazy',                 -- directory where plugins will be installed
  lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json', -- lockfile generated after running update.
  git = {
    log        = { '--since=3 days ago' },
    timeout    = 120,
    url_format = 'https://github.com/%s.git',
    filter     = true,
  },
  dev = {
    -- path = vim.fn.stdpath('config') .. '/lua',
    path = '~/src/github.com',
    fallback = false,
  },
  install = {
    missing = true,
    colorscheme = { 'seoul256' },
  },
}

require('lazy').setup({
  -- Development
  {
    'nvim-treesitter/nvim-treesitter',
    commit = '356c9db3478b1bc6d0f0eefcb397989e50fdc35f',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    build = [[vim.api.nvim_command('TSUpdate')]],
    dependencies = {
      {
        'yioneko/nvim-yati',
        commit = '8240f369d47c389ac898f87613e0901f126b40f3',
        lazy = true,
        event = { 'BufReadPost', 'BufNewFile' },
      },
      {
        'andymass/vim-matchup',
        commit = 'f69d1ac5bd3c4e6ad349f64317000cc9a4a895cf',
        lazy = true,
        event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
        config = function()
          vim.g.loaded_matchit = 1
          vim.g.matchup_matchparen_offscreen = { method = 'popup' }
          vim.g.matchup_matchparen_enabled = 1
          vim.cmd([[
          " hi MatchParen ctermbg=blue guibg=#364a82 cterm=underline gui=underline guifg=#c0caf5 guibg=#3d59a1
          hi MatchParen ctermbg=blue guibg=lightblue cterm=underline gui=underline
          hi MatchWord ctermbg=blue guibg=lightblue cterm=underline gui=underline
          hi MatchParenCur ctermbg=blue guibg=lightblue cterm=underline gui=underline
          hi MatchWordCur ctermbg=blue guibg=lightblue cterm=underline gui=underline
        ]])
        end,
      },
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        ensure_installed = {
          'bash', 'dart', 'gitignore', 'go', 'gosum', 'gomod', 'hcl',
          'lua', 'javascript', 'json', 'jsonnet', 'make', 'markdown',
          'proto', 'python', 'rego', 'sql', 'terraform', 'typescript',
          'yaml', 'vhs',
        },
        highlight = { enable = true },
        indent = { enable = false }, -- disable builtin indent module to use yati
        yati = {
          enable = true,
          default_lazy = true,
          --   'auto': fallback to vim auto indent
          --   'asis': use current indent as-is
          --   'cindent': see `:h cindent()`
          default_fallback = 'auto'
        },
        matchup = {
          enable = true,     -- mandatory, false will disable the whole extension
          disableLangs = {}, -- list of language that will be disabled
        },
      }
    end
  },
  {
    'folke/neodev.nvim',
    tag = 'v2.4.0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = { 'lua' }
  },
  {
    'dstein64/vim-startuptime',
    tag = 'v4.3.0',
    lazy = true,
    cmd = { 'StartupTime' }
  },
  {
    'cocopon/vaffle.vim',
    commit = '0a314644c38402b659482568525b1303f7d0e01d',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'nvim-lua/plenary.nvim',       tag = 'v0.1.3' },
  { 'nvim-lua/popup.nvim',         commit = 'b7404d35d5d3548a82149238289fa71f7f6de4ac' },
  { 'MunifTanjim/nui.nvim',        commit = 'd147222a1300901656f3ebd5b95f91732785a329' },
  { 'nvim-tree/nvim-web-devicons', commit = '4709a504d2cd2680fb511675e64ef2790d491d36' },
  {
    'bfontaine/Brewfile.vim',
    commit = 'f13b98b92f2e9b9e38f3b1d45d41e19049d671df',
    lazy = true,
    ft = { 'ruby', 'brewfile' },
  },
  {
    'b4b4r07/vim-ltsv',
    commit = 'b1b027e29b5c35cfa697a0307e10279111114e03',
    lazy = true,
    ft = { 'ltsv' },
  },
  {
    'nathom/filetype.nvim',
    commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027',
    -- DO NOT DO LAZY LOAD
    config = function()
      require('filetype').setup({
        overrides = {
          extensions = {
            tape = 'vhs',
          },
          literal = {
            Brewfile = 'brewfile'
          },
          function_extensions = {
            ['sh'] = function()
              vim.bo.filetype = 'sh'
              vim.bo.iskeyword = vim.bo.iskeyword .. ',:'
            end,
            ['zsh'] = function()
              vim.bo.filetype = 'zsh'
              vim.bo.iskeyword = vim.bo.iskeyword .. ',:'
            end,
            ['go'] = function()
              vim.bo.filetype = 'go'
              vim.bo.autoindent = true
              vim.bo.expandtab = false
              vim.bo.shiftwidth = 4
              vim.bo.softtabstop = 4
              vim.bo.tabstop = 4
            end,
          },
          function_literal = {},
        },
      })
    end,
  },

  -- Project
  {
    'goolord/alpha-nvim',
    commit = '3847d6baf74da61e57a13e071d8ca185f104dc96',
    event = { 'VimEnter' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local theta = require('alpha.themes.theta')
      local dashboard = require('alpha.themes.dashboard')
      local header = {
        type = 'text',
        val = {
          [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
          [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
          [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
          [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
          [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
          [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
        },
        opts = {
          position = 'center',
          hl = 'Type',
        },
      }
      local links = {
        type = 'group',
        val = {
          { type = 'text',    val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
          { type = 'padding', val = 1 },
          dashboard.button('r', '  Recent files', ':Telescope oldfiles <CR>'),
          dashboard.button('f', '  Find files', ':Telescope find_files <CR>'),
          dashboard.button('d', '  Directories', '<cmd>Neotree float<CR>'),
          dashboard.button('p', '  Projects',
            -- at this time, telescope-projects has not been loaded, so directly call it
            -- [[<cmd>lua require('telescope').load_extension('projects').load_commnad('projects')<CR>]]),
            [[<cmd>lua require('telescope').load_extension('projects')<CR><cmd>Telescope projects<CR>]]),
          dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
          dashboard.button('l', '鈴 Lazy', ':Lazy<CR>'),
          -- dashboard.button('c', '  Configuration',
          --   '<cmd>cd ' .. vim.fn.stdpath('config') .. '/lua<CR>'),
          --   '<cmd>e ' .. vim.fn.stdpath('config') .. '/lua/plugins/init.lua<CR>'),
          dashboard.button('q', '  Quit', ':qa<CR>'),
          -- dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
        },
        position = 'center',
      }
      local recent = require('alpha.themes.theta').config.layout[4]
      local version = vim.version() or { major = 0, minor = 0, patch = 0 }
      theta.config = {
        layout = {
          { type = 'padding', val = 2 }, header,
          -- show neovim version
          {
            type = 'text',
            val = ' v' .. version.major .. '.' .. version.minor .. '.' .. version.patch,
            opts = { hl = 'SpecialComment', position = 'center' },
          },
          -- each action
          { type = 'padding', val = 2 }, links,
          { type = 'padding', val = 2 }, recent,
          { type = 'padding', val = 2 },
        },
        opts = {
          noautocmd = false,
          redraw_on_resize = true,
          setup = function()
            vim.api.nvim_create_autocmd('DirChanged', {
              pattern = '*',
              callback = function()
                require('alpha').redraw()
              end,
            })
          end,
        },
      }
      return theta
    end,
    config = function(_, theta)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end
      require('alpha').setup(theta.config)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local loaded = '⚡ Loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          table.insert(theta.config.layout, {
            type = 'text',
            val = loaded,
            opts = { hl = 'SpecialComment', position = 'center' }
          })
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    -- Use commit instead of tag to use lua_ls.
    'neovim/nvim-lspconfig',
    commit = '62856b20751b748841b0f3ec5a10b1e2f6a6dbc9',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        commit = '01dfdfd36be77cb1195b60d580315bf4e2d8e62c',
        config = true,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        commit = '93e58e100f37ef4fb0f897deeed20599dae9d128',
        config = function()
          require 'mason-lspconfig'.setup {
            automatic_installation = true,
            ensure_installed = {
              'bashls',
              'docker_compose_language_service',
              'dockerls',
              'golangci_lint_ls',
              'gopls',
              'graphql',
              'jsonls',
              'jsonnet_ls',
              'lua_ls',
              'sqlls',
              'terraformls',
              'tflint',
              'yamlls',
              'zk',
            },
          }
          require('mason-lspconfig').setup_handlers({
            function()
              require('lspconfig').terraformls.setup({
                on_attach = function(client, _) -- function(client, bufnr)
                  client.server_capabilities.document_formatting = false
                  client.server_capabilities.document_range_formatting = false
                end,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                filetypes = { 'terraform', 'tf' },
              })
            end,
          })
        end
      },
      {
        'jose-elias-alvarez/null-ls.nvim',
        commit = '689cdd78f70af20a37b5309ebc287ac645ae4f76',
        dependencies = {
          { 'nvim-lua/plenary.nvim' },
          { 'jay-babu/mason-null-ls.nvim', tag = 'v1.1.0' }
        },
        config = function()
          require('null-ls').setup {
            ensure_installed = {
              'buf', 'cue_fmt', 'cueimports', 'dart_format',
              'hclfmt', 'goimports', 'markdownlint', 'pg_format',
              'prettier', 'prettier_eslint', 'protolint', 'rego',
              'sqlfluff', 'terraform_fmt'
            }
          }
        end
      },
      {
        'onsails/lspkind-nvim',
        commit = 'c68b3a003483cf382428a43035079f78474cd11e',
        config = function()
          require('lspkind').init({
            symbol_map = {
              Text = '',
              Method = 'ƒ',
              Function = '',
              Constructor = '',
              Variable = '',
              Class = '',
              Interface = 'ﰮ',
              Module = '',
              Property = '',
              Unit = '',
              Value = '',
              Enum = '了',
              Keyword = '',
              Snippet = '﬌',
              Color = '',
              File = '',
              Folder = '',
              EnumMember = '',
              Constant = '',
              Struct = '',
              Copilot = ''
            }
          })
          vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
        end
      },
      {
        'ray-x/lsp_signature.nvim',
        commit = '6f6252f63b0baf0f2224c4caea33819a27f3f550'
      },
    },
    config = require('plugins.lspconfig'),
  },
  {
    'glepnir/lspsaga.nvim',
    commit = '44ae62d12b2cd498ed197cde159dfef5b2ea16b0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' }
    },
    init = function()
      vim.keymap.set('n', '<C-k>', '<cmd>Lspsaga hover_doc<CR>')
      vim.keymap.set('n', 'K', '<cmd>Lspsaga lsp_finder<CR>')
      vim.keymap.set('n', '<space>lf', '<cmd>Lspsaga lsp_finder<CR>')
      vim.keymap.set('n', '<space>lo', '<cmd>Lspsaga outline<CR>')
      vim.keymap.set('n', '<space>lp', '<cmd>Lspsaga peek_defenition<CR>')
    end,
    config = function()
      require('lspsaga').setup({
        lightbulb = {
          enable = false,
        },
        outline = {
          win_position = 'right',
          win_with = '',
          win_width = 50,
          show_detail = true,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          keys = {
            jump = '<CR>',
            expand_collapse = 'u',
            quit = 'q',
          },
        },
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    commit = '688b4fec4517650e29c3e63cfbb6e498b3112ba1',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = true,
  },
  {
    'someone-stole-my-name/yaml-companion.nvim',
    tag = '0.1.3',
    lazy = true,
    ft = { 'yaml', 'json' },
    dependencies = {
      { 'b0o/schemastore.nvim',         commit = '6f2ffb8420422db9a6c43dbce7227f0fdb9fcf75' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require('telescope').load_extension('yaml_schema')
    end
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    commit = '777450fd0ae289463a14481673e26246b5e38bf2',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp',                commit = '0e6b2ed705ddcff9738ec4ea838141654f12eeef' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1' },
      { 'hrsh7th/cmp-buffer',                  commit = '3022dbc9166796b644a841a02de8dd1cc1d311fa' },
      { 'hrsh7th/cmp-path',                    commit = '91ff86cd9c29299a64f968ebb45846c485725f23' },
      { 'hrsh7th/cmp-cmdline',                 commit = '8fcc934a52af96120fe26358985c10c035984b53' },
      { 'hrsh7th/cmp-emoji',                   commit = '19075c36d5820253d32e2478b6aaf3734aeaafa0' },
      { 'hrsh7th/cmp-vsnip',                   commit = '989a8a73c44e926199bfd05fa7a516d51f2d2752' },
      { 'hrsh7th/vim-vsnip',                   commit = '8dde8c0ef10bb1afdbb301e2bd7eb1c153dd558e' },
      { 'lukas-reineke/cmp-under-comparator',  commit = '6857f10272c3cfe930cece2afa2406e1385bfef8' },
    },
    config = require('plugins.nvim-cmp'),
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    lazy = true,
    cmd = { 'Telescope' },
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    init = function()
      vim.keymap.set('n', '<space>l', '<Cmd>Telescope find_files<CR>')
      vim.keymap.set('n', '<space>j', '<Cmd>Telescope oldfiles<CR>')
      vim.keymap.set('n', 'Q',
        function()
          return string.format('<cmd>Telescope live_grep default_text=%s<CR>', vim.fn.expand('<cword>'))
        end,
        { noremap = true, silent = true, expr = true })
      vim.keymap.set('n', '<space>g', '<Cmd>Telescope git_status<CR>')
    end,
    config = require('plugins.telescope'),
  },
  {
    'debugloop/telescope-undo.nvim',
    commit       = '03ff45fab0c4adad4d252e25b5b194e22caf5b4f',
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function() require('telescope').load_extension('undo') end,
  },
  {
    'LinArcX/telescope-command-palette.nvim',
    commit       = 'f7024ea025ed7985d8881d1b535004a1200903f3',
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function() require('telescope').load_extension('command_palette') end,
  },
  {
    'cljoly/telescope-repo.nvim',
    commit       = '50b5fc6eba11b5f1fcb249d5f7490551f86d1a00',
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function() require('telescope').load_extension('repo') end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    commit       = '580b6c48651cabb63455e97d7e131ed557b8c7e2',
    lazy         = true,
    build        = 'make',
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function() require('telescope').load_extension('fzf') end,
  },
  {
    'nvim-telescope/telescope-ghq.nvim',
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function() require('telescope').load_extension('ghq') end,
  },
  {
    'ahmedkhalf/project.nvim',
    commit = '1c2e9c93c7c85126c2197f5e770054f53b1926fb',
    lazy = true,
    -- ~~'VimEnter' is mainly for alpha (to use it in a menu)~~
    event = { --[[ 'VimEnter', ]] 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern', 'lsp' },
        patterns = { '.git' },
      }
      require('telescope').load_extension('projects')
    end
  },

  -- Apperance
  {
    'b4b4r07/cursor-x.nvim',
    commit = 'f99d429663a5c3cd50fdcdf8d65192ac2eaa7b7a',
    lazy = true,
    event = { 'BufRead' },
    config = function()
      require('cursor-x').setup({
        interval = 3000,
        always_cursorline = vim.opt.cursorline:get(),
        filetype_exclude = {
          'NeogitStatus',
          'alpha',
          'mason',
          'neo-tree',
        },
      })
      vim.api.nvim_create_user_command('CursorOn',
        function()
          require('cursor-x').enable()
        end, {})
      vim.api.nvim_create_user_command('CursorOff',
        function()
          require('cursor-x').disable()
        end, {})
    end,
  },
  {
    'RRethy/vim-illuminate',
    commit = '49062ab1dd8fec91833a69f0a1344223dd59d643',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('illuminate').configure {
        providers = { 'lsp', 'treesitter', 'regex' },
        filetypes_denylist = { 'dirvish', 'fugitive', 'alpha' },
      }
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    commit = 'e99d733e0213ceb8f548ae6551b04ae32e590c80',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
          globalstatus = true,
        },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      }
      require('lualine').refresh({
        scope = 'all',                                 -- scope of refresh all/tabpage/window
        place = { 'statusline', 'winbar', 'tabline' }, -- lualine segment ro refresh.
      })
    end
  },
  {
    'folke/todo-comments.nvim',
    tag = 'v1.0.0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
  {
    'ntpeters/vim-better-whitespace',
    commit = '1b22dc57a2751c7afbc6025a7da39b7c22db635d',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    tag = 'v2.20.4',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
        show_current_context_start = true,
        char = '┊',
        -- filetype = {'yaml'},
        buftype_exclude = { 'terminal', 'nofile', 'NvimTree', 'Neotree' },
        filetype_exclude = { 'help', 'NvimTree', 'Neotree', 'vaffle' },
      }
    end
  },

  -- Widget
  {
    'romgrk/barbar.nvim',
    commit = '4573b19e9ac29a58409a9445bf93753fb5a3e0e4',
    lazy   = true,
    event  = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'dstein64/nvim-scrollview',
    tag = 'v3.0.3',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'neo-tree' },
        current_only = true,
      })
    end,
  },
  {
    'utilyre/barbecue.nvim',
    tag          = 'v0.4.1',
    dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config       = function()
      require('barbecue').setup({ theme = 'tokyonight' })
    end
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    commit = '74040b34278910d9b467fd914862e2a9a1ebacaa',
    lazy = true,
    cmd = {
      'Neotree',
      'NeoTreeFocus', 'NeoTreeFocusToggle', 'NeoTreeFloat',
      'NeoTreeFloatToggle', 'NeoTreeShow', 'NeoTreeShowToggle',
      'NeoTreeShowInSplit', 'NeoTreeShowInSplitToggle', 'NeoTreeReveal',
      'NeoTreeRevealToggle', 'NeoTreeRevealInSplit',
      'NeoTreeRevealInSplitToggle'
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    init = function()
      vim.keymap.set('n', '<space>k',
        function()
          -- return parent dir but git root if inside git project
          local dir = vim.fn.fnameescape(vim.fn.fnamemodify(
            vim.fn.finddir('.git', vim.fn.escape(vim.fn.expand('%:p:h'), ' ') .. ';'), ':h'))
          return string.format(':<C-u>Neotree focus toggle left dir=%s<CR>', dir)
        end,
        { noremap = true, silent = true, expr = true })
    end,
    config = require('plugins.neo-tree'),
  },
  {
    'famiu/bufdelete.nvim',
    commit = '8933abc09df6c381d47dc271b1ee5d266541448e',
    lazy = true,
    cmd = { 'Bdelete' },
    config = function()
      vim.keymap.set('n', 'q', ':<C-u>Bdelete<CR>')
    end,
  },
  {
    'voldikss/vim-floaterm',
    commit = 'ca44a13a379d9af75092bc2fe2efee8c5248e876',
    lazy = true,
    cmd = { 'FloatermToggle', 'FloatermNew' },
    config = function()
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.9
    end,
  },
  {
    'mrjones2014/legendary.nvim',
    tag = 'v2.7.1',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      {
        'stevearc/dressing.nvim',
        commit = '5f44f829481640be0f96759c965ae22a3bcaf7ce',
        lazy = true,
        event = 'VeryLazy'
      }
    },
    config = require('plugins.legendary'),
  },
  {
    'folke/which-key.nvim',
    tag = 'v1.1.1',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {
        registers = false,
      }
    end,
  },

  -- Enhanced motions
  {
    'bkad/CamelCaseMotion',
    commit = 'de439d7c06cffd0839a29045a103fe4b44b15cdc',
    lazy = true,
    -- event = { 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' },
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'mg979/vim-visual-multi',
    commit = '724bd53adfbaf32e129b001658b45d4c5c29ca1a',
    lazy = true,
    -- event = { 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' },
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'terryma/vim-expand-region',
    commit = '966513543de0ddc2d673b5528a056269e7917276',
    lazy = true,
    -- event = { 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' },
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },

  -- Editing
  {
    'farmergreg/vim-lastplace', -- https://github.com/neovim/neovim/issues/16339
    commit = 'cef9d62165cd26c3c2b881528a5290a84347059e',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'kylechui/nvim-surround',
    tag = 'v2.0.0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('nvim-surround').setup({})
    end,
  },
  {
    'monaqa/dial.nvim',
    commit = '5020da900cc5dfd7067f181ee2ebd872ca7c84e8',
    lazy   = true,
    event  = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      local augend = require('dial.augend')
      local opts = { noremap = true, silent = true }
      require('dial.config').augends:register_group({
        default = {
          augend.case.new({
            types = { 'camelCase', 'snake_case', 'kebab-case', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'and', 'or' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { '&&', '||' },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'True', 'False' },
            word = true,
            cyclic = true,
          }),
          augend.constant.alias.bool,
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%Y-%m-%d'],
          augend.hexcolor.new({ case = 'lower' }),
          augend.integer.alias.decimal_int,
          augend.semver.alias.semver,
        },
      })
      vim.keymap.set('n', '<C-a>', require('dial.map').inc_normal(), opts)
      vim.keymap.set('n', '<C-x>', require('dial.map').dec_normal(), opts)
      vim.keymap.set('v', '<C-a>', require('dial.map').inc_visual(), opts)
      vim.keymap.set('v', '<C-x>', require('dial.map').dec_visual(), opts)
      vim.keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual(), opts)
      vim.keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual(), opts)
    end,
  },
  {
    'Wansmer/treesj',
    commit = '90248883bdb2d559ff4ba7f0148eb0145d3f0908',
    lazy = true,
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = 'hold',
        notify = true,
        -- langs = [],
        dot_repeat = true,
      })
    end,
  },
  {
    'EtiamNullam/deferred-clipboard.nvim',
    tag = 'v0.7.0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('deferred-clipboard').setup {
        fallback = 'unnamedplus' -- or your preferred setting for clipboard
      }
    end,
  },
  {
    'haya14busa/vim-edgemotion',
    commit = '8d16bd92f6203dfe44157d43be7880f34fd5c060',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'junegunn/vim-easy-align',
    commit = '12dd6316974f71ce333e360c0260b4e1f81169c3',
    lazy = true,
    cmd = { 'EasyAlign' },
  },
  {
    'numToStr/Comment.nvim',
    tag    = 'v0.7.0',
    lazy   = true,
    event  = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('Comment').setup({
        vim.keymap.set('v', 'K', 'gc', { silent = true, remap = true })
      })
    end
  },
  {
    'danymat/neogen',
    tag          = '2.13.1',
    lazy         = true,
    event        = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config       = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'windwp/nvim-autopairs',
    commit = '6a5faeabdbcc86cfbf1561ae430a451a72126e81',
    lazy = true,
    event = { 'InsertEnter' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt', 'vim' }
      })
    end,
  },

  -- Search
  {
    'markonm/traces.vim',
    commit = '9663fcf84de5776bee71b6c816c25ccb6ea11d1a',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'haya14busa/vim-asterisk',
    commit = '77e97061d6691637a034258cc415d98670698459',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'rhysd/clever-f.vim',
    commit = '6a3ac5e3688598af9411ab741737f98c47370c22',
    lazy = true,
    keys = { 'f', 'F', 't', 'T' }
  },
  {
    'unblevable/quick-scope',
    tag = 'v2.5.16',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'windwp/nvim-spectre',
    commit = 'b71b64afe9fedbfdd25a8abec897ff4af3bd553a',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'kevinhwang91/nvim-hlslens',
    tag = 'v1.0.0',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('hlslens').setup({
        calm_down = true,
      })
    end,
  },
  {
    'phaazon/hop.nvim',
    tag = 'v2.0.3',
    lazy = true,
    cmd = {
      'HopWord', 'HopChar1', 'HopChar2', 'HopPattern', 'HopLine',
      'HopLineStart', 'HopAnywhere',
    },
    config = function()
      require 'hop'.setup { keys = 'jkhlfdgsieurowyta;qpmv,c' }
    end,
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    commit = 'f388995990aba04cfdc7c3ab870c33e280601109',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { hl = 'GitSignsAdd', text = ' ', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change       = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = {
            hl = 'GitSignsChangeDelete',
            text = '▎',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
          },
        },
        numhl = true,
        linehl = false,
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil,
      }
    end
  },
  {
    'ruanyl/vim-gh-line',
    commit = 'fbf368bdfad7e5478009a6dc62559e6b2c72d603',
    lazy = true,
    cmd = { 'GH', 'GHInteractive' }
  },
  {
    'segeljakt/vim-silicon',
    commit = '4a93122ae2139a12e2a56f064d086c05160b6835',
    lazy = true,
    cmd = { 'Silicon' },
  },
  {
    'TimUntersberger/neogit',
    commit = '039ff3212ec43cc4d3332956dfb54e263c8d5033',
    dependencies = { 'sindrets/diffview.nvim' },
    lazy = true,
    cmd = { 'Neogit' },
    config = function()
      require('neogit').setup({
        kind                          = 'floating',
        commit_popup                  = { kind = 'floating' },
        preview_buffer                = { kind = 'floating' },
        popup                         = { kind = 'floating' },
        integrations                  = {
          diffview = false -- for now
        },
        disable_commit_confirmation   = true,
        disable_builtin_notifications = true,
        sections                      = {
          untracked = { folded = false },
          unstaged  = { folded = false },
          staged    = { folded = false },
          stashes   = { folded = false },
          unpulled  = { folded = false },
          unmerged  = { folded = true },
          recent    = { folded = true },
        },
        mappings                      = {
          status = {
            ['l'] = 'Toggle',
            ['a'] = 'Stage',
          },
        },
      })
    end,
  },

  -- Language specific tools
  {
    'ray-x/go.nvim',
    commit = '933ff9f0d84975122ec62ef98f78511db5c313c1',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = true,
    event = { --[[ 'CmdlineEnter', ]] 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = { 'go', 'gomod' },
    config = function()
      require('go').setup()
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = { '*.go' },
        callback = function()
          require('go.format').goimport()
        end,
      })
    end,
    build = [[:lua require('go.install').update_all_sync()]]
  },
  {
    'ekickx/clipboard-image.nvim',
    commit = 'd1550dc26729b7954f95269952e90471b838fa25',
    lazy = true,
    cmd = { 'PasteImg' },
    ft = { 'markdown' },
  },
  {
    'mzlogin/vim-markdown-toc',
    commit = '7ec05df27b4922830ace2246de36ac7e53bea1db',
    lazy = true,
    cmd = {
      'GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'GenTocMarked',
      'UpdateToc', 'RemoveToc',
    },
    ft = { 'markdown' },
  },
  {
    'google/vim-jsonnet',
    commit = '4ebc6619ddce5d032a985b42a9864154c3d20e4a',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = { 'jsonnet' },
  },
  {
    'hashivim/vim-terraform',
    commit = 'd00503de9bed3a1da7206090cb148c6a1acce870',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = { 'terraform', 'hcl' },
  },
  {
    'juliosueiras/vim-terraform-completion',
    commit = '125d0e892f5fd8f32b57a5a5983d03f1aa611949',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = { 'terraform', 'hcl' }
  },
  {
    'rhysd/vim-fixjson',
    commit = '705cd5d73e55a2ff4d39fca354d502a03cd11ed7',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    ft = 'json',
  },

  -- Color
  {
    'caglartoklu/ftcolor.vim',
    lazy = true,
    event = { 'ColorSchemePre' },
    commit = '28a8cf87e6a8b51cfd5fe526d18fd8cc13535158',
    config = function()
      vim.g.ftcolor_plugin_enabled = false
      vim.g.ftcolor_default_color_scheme = 'tokyonight'
      vim.g.ftcolor_custom_command = [[lua require('lualine').refresh()]]
      vim.g.ftcolor_color_mappings = {
        lua       = 'tokyonight',
        vim       = 'leaf',
        go        = 'seoul256',
        sh        = 'material', -- 'palenight'
        bash      = 'github_dark',
        zsh       = 'github_dark',
        hcl       = 'nord',
        json      = 'kanagawa',
        yaml      = 'tokyonight',
        -- terraform = 'nordfox',
        terraform = 'nord',
      }
    end,
  },
  {
    'folke/tokyonight.nvim',
    tag = 'v1.3.0',
    config = function()
      require 'tokyonight'.setup {
        on_highlights = function(highlights, colors)
          highlights['@keyword'].style.italic = false
          highlights['Comment'].style.italic = true
          highlights['DashboardFooter'].italic = false
        end
      }
    end
  },
  {
    'EdenEast/nightfox.nvim',
    tag = 'v3.3.0',
    config = function()
      require('nightfox').setup({
        options = {
          styles = {
            comments = 'italic',
            keywords = 'bold',
            types = 'italic,bold',
          }
        },
      })
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    commit = 'd8800c36a7f3bcec953288926b00381c028ed97f',
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        terminalColors = true,
        theme = 'wave',
        background = { dark = 'wave', light = 'lotus' },
      })
    end,
  },
  {
    'marko-cerovac/material.nvim',
    commit = '18d5e8af4c4bc77382bda5e5ae2830ab515cf5c6',
    init = function()
      -- 'darker', 'lighter', 'oceanic', 'palenight', 'deep ocean'
      vim.g.material_style = 'palenight'
    end,
    config = function()
      require('material').setup({
        contrast = {
          terminal = false,            -- Enable contrast for the built-in terminal
          sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
          floating_windows = false,    -- Enable contrast for floating windows
          cursor_line = false,         -- Enable darker background for the cursor line
          non_current_windows = false, -- Enable darker background for non-current windows
          filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
        },
        styles = {
          comments = { --[[ italic = true ]] },
          strings = { --[[ bold = true ]] },
          keywords = { --[[ underline = true ]] },
          functions = { --[[ bold = true, undercurl = true ]] },
          variables = {},
          operators = {},
          types = {},
        },
        plugins = {
          'dashboard', 'gitsigns', 'indent-blankline', 'lspsaga', 'nvim-cmp',
          'nvim-navic', 'nvim-tree', 'nvim-web-devicons', 'telescope', 'which-key',
        },
      })
    end,
  },
  {
    'gbprod/nord.nvim',
    commit = 'bd32c0f4d61c4a49a5ea8c2829f370a52fe1bcdd',
    config = function()
      require('nord').setup({
        transparent = false,      -- Enable this to disable setting the background color
        terminal_colors = true,   -- Configure the colors used when opening a `:terminal` in Neovim
        diff = { mode = 'bg' },   -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
        borders = true,           -- Enable the border between verticaly split windows visible
        errors = { mode = 'bg' }, -- Display mode for errors and diagnostics
        styles = {
          comments = { italic = true },
          keywords = {},
          functions = {},
          variables = {},
        },
      })
    end,
  },
  -- alternative nord themes
  -- { 'nordtheme/vim' },
  -- { 'shaunsingh/nord.nvim' },
  { 'daschw/leaf.nvim',                tag = 'v0.3.1' },
  { 'projekt0n/github-nvim-theme',     tag = 'v0.0.7' },
  { 'olivercederborg/poimandres.nvim', tag = 'v0.5.0' },
  { 'cocopon/iceberg.vim',             commit = 'e01ac08c2202e7544531f4d806f6893539da6471' },
  { 'voidekh/kyotonight.vim',          commit = 'aa2c77aec65393f7d3993b8dbd935dfd53ebc4ec' },
  { 'junegunn/seoul256.vim',           commit = '8f81a2f9f7ced9f8edea7f8a06caf5eaa9d9a217' },
  { 'AlessandroYorba/Despacio',        commit = 'd214f8424a97ca35f8c74fbd7e8968326585165c' },
  -- morhetz/gruvbox for neovim
  { 'ellisonleao/gruvbox.nvim',        commit = '488acf89979463d3ab77f8a5d35a11a2c809ac19' },
  { 'maxmx03/solarized.nvim',          commit = '7965990c323089a5afd027adc30435c72db67b58' },
}, opt)

-- directly set the colorscheme until ftcolor become stable
vim.cmd [[silent! colorscheme tokyonight]]
