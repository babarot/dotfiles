require('lazy').setup {
  { 'junegunn/fzf' }, -- {
  { 'junegunn/fzf.vim' },
  { 'ibhagwan/fzf-lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf_lua = require('fzf-lua')
      require('fzf-lua').setup {
      git = {
        status = {
          cmd           = "git status -s",
          file_icons    = true,
          git_icons     = true,
          color_icons   = true,
          previewer     = "git_diff",
          actions = {
            ["right"]   = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
            ["left"]    = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
            ["ctrl-l"]  = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
            ["ctrl-h"]  = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
          },
        },
      },
    }
      vim.keymap.set('n', '<space>g', function() require('fzf-lua').git_status() end)
      -- vim.keymap.set('n', '<space>f', function() require('fzf-lua').files({ cwd="%:p:h" }) end)
      -- vim.keymap.set('c', '<C-r>', function() require('fzf-lua').command_history() end)
    end
  },
  {
    -- Like 'numToStr/Comment.nvim'
    "terrortylor/nvim-comment",
    config = function()
      local opt = { silent = true, remap = true }
      vim.keymap.set("n", "K", "gcc", opt)
      vim.keymap.set("v", "K", "gc", opt)
    end
  },
  {
    'hashivim/vim-terraform',
    ft = {'hcl', 'terraform'},
  },
  {
    'caglartoklu/ftcolor.vim',
    config = function()
      vim.g.ftcolor_plugin_enabled = true
      vim.g.ftcolor_default_color_scheme = 'tokyonight'
      vim.g['ftcolor_color_mappings'] = {
        lua = 'tokyonight',
        vim = 'tokyonight',
        hcl = 'gruvbox',
        go = 'seoul256',
        yaml = 'seoul256',
        sh = 'despacio',
        bash = 'despacio',
        zsh = 'despacio',
      }
    end,
  },
  { 'cocopon/vaffle.vim', dependencies = {'nvim-tree/nvim-web-devicons'} },
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'bfontaine/Brewfile.vim',
    ft = {'brew'},
  },

  -- Development
  {
    "folke/neodev.nvim",
    tag = "v2.4.0",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    ft = {'lua'}
  }, {
    'dstein64/vim-startuptime',
    tag = "v4.3.0",
    lazy = true,
    cmd = {"StartupTime"}
  }, -- Basic
  {'nvim-lua/plenary.nvim', tag = "v0.1.3"},
  {'nvim-lua/popup.nvim', commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac"},
  {
    'MunifTanjim/nui.nvim',
    commit = "d147222a1300901656f3ebd5b95f91732785a329"
  },
  {
    'nvim-tree/nvim-web-devicons',
    commit = "4709a504d2cd2680fb511675e64ef2790d491d36"
  },

  -- Project
  {
    'glepnir/dashboard-nvim',
    commit = '398ba8d9390c13c87a964cbca756319531fffdb7',
    lazy = true,
    event = {'VimEnter'},
    config = [[require('dashboard').setup()]],
    dependencies = {{'nvim-tree/nvim-web-devicons'}}
  },
  {
    'nvim-treesitter/nvim-treesitter',
    commit = "9dd1b9c09707bf1cdd565b999c79ac6461602591",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    build = [[vim.api.nvim_command("TSUpdate")]],
    dependencies = {
      {
        "yioneko/nvim-yati",
        commit = "8240f369d47c389ac898f87613e0901f126b40f3"
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        yati = {enable = true},
        highlight = {enable = true},
        auto_install = true,
        ensure_installed = {
          'bash', 'dart', 'gitignore', 'go', 'gosum', 'gomod', 'hcl',
          'lua', 'javascript', 'json', 'jsonnet', 'make', 'markdown',
          'proto', 'python', 'rego', 'sql', 'terraform', 'typescript',
          'yaml'
        }
      }
    end
  },
  {
    -- Use commit instead of tag to use lua_ls.
    'neovim/nvim-lspconfig',
    commit = "62856b20751b748841b0f3ec5a10b1e2f6a6dbc9",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    config = require 'plugins.lspconfig',
    dependencies = {
      {
        'ray-x/lsp_signature.nvim',
        commit = "6f6252f63b0baf0f2224c4caea33819a27f3f550"
      }, {
        "williamboman/mason-lspconfig.nvim",
        commit = "93e58e100f37ef4fb0f897deeed20599dae9d128"
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
      }, {
        "williamboman/mason.nvim",
        commit = "01dfdfd36be77cb1195b60d580315bf4e2d8e62c",
        config = [[require'mason'.setup()]]
      }, {
        "jose-elias-alvarez/null-ls.nvim",
        commit = '689cdd78f70af20a37b5309ebc287ac645ae4f76',
        dependencies = {
          {"nvim-lua/plenary.nvim"},
          {"jay-babu/mason-null-ls.nvim", tag = 'v1.1.0'}
        },
        config = function()
          require("null-ls").setup {
            ensure_installed = {
              'buf', 'cue_fmt', 'cueimports', 'dart_format',
              'hclfmt', 'goimports', 'markdownlint', 'pg_format',
              'prettier', 'prettier_eslint', 'protolint', 'rego',
              'sqlfluff', 'terraform_fmt'
            }
          }
        end
      }, {
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
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot",
            {fg = "#6CC644"})
        end
      }
    }
  }, {
    'j-hui/fidget.nvim',
    commit = "688b4fec4517650e29c3e63cfbb6e498b3112ba1",
    lazy = true,
    config = [[require'fidget'.setup()]],
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }, {
    "someone-stole-my-name/yaml-companion.nvim",
    tag = '0.1.3',
    lazy = true,
    ft = {"yaml", "json"},
    dependencies = {
      {
        "b0o/schemastore.nvim",
        commit = "6f2ffb8420422db9a6c43dbce7227f0fdb9fcf75"
      }, {"nvim-lua/plenary.nvim"}, {"nvim-telescope/telescope.nvim"}
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end
  }, -- Completion
  {
    'hrsh7th/nvim-cmp',
    commit = "7a3b1e76f74934b12fda82158237c6ad8bfd3d40",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    config = require('plugins.nvim-cmp'),
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp',
        commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef"
      }, {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        commit = "3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1"
      },
      {
        'hrsh7th/cmp-buffer',
        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"
      },
      {
        'hrsh7th/cmp-path',
        commit = "91ff86cd9c29299a64f968ebb45846c485725f23"
      },
      {
        'hrsh7th/cmp-cmdline',
        commit = "8fcc934a52af96120fe26358985c10c035984b53"
      },
      {
        'hrsh7th/cmp-emoji',
        commit = "19075c36d5820253d32e2478b6aaf3734aeaafa0"
      },
      {
        'hrsh7th/cmp-vsnip',
        commit = "989a8a73c44e926199bfd05fa7a516d51f2d2752"
      },
      {
        'hrsh7th/vim-vsnip',
        commit = "8dde8c0ef10bb1afdbb301e2bd7eb1c153dd558e"
      }, {
        'lukas-reineke/cmp-under-comparator',
        commit = '6857f10272c3cfe930cece2afa2406e1385bfef8'
      }, {'golang/vscode-go', tag = "v0.37.1"}
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    lazy = true,
    commit = '92535dfd9c430b49ca7d9a7da336c5db65826b65',
    event = {"InsertEnter"},
    config = function() require("copilot_cmp").setup() end,
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        commit = 'b41d4c9c7d4f5e0272bcf94061b88e244904c56f',
        config = function()
          require("copilot").setup({
            suggestion = {enabled = false},
            panel = {enabled = false}
          })
        end
      }
    }
  }, -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = "0.1.1",
    lazy = true,
    cmd = {"Telescope"},
    dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function()
      local actions = require("telescope.actions")
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          initial_mode = 'normal',
          layout_strategy = 'horizontal',
          layout_config = {horizontal = {width = 0.8}},
          mappings = {
            i = {["<esc>"] = actions.close, ["<C-u>"] = false}
          }
        },
        extensions = {
          repo = {
            list = {
              fd_opts = {"--no-ignore-vcs"},
              search_dirs = {"~/src"}
            }
          }
        }
      }
      vim.keymap.set('n', '<space>j', '<Cmd>Telescope oldfiles<CR>')
      -- vim.keymap.set('n', '<space>f', function() require('fzf-lua').files({ cwd="%:p:h" }) end)
    end
  }, {
    'nvim-telescope/telescope-frecency.nvim',
    -- commit = 'e5696afabd8753d772987ea48434d9c0d8b0aa6b',
    -- lazy = true,
    dependencies = {'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua'},
    config = function() require"telescope".load_extension("frecency") end
  }, {
    'cljoly/telescope-repo.nvim',
    commit = "50b5fc6eba11b5f1fcb249d5f7490551f86d1a00",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function() require('telescope').load_extension('repo') end
  }, {
    'nvim-telescope/telescope-fzf-native.nvim',
    commit = "580b6c48651cabb63455e97d7e131ed557b8c7e2",
    lazy = true,
    build = 'make',
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function() require('telescope').load_extension('fzf') end
  }, {
    "nvim-telescope/telescope-file-browser.nvim",
    commit = "6eb6bb45b7a9bed94a464a3e1dadfe870459628c",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function()
      require("telescope").load_extension "file_browser"
    end
  }, -- Apperance
  {
    'haringsrob/nvim_context_vt',
    commit = 'e592a9142fbfe0878ce886cd0d745963604c61d2',
    lazy = true,
    event = "VeryLazy"
  }, {
    'nvim-lualine/lualine.nvim',
    commit = "e99d733e0213ceb8f548ae6551b04ae32e590c80",
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
      require('lualine').setup {
        options = {
          -- theme = 'tokyonight',
          -- theme = 'seoul256',
          theme = 'auto'
        }
      }
    end
  }, {
    "folke/todo-comments.nvim",
    tag = 'v1.0.0',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    dependencies = {{"nvim-lua/plenary.nvim"}},
    config = [[require("todo-comments").setup {}]]
  }, {
    'RRethy/vim-illuminate',
    commit = "49062ab1dd8fec91833a69f0a1344223dd59d643",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }, {
    'ntpeters/vim-better-whitespace',
    commit = "1b22dc57a2751c7afbc6025a7da39b7c22db635d",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }, {
    'myusuf3/numbers.vim',
    commit = "1867e76e819db182a4fb71f48f4bd36a5e2c6b6e",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
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
  {
    'lukas-reineke/indent-blankline.nvim',
    tag = "v2.20.4",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
        char = "┊",
        filetype = {'yaml'},
        buftype_exclude = {'terminal', 'nofile', 'NvimTree', 'Neotree'},
        filetype_exclude = {'help', 'NvimTree', 'Neotree'},
      }
    end
  }, -- Widget
  {'romgrk/barbar.nvim', commit = '4573b19e9ac29a58409a9445bf93753fb5a3e0e4'},
  {
    'dstein64/nvim-scrollview',
    tag = "v3.0.3",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }, {
    "SmiteshP/nvim-navic",
    commit = "7e9d2b2b601149fecdccd11b516acb721e571fe6",
    dependencies = "neovim/nvim-lspconfig"
  }, {
    "utilyre/barbecue.nvim",
    tag = "v0.4.1",
    dependencies = {"SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons"},
    config = function()
      require("barbecue").setup {theme = 'tokyonight'}
    end
  }, {
    "nvim-neo-tree/neo-tree.nvim",
    commit = '74040b34278910d9b467fd914862e2a9a1ebacaa',
    lazy = true,
    cmd = {
      'NeoTreeFocus', 'NeoTreeFocusToggle', 'NeoTreeFloat',
      'NeoTreeFloatToggle', 'NeoTreeShow', 'NeoTreeShowToggle',
      'NeoTreeShowInSplit', 'NeoTreeShowInSplitToggle', 'NeoTreeReveal',
      'NeoTreeRevealToggle', 'NeoTreeRevealInSplit',
      'NeoTreeRevealInSplitToggle'
    },
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    config = function()
      require('neo-tree').setup {
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
          filtered_items = {
            visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = {
              '.DS_Store',
              'thumbs.db',
            },
          }
        },
  neogit = function()
    vim.api.nvim_cmd({
      cmd = 'Neotree',
      args = {
        'source=git_status',
        'reveal=true',
        'position=float',
        'action=focus',
        'toggle=true',
      },
    }, {})
  end,
  cwd_changed = function()
    vim.api.nvim_cmd({
      cmd = 'Neotree',
      args = {
        'dir=' .. vim.fn.getcwd(),
      },
    }, {})
    vim.api.nvim_cmd({
      cmd = 'Neotree',
      args = {
        'close',
      },
    }, {})
  end,
      }
    end
  }, {
    'famiu/bufdelete.nvim',
    commit = "8933abc09df6c381d47dc271b1ee5d266541448e",
    lazy = true,
    cmd = {'Bdelete'}
  }, {
    'voldikss/vim-floaterm',
    commit = "ca44a13a379d9af75092bc2fe2efee8c5248e876",
    lazy = true,
    cmd = {'FloatermToggle', 'FloatermNew'},
    config = function()
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.9
    end
  }, {
    'mrjones2014/legendary.nvim',
    tag = 'v2.7.1',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    config = require('plugins.legendary'),
    dependencies = {
      {
        "stevearc/dressing.nvim",
        commit = '5f44f829481640be0f96759c965ae22a3bcaf7ce',
        lazy = true,
        event = "VeryLazy"
      }
    }
  }, {
    "folke/which-key.nvim",
    tag = 'v1.1.1',
    lazy = true,
    event = {"VeryLazy"},
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        registers = false,
      }
    end
  }, -- Enhanced motions
  -- Lazy load by event is not recommended.
  {
    'bkad/CamelCaseMotion',
    commit = "de439d7c06cffd0839a29045a103fe4b44b15cdc",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'mg979/vim-visual-multi',
    commit = '724bd53adfbaf32e129b001658b45d4c5c29ca1a',
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'terryma/vim-expand-region',
    commit = '966513543de0ddc2d673b5528a056269e7917276',
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, -- Editing
  {
    'EtiamNullam/deferred-clipboard.nvim',
    tag = "v0.7.0",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    config = function()
      require('deferred-clipboard').setup {
        fallback = 'unnamedplus' -- or your preferred setting for clipboard
      }
    end
  }, {
    'bennypowers/nvim-regexplainer',
    commit = '8af9a846644982ab1e11cc99b6e4831e12479207',
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'AndrewRadev/splitjoin.vim',
    tag = 'v1.1.0',
    lazy = true,
    -- Use "on Buf*" because "on Cursor*" does not work.
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }, {
    'gbprod/substitute.nvim',
    tag = 'v1.1.1',
    lazy = true,
    event = 'VeryLazy',
    config = [[require'substitute'.setup {}]]
  }, {
    'haya14busa/vim-edgemotion',
    commit = '8d16bd92f6203dfe44157d43be7880f34fd5c060',
    lazy = true,
    event = 'VeryLazy'
  }, {
    'junegunn/vim-easy-align',
    commit = "12dd6316974f71ce333e360c0260b4e1f81169c3",
    lazy = true,
    cmd = {'EasyAlign'}
  }, -- {
  --   'tpope/vim-surround',
  --   commit = "3d188ed2113431cf8dac77be61b842acb64433d9",
  --   lazy = true,
  --   event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
  -- },
  {
    'AndrewRadev/sideways.vim',
    commit = "e683ed0fc57eda718c6b28dce0ff5190089d13d3",
    lazy = true,
    cmd = {'SidewaysLeft', 'SidewaysRight'}
  },
  {
    'lfilho/cosco.vim',
    tag = "v0.10.0",
    lazy = true,
    cmd = {'CommaOrSemiColon'}
  }, {
    'numToStr/Comment.nvim',
    tag = "v0.7.0",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    config = [[require('Comment').setup()]]
  }, {
    "danymat/neogen",
    tag = "2.13.1",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    config = [[require('neogen').setup {}]],
    dependencies = {"nvim-treesitter/nvim-treesitter"}
  }, {
    'windwp/nvim-autopairs',
    commit = "6a5faeabdbcc86cfbf1561ae430a451a72126e81",
    lazy = true,
    event = {"InsertEnter"},
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = {"TelescopePrompt", "vim"}
      })
    end
  }, -- Search
  {
    'markonm/traces.vim',
    commit = "9663fcf84de5776bee71b6c816c25ccb6ea11d1a",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'haya14busa/vim-asterisk',
    commit = "77e97061d6691637a034258cc415d98670698459",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'rhysd/clever-f.vim',
    commit = "6a3ac5e3688598af9411ab741737f98c47370c22",
    lazy = true,
    keys = {"f", "F", "t", "T"}
  }, {
    'unblevable/quick-scope',
    tag = "v2.5.16",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'windwp/nvim-spectre',
    commit = "b71b64afe9fedbfdd25a8abec897ff4af3bd553a",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  },
  {
    'kevinhwang91/nvim-hlslens',
    tag = "v1.0.0",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    config = function() require('hlslens').setup() end,
  },
  {
    'phaazon/hop.nvim',
    tag = "v2.0.3",
    lazy = true,
    cmd = {
      'HopWord', 'HopChar1', 'HopChar2', 'HopPattern', 'HopLine',
      'HopLineStart', 'HopAnywhere'
        },
    config = function()
      require'hop'.setup {keys = 'jkhlfdgsieurowyta;qpmv,c'}
    end
  }, -- Git
  {
    'lewis6991/gitsigns.nvim',
    commit = 'f388995990aba04cfdc7c3ab870c33e280601109',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    dependencies = {'nvim-lua/plenary.nvim'},
    config = require('plugins.gitsigns')
  }, {
    'ruanyl/vim-gh-line',
    commit = "fbf368bdfad7e5478009a6dc62559e6b2c72d603",
    lazy = true,
    cmd = {'GH', 'GHInteractive'}
  }, {
    'mattn/vim-gist',
    commit = "5bfbb5450d9eff248f6c074de0b7800392439304",
    lazy = true,
    cmd = {'Gist'}
  }, {
    'f-person/git-blame.nvim',
    commit = "17840d01f42ee308e1dbbcc2cde991297aee36c9",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'akinsho/git-conflict.nvim',
    commit = "2957f747e1a34f1854e4e0efbfbfa59a1db04af5",
    lazy = true,
    config = [[require('git-conflict').setup()]],
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}
  }, {
    'pwntester/octo.nvim',
    commit = "f336322f865cfa310ae15435c6bec337687b6b20",
    lazy = true,
    cmd = {'Octo'},
    dependencies = {
      'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    config = [[require "octo".setup()]]
  }, -- General tools
  {
    'mattn/vim-sonictemplate',
    commit = "0e4d422c85decd8d159c663f234eb484b1b04b25",
    lazy = true,
    cmd = {'Template'}
  }, {
    'segeljakt/vim-silicon',
    commit = "4a93122ae2139a12e2a56f064d086c05160b6835",
    lazy = true,
    cmd = {'Silicon'},
  }, {
    'voldikss/vim-translator',
    commit = "681c6b2f650b699572e6bb55162a3d6e62ee5d43",
    lazy = true,
    cmd = {'Translate', 'TranslateW'},
  }, -- Language specific tools
  -- Go
  {
    'ray-x/go.nvim',
    commit = "4d066613379d85094bb4ddd52e34e6d3f55fc24e",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    ft = {"go"},
  }, {
    'ray-x/guihua.lua',
    commit = "a19ac4447021f21383fadd7a9e1fc150d0b67e1f",
    lazy = true,
    event = {"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"},
    ft = {"go"},
  }, -- Markdown
  {
    'ekickx/clipboard-image.nvim',
    commit = "d1550dc26729b7954f95269952e90471b838fa25",
    lazy = true,
    cmd = {'PasteImg'},
    ft = {'markdown'},
  }, -- Others
  {
    'jsborjesson/vim-uppercase-sql',
    commit = "58bfde1d679a1387dabfe292b38d51d84819b267",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    ft = {'sql'},
  }, {
    'google/vim-jsonnet',
    commit = "4ebc6619ddce5d032a985b42a9864154c3d20e4a",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    ft = {'jsonnet'},
  }, {
    'hashivim/vim-terraform',
    commit = "d00503de9bed3a1da7206090cb148c6a1acce870",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    ft = {'terraform', 'hcl'},
  }, {
    'juliosueiras/vim-terraform-completion',
    commit = "125d0e892f5fd8f32b57a5a5983d03f1aa611949",
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    ft = {'terraform', 'hcl'},
  },

  -- Color
  {
    'folke/tokyonight.nvim',
    tag = 'v1.3.0',
    config = function()
      require'tokyonight'.setup {
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
    'norcalli/nvim-colorizer.lua',
    commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  },
  {
    'junegunn/seoul256.vim',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  },
  {
    'AlessandroYorba/Despacio',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  },
  {
    'morhetz/gruvbox',
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"}
  }
}

-- vim.cmd [[colorscheme tokyonight-night]]
-- vim.cmd [[colorscheme seoul256]]
