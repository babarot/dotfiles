return function()
  local actions = require('telescope.actions')
  require('telescope').setup {
    defaults = {
      path_display = function(opts, path)
        local truncate = require('plenary.strings').truncate
        local get_status = require('telescope.state').get_status
        local calc_result_length = function(truncate_len)
          local status = get_status(vim.api.nvim_get_current_buf())
          local len = vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
          return type(truncate_len) == 'number' and len - truncate_len or len
        end
        local truncate_len = 1
        if opts.__length == nil then
          opts.__length = calc_result_length(truncate_len)
        end
        if opts.__prefix == nil then
          opts.__prefix = 0
        end
        local transformed_path = path:gsub(os.getenv('HOME'), '~')
        return truncate(transformed_path, opts.__length - opts.__prefix, nil, -1)
      end,
      scroll_strategy = 'limit', -- 'cycle'
      sorting_strategy = 'ascending',
      layout_strategy = 'horizontal',
      layout_config = {
        horizontal = {
          width = 0.80,
          height = 0.60,
          prompt_position = 'top',
          preview_width = { 0.5, min = 20 },
        },
      },
      dynamic_preview_title = true,
      initial_mode = 'normal',
      file_ignore_patterns = {
        '.git/',
        '.backup/vim',
      },
      mappings = {
        i = {
              ['<esc>'] = actions.close,
              ['jj'] = { '<esc>', type = 'command' },
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-u>'] = actions.preview_scrolling_up,
        },
        n = {
              ['<esc>'] = actions.close,
              ['<space>j'] = actions.close, -- depends on my keymap
              ['q'] = actions.close,
              ['<C-d>'] = actions.results_scrolling_down,
              ['<C-u>'] = actions.results_scrolling_up,
              ['<C-n>'] = actions.preview_scrolling_down,
              ['<C-p>'] = actions.preview_scrolling_up,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      oldfiles = {
        entry_maker = require('plugins.telescope-custom').file_displayer(),
        previewer = false,
      },
      live_grep = {
        additional_args = function()
          return { '--hidden' }
        end
      },
    },
    extensions = {
      repo = {
        list = {
          fd_opts = { '--no-ignore-vcs' },
          search_dirs = { '~/src' }
        }
      }
    },
  }
end
