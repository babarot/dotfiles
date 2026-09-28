-- ============================================================================
-- Oil.nvim - File explorer as a buffer
-- ============================================================================

return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    lazy = false,
    config = function()
      require('oil').setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        default_file_explorer = true,

        -- Id is automatically added at the beginning, and name at the end
        columns = {
          'icon',
          -- 'permissions',
          -- 'size',
          -- 'mtime',
        },

        -- Buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },

        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },

        -- Send deleted files to the trash instead of permanently deleting them
        delete_to_trash = true,

        -- Skip the confirmation popup for simple operations
        skip_confirm_for_simple_edits = false,

        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        prompt_save_on_select_new_entry = true,

        -- Oil will automatically delete hidden buffers after this delay
        cleanup_delay_ms = 2000,

        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = 'actions.select_vsplit',
          ['<C-h>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['q'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },

        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,

        view_options = {
          -- Show files and directories that start with "."
          show_hidden = false,

          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            -- Don't hide .. (parent directory)
            if name == '..' then
              return false
            end
            return vim.startswith(name, '.')
          end,

          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,

          sort = {
            -- sort order can be "asc" or "desc"
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },

        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },
      })

      -- Keymaps to open oil
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>-', function()
        require('oil').open_float()
      end, { desc = 'Open parent directory in floating window' })
    end,
  },
}
