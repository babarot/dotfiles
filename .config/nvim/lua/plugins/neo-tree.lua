return function()
  local function gomi(state)
    local inputs = require('neo-tree.ui.inputs')
    local cmd = 'gomi'
    if vim.fn.executable(cmd) == 1 then
      local path = state.tree:get_node().path
      local msg = string.format([[gomi: Are you sure you want to delete? '%s']], vim.fn.fnamemodify(path, ':t'))
      inputs.confirm(msg, function(confirmed)
        if not confirmed then return end
        vim.fn.system { cmd, vim.fn.fnameescape(path) }
        require('neo-tree.sources.manager').refresh(state.name)
      end)
    else
      -- just call original delete function
      -- if not `gomi` exists
      -- https://github.com/babarot/gomi
      require('neo-tree.sources.filesystem.commands').delete(state)
    end
  end
  local function open_preview(state)
    local sys = require('neo-tree.sources.filesystem.commands')
    local com = require('neo-tree.sources.common.commands')
    local tree = state.tree
    local node = tree:get_node()
    -- if dir, open dir
    if node.type == 'directory' then
      return sys.open(state)
    end
    -- if file, just preview toggle
    return com.toggle_preview(state)
  end

  require('neo-tree').setup {
    source_selector = {
      winbar = true,
      statusline = true
    },
    window = {
      position = 'left',
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<esc>'] = 'revert_preview',
        ['<cr>'] = 'open',
        ['a'] = 'add',
        ['A'] = 'add_directory',
        ['d'] = gomi,
        ['h'] = 'close_node',
        ['H'] = 'prev_source',
        ['l'] = { open_preview, --[[config = { use_float = true }]] },
        ['L'] = 'next_source',
        ['m'] = 'move',
        ['r'] = 'rename',
        ['p'] = { 'toggle_preview', config = { use_float = true } },
        ['P'] = 'focus_preview',
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['z'] = 'close_all_nodes',
        ['Z'] = 'expand_all_nodes',
        ['?'] = 'show_help',
        ['gu'] = 'git_unstage_file',
        ['ga'] = 'git_add_file',
        ['gc'] = 'git_commit',
      }
    },
    filesystem = {
      follow_current_file = true,
      -- hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
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
        event = 'file_opened',
        handler = function()
          require('neo-tree').close_all()
        end
      },
    },
  }
end
