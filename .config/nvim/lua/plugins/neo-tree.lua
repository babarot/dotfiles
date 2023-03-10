return function()
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
