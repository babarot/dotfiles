local opt = {
  root = vim.fn.stdpath("data") .. "/lazy",                 -- directory where plugins will be installed
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
  git = {
    log = { "--since=3 days ago" },
    timeout = 120,
    url_format = "https://github.com/%s.git",
    filter = true,
  },
  dev = {
    path = vim.fn.stdpath("config") .. "/lua",
    fallback = false,
  },
  install = {
    missing = true,
    colorscheme = { "seoul256" },
  },
}

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    commit = '356c9db3478b1bc6d0f0eefcb397989e50fdc35f',
    lazy = true,
    event = { 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' },
    build = [[vim.api.nvim_command("TSUpdate")]],
    dependencies = {
      {
        'yioneko/nvim-yati',
        commit = '8240f369d47c389ac898f87613e0901f126b40f3'
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
        yati = { enable = true },
        auto_install = true,
        ensure_installed = {
          'bash', 'dart', 'gitignore', 'go', 'gosum', 'gomod', 'hcl',
          'lua', 'javascript', 'json', 'jsonnet', 'make', 'markdown',
          'proto', 'python', 'rego', 'sql', 'terraform', 'typescript',
          'yaml',
        }
      }
    end
  },
  { 'junegunn/fzf' },
  { 'junegunn/fzf.vim' },
  {
    'ibhagwan/fzf-lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.keymap.set('n', '<space>g', function() require('fzf-lua').git_status() end)
    end,
    config = function()
      local fzf_lua = require('fzf-lua')
      require('fzf-lua').setup {
        git = {
          status = {
            cmd         = "git status -s",
            file_icons  = true,
            git_icons   = true,
            color_icons = true,
            previewer   = "git_diff",
            actions     = {
                  ["right"] = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
                  ["left"] = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
                  ["ctrl-l"] = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
                  ["ctrl-h"] = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
            },
          },
        },
      }
    end
  },
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({})
    end,
  },

  -- Development
  {
    'folke/neodev.nvim',
    tag = 'v2.4.0',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    ft = { 'lua' }
  },
  {
    'dstein64/vim-startuptime',
    tag = 'v4.3.0',
    lazy = true,
    cmd = { 'StartupTime' }
  },
  { 'nvim-lua/plenary.nvim',       tag = 'v0.1.3' },
  { 'nvim-lua/popup.nvim',         commit = 'b7404d35d5d3548a82149238289fa71f7f6de4ac' },
  { 'MunifTanjim/nui.nvim',        commit = 'd147222a1300901656f3ebd5b95f91732785a329' },
  { 'nvim-tree/nvim-web-devicons', commit = '4709a504d2cd2680fb511675e64ef2790d491d36' },
  { 'cocopon/vaffle.vim',          dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Project
  -- {
  --   'glepnir/dashboard-nvim',
  --   commit = '398ba8d9390c13c87a964cbca756319531fffdb7',
  --   lazy = true,
  --   event = { 'VimEnter' },
  --   config = true,
  --   dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  -- },
  {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    lazy = true,
    event = { 'VimEnter' },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end
  },
  {
    -- Use commit instead of tag to use lua_ls.
    'neovim/nvim-lspconfig',
    commit = '62856b20751b748841b0f3ec5a10b1e2f6a6dbc9',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require 'plugins.lspconfig',
    dependencies = {
      {
        'ray-x/lsp_signature.nvim',
        commit = "6f6252f63b0baf0f2224c4caea33819a27f3f550"
      },
      {
        'williamboman/mason-lspconfig.nvim',
        commit = "93e58e100f37ef4fb0f897deeed20599dae9d128",
        config = true,
        -- This is slow on startup.
        --[[ config = function()
        require 'mason-lspconfig'.setup {
        automatic_installation = true,
        ensure_installed = {
        'bashls',
        'dagger',
        'dockerls',
        'docker_compose_language_service',
        'golangci_lint_ls',
        'gopls',
        'graphql',
        'jsonls',
        'jsonnet_ls',
        'tsserver',
        'lua_ls',
        'pyright',
        'zk',
        'sqlls',
        'terraformls',
        'tflint',
        'yamlls',
        },
        }
        end ]]
      },
      {
        'williamboman/mason.nvim',
        commit = "01dfdfd36be77cb1195b60d580315bf4e2d8e62c",
        config = true,
      },
      {
        'jose-elias-alvarez/null-ls.nvim',
        commit = '689cdd78f70af20a37b5309ebc287ac645ae4f76',
        dependencies = {
          { "nvim-lua/plenary.nvim" },
          { "jay-babu/mason-null-ls.nvim", tag = 'v1.1.0' }
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
        commit = "c68b3a003483cf382428a43035079f78474cd11e",
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
              Copilot = ""
            }
          })
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        end
      }
    }
  },
  {
    'glepnir/lspsaga.nvim',
    event = { 'BufRead' },
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
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    commit = "688b4fec4517650e29c3e63cfbb6e498b3112ba1",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = true,
  },
  {
    'someone-stole-my-name/yaml-companion.nvim',
    tag = '0.1.3',
    lazy = true,
    ft = { "yaml", "json" },
    dependencies = {
      { 'b0o/schemastore.nvim',         commit = '6f2ffb8420422db9a6c43dbce7227f0fdb9fcf75' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    commit = "7a3b1e76f74934b12fda82158237c6ad8bfd3d40",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    config = require('plugins.nvim-cmp'),
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp',                commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef" },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = "3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1" },
      { 'hrsh7th/cmp-buffer',                  commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" },
      { 'hrsh7th/cmp-path',                    commit = "91ff86cd9c29299a64f968ebb45846c485725f23" },
      { 'hrsh7th/cmp-cmdline',                 commit = "8fcc934a52af96120fe26358985c10c035984b53" },
      { 'hrsh7th/cmp-emoji',                   commit = "19075c36d5820253d32e2478b6aaf3734aeaafa0" },
      { 'hrsh7th/cmp-vsnip',                   commit = "989a8a73c44e926199bfd05fa7a516d51f2d2752" },
      { 'hrsh7th/vim-vsnip',                   commit = "8dde8c0ef10bb1afdbb301e2bd7eb1c153dd558e" },
      { 'lukas-reineke/cmp-under-comparator',  commit = '6857f10272c3cfe930cece2afa2406e1385bfef8' },
    }
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    lazy = true,
    cmd = { 'Telescope' },
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    init = function()
      vim.keymap.set('n', '<space>j', '<Cmd>Telescope oldfiles<CR>')
      -- vim.keymap.set('n', '<space>f', function() require('fzf-lua').files({ cwd="%:p:h" }) end)
    end,
    config = function()
      local actions = require('telescope.actions')
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          initial_mode = 'normal',
          layout_strategy = 'horizontal',
          layout_config = { horizontal = { width = 0.8 } },
          mappings = {
            i = { ["<esc>"] = actions.close,["<C-u>"] = false },
            n = { ["q"] = actions.close,["<C-u>"] = false },
          }
        },
        extensions = {
          repo = {
            list = {
              fd_opts = { "--no-ignore-vcs" },
              search_dirs = { "~/src" }
            }
          }
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end
          },
        },
      }
    end
  },
  {
    'cljoly/telescope-repo.nvim',
    commit = "50b5fc6eba11b5f1fcb249d5f7490551f86d1a00",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() require('telescope').load_extension('repo') end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    commit = "580b6c48651cabb63455e97d7e131ed557b8c7e2",
    lazy = true,
    build = 'make',
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() require('telescope').load_extension('fzf') end,
  },
  {
    'nvim-telescope/telescope-ghq.nvim',
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() require('telescope').load_extension('ghq') end,
  },
  -- {
  --   'nvim-telescope/telescope-frecency.nvim',
  --   commit = 'e5696afabd8753d772987ea48434d9c0d8b0aa6b',
  --   lazy = true,
  --   dependencies = {'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua'},
  --   config = function() require"telescope".load_extension("frecency") end
  -- },
  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   commit = "6eb6bb45b7a9bed94a464a3e1dadfe870459628c",
  --   lazy = true,
  --   event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
  --   dependencies = {'nvim-telescope/telescope.nvim'},
  --   config = function()
  --     require("telescope").load_extension "file_browser"
  --   end
  -- },

  -- Apperance
  -- {
  --   'haringsrob/nvim_context_vt',
  --   commit = 'e592a9142fbfe0878ce886cd0d745963604c61d2',
  --   lazy = true,
  --   event = "VeryLazy"
  -- },
  {
    'RRethy/vim-illuminate',
    commit = '49062ab1dd8fec91833a69f0a1344223dd59d643',
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    config = function()
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
      }
    end
  },
  -- {
  --   "rebelot/heirline.nvim",
  --   lazy = true,
  --   event = "UiEnter",
  --   config = function()
  --     require("heirline").setup({})
  --   end
  -- },
  {
    'nvim-lualine/lualine.nvim',
    commit = "e99d733e0213ceb8f548ae6551b04ae32e590c80",
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
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
  {
    'ntpeters/vim-better-whitespace',
    commit = "1b22dc57a2751c7afbc6025a7da39b7c22db635d",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" }
  },
  -- {
  --   'mvllow/modes.nvim',
  --   tag = 'v0.2.1',
  --   lazy = true,
  --   event = {"InsertEnter"},
  --   config = function()
  --     require('modes').setup({
  --       -- colors = {
  --       --   copy = "#f5c359",
  --       --   delete = "#c75c6a",
  --       --   insert = "#78ccc5",
  --         -- visual = "#9745be",
  --       -- },
  --     })
  --   end
  -- },
  { 'bfontaine/Brewfile.vim' },
  {
    'lukas-reineke/indent-blankline.nvim',
    tag = 'v2.20.4',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
        char = "┊",
        -- filetype = {'yaml'},
        buftype_exclude = { 'terminal', 'nofile', 'NvimTree', 'Neotree' },
        filetype_exclude = { 'help', 'NvimTree', 'Neotree', 'vaffle' },
      }
    end
  },

  -- Widget
  {
    'romgrk/barbar.nvim',
    commit = '4573b19e9ac29a58409a9445bf93753fb5a3e0e4'
  },
  {
    'dstein64/nvim-scrollview',
    tag = 'v3.0.3',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  },
  -- {
  --   'utilyre/barbecue.nvim',
  --   tag = 'v0.4.1',
  --   dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require('barbecue').setup({ theme = 'tokyonight' })
  --   end
  -- },
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
          return string.format(':<C-u>Neotree focus toggle dir=%s<CR>', dir)
        end,
        { noremap = true, silent = true, expr = true })
    end,
    config = function()
      local function gomi(state)
        local inputs = require "neo-tree.ui.inputs"
        local path = state.tree:get_node().path
        local msg = string.format("Are you sure you want to delete as gomi? '%s'", vim.fn.fnamemodify(path, ':t'))
        inputs.confirm(msg, function(confirmed)
          if not confirmed then return end
          vim.fn.system { "gomi", vim.fn.fnameescape(path) }
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end
      require('neo-tree').setup {
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
                ["<esc>"] = "revert_preview",
                ["<cr>"] = "open",
                ["l"] = "open",
                ["h"] = "close_node",
                ["z"] = "close_all_nodes",
                ["Z"] = "expand_all_nodes",
                ["a"] = "add",
                ["A"] = "add_directory",
                ["d"] = gomi,
                ["r"] = "rename",
                ["m"] = "move",
                ["p"] = { "toggle_preview", config = { use_float = true } },
                ["P"] = "focus_preview",
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gc"] = "git_commit",
          }
        },
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = {
              '.DS_Store',
              'thumbs.db',
            },
          },
        },
        buffers = {
          follow_current_file = true,
        },
        event_handlers = {
          -- automaticall close neotree after opened file
          {
            event = "file_opened",
            handler = function()
              require("neo-tree").close_all()
            end
          },
        },
      }
    end
  },
  {
    'famiu/bufdelete.nvim',
    commit = "8933abc09df6c381d47dc271b1ee5d266541448e",
    lazy = true,
    cmd = { 'Bdelete' },
    config = function()
      vim.keymap.set('n', 'q', ':<C-u>Bdelete<CR>')
    end
  },
  {
    'voldikss/vim-floaterm',
    commit = "ca44a13a379d9af75092bc2fe2efee8c5248e876",
    lazy = true,
    cmd = { 'FloatermToggle', 'FloatermNew' },
    config = function()
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.9
    end
  },
  {
    'mrjones2014/legendary.nvim',
    tag = 'v2.7.1',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require('plugins.legendary'),
    dependencies = {
      {
        "stevearc/dressing.nvim",
        commit = '5f44f829481640be0f96759c965ae22a3bcaf7ce',
        lazy = true,
        event = 'VeryLazy'
      }
    }
  },
  {
    'folke/which-key.nvim',
    tag = 'v1.1.1',
    lazy = true,
    event = { 'VeryLazy' },
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {
        registers = false,
      }
    end
  },

  -- Enhanced motions
  -- Lazy load by event is not recommended.
  {
    'bkad/CamelCaseMotion',
    commit = "de439d7c06cffd0839a29045a103fe4b44b15cdc",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }
  },
  {
    'mg979/vim-visual-multi',
    commit = '724bd53adfbaf32e129b001658b45d4c5c29ca1a',
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }
  },
  {
    'terryma/vim-expand-region',
    commit = '966513543de0ddc2d673b5528a056269e7917276',
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }
  },

  -- Editing
  {
    'EtiamNullam/deferred-clipboard.nvim',
    tag = "v0.7.0",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
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
    event = { 'VeryLazy' },
  },
  {
    'junegunn/vim-easy-align',
    commit = "12dd6316974f71ce333e360c0260b4e1f81169c3",
    lazy = true,
    cmd = { 'EasyAlign' },
  },
  {
    'numToStr/Comment.nvim',
    tag = 'v0.7.0',
    config = function()
      require('Comment').setup({
        vim.keymap.set("v", "K", "gc", { silent = true, remap = true })
      })
    end
  },
  {
    'danymat/neogen',
    tag = '2.13.1',
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    'windwp/nvim-autopairs',
    commit = "6a5faeabdbcc86cfbf1561ae430a451a72126e81",
    lazy = true,
    event = { "InsertEnter" },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" }
      })
    end,
  },

  -- Search
  {
    'markonm/traces.vim',
    commit = "9663fcf84de5776bee71b6c816c25ccb6ea11d1a",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
  },
  {
    'haya14busa/vim-asterisk',
    commit = "77e97061d6691637a034258cc415d98670698459",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
  },
  {
    'rhysd/clever-f.vim',
    commit = "6a3ac5e3688598af9411ab741737f98c47370c22",
    lazy = true,
    keys = { "f", "F", "t", "T" }
  },
  {
    'unblevable/quick-scope',
    tag = "v2.5.16",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
  },
  {
    'windwp/nvim-spectre',
    commit = "b71b64afe9fedbfdd25a8abec897ff4af3bd553a",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
  },
  {
    'kevinhwang91/nvim-hlslens',
    tag = "v1.0.0",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    config = function()
      require('hlslens').setup({
        calm_down = true,
      })
    end,
  },
  {
    'phaazon/hop.nvim',
    tag = "v2.0.3",
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
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("gitsigns").setup {
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
    commit = "fbf368bdfad7e5478009a6dc62559e6b2c72d603",
    lazy = true,
    cmd = { 'GH', 'GHInteractive' }
  },
  {
    'segeljakt/vim-silicon',
    commit = "4a93122ae2139a12e2a56f064d086c05160b6835",
    lazy = true,
    cmd = { 'Silicon' },
  },

  -- Language specific tools
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
  },
  {
    'ekickx/clipboard-image.nvim',
    commit = "d1550dc26729b7954f95269952e90471b838fa25",
    lazy = true,
    cmd = { 'PasteImg' },
    ft = { 'markdown' },
  },
  {
    'google/vim-jsonnet',
    commit = "4ebc6619ddce5d032a985b42a9864154c3d20e4a",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    ft = { 'jsonnet' },
  },
  {
    'hashivim/vim-terraform',
    commit = "d00503de9bed3a1da7206090cb148c6a1acce870",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    ft = { 'terraform', 'hcl' },
  },
  {
    'juliosueiras/vim-terraform-completion',
    commit = "125d0e892f5fd8f32b57a5a5983d03f1aa611949",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    ft = { 'terraform', 'hcl' }
  },

  -- Color
  {
    'caglartoklu/ftcolor.vim',
    config = function()
      -- vim.g.ftcolor_custom_command = [['colorscheme ' . vim.g.colors_name]]
      vim.g.ftcolor_plugin_enabled = true
      vim.g.ftcolor_default_color_scheme = 'tokyonight'
      vim.g.ftcolor_custom_command = [[lua require('lualine').refresh()]]
      vim.g.ftcolor_color_mappings = {
        lua       = 'tokyonight',
        vim       = 'leaf',
        go        = 'seoul256',
        sh        = 'material', -- 'palenight'
        bash      = 'github_dark',
        zsh       = 'github_dark',
        hcl       = 'kyotonight',
        json      = 'kanagawa',
        yaml      = 'kyotonight',
        terraform = 'nordfox',
      }
    end,
  },
  {
    'folke/tokyonight.nvim',
    tag = 'v1.3.0',
    config = function()
      require 'tokyonight'.setup {
        -- Disable italic because Windows Terminal does not support it.
        on_highlights = function(highlights, colors)
          highlights['@keyword'].style.italic = false
          highlights['Comment'].style.italic = false
          highlights['DashboardFooter'].italic = false
          highlights['Keyword'].style.italic = false
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
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          }
        },
        palettes = {
          nordfox = {
            -- bg1 = "#2e3440",
            -- sel0 = "#3e4a5b", -- Popup bg, visual selection bg
            -- sel1 = "#4f6074", -- Popup sel bg, search bg
            -- comment = "#60728a",
          },
        },
      })
    end,
  },
  {
    'rebelot/kanagawa.nvim',
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
        theme = "wave",
        background = { dark = "wave", light = "lotus" },
      })
    end,
  },
  {
    'marko-cerovac/material.nvim',
    init = function()
      -- darker, lighter, oceanic, palenight, deep ocean
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
          "dashboard", "gitsigns", "indent-blankline", "lspsaga", "nvim-cmp",
          "nvim-navic", "nvim-tree", "nvim-web-devicons", "telescope", "which-key",
        },
        disable = {
          colored_cursor = false, -- Disable the colored cursor
          borders = false,        -- Disable borders between verticaly split windows
          background = false,     -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
          term_colors = false,    -- Prevent the theme from setting terminal colors
          eob_lines = false       -- Hide the end-of-buffer lines
        },
        high_visibility = {
          lighter = false,         -- Enable higher contrast text for lighter style
          darker = false           -- Enable higher contrast text for darker style
        },
        lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
        async_loading = true,      -- Load parts of the theme asyncronously for faster startup (turned on by default)
        custom_colors = nil,       -- If you want to everride the default colors, set this to a function
        custom_highlights = {},    -- Overwrite highlights with your own
      })
    end,
  },
  { 'daschw/leaf.nvim',                tag = 'v0.3.1' },
  { 'projekt0n/github-nvim-theme',     tag = 'v0.0.7' },
  { 'olivercederborg/poimandres.nvim', tag = 'v0.5.0' },
  { 'norcalli/nvim-colorizer.lua',     commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6' },
  { 'cocopon/iceberg.vim',             commit = 'e01ac08c2202e7544531f4d806f6893539da6471' },
  { 'voidekh/kyotonight.vim' },
  { 'junegunn/seoul256.vim' },
  { 'AlessandroYorba/Despacio' },
  { 'ellisonleao/gruvbox.nvim' }, -- morhetz/gruvbox for neovim
  { 'maxmx03/solarized.nvim' },
  -- { 'nordtheme/vim' },
  -- {
  --   'gbprod/nord.nvim',
  --   config = function()
  --     require('nord').setup({
  --       transparent = false,      -- Enable this to disable setting the background color
  --       terminal_colors = true,   -- Configure the colors used when opening a `:terminal` in Neovim
  --       diff = { mode = "bg" },   -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
  --       borders = true,           -- Enable the border between verticaly split windows visible
  --       errors = { mode = "bg" }, -- Display mode for errors and diagnostics
  --       styles = {
  --         comments = { italic = true },
  --         keywords = {},
  --         functions = {},
  --         variables = {},
  --         -- To customize lualine/bufferline
  --         bufferline = {
  --           current = {},
  --           modified = { italic = true },
  --         },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   'shaunsingh/nord.nvim',
  --   config = function()
  --     vim.g.nord_contrast = true
  --     vim.g.nord_borders = true
  --     vim.g.nord_disable_background = false
  --     vim.g.nord_italic = false
  --     vim.g.nord_uniform_diff_background = true
  --     vim.g.nord_bold = false
  --   end,
  -- },
}, opt)
