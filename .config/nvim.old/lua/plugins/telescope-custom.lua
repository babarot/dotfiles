-- based on: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf

local entry_display = require("telescope.pickers.entry_display")
local devicons = require("nvim-web-devicons")

local Path = require("plenary.path")
local get_status = require("telescope.state").get_status

local calc_result_length = function(truncate_len)
  local status = get_status(vim.api.nvim_get_current_buf())
  local len = vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
  return type(truncate_len) == "number" and len - truncate_len or len
end

local M = {}

-- file displayer with two sections; the name and the directory, instead of just the path.
-- Both sections are highlighted differently and the dir is trimmed to fit on the window.
do
  local lookup_keys = {
    ordinal = 1,
    value = 1,
    filename = 3,
    cwd = 2,
  }

  M.file_displayer = function(opts)
    opts = opts or {}

    local default_icons, _ = devicons.get_icon("file", "", { default = true })
    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local entry_metatable = {}
    entry_metatable.cwd = cwd

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = vim.fn.strwidth(default_icons) + 1 },
        { width = 50 }, -- width of the file name column
        { remaining = true },
      },
    })

    entry_metatable.display = function(entry)
      if not opts.__length then
        opts.__length = calc_result_length()
      end

      local path = entry.value
      local name = require("telescope.utils").path_tail(path)
      -- local path = path:gsub(os.getenv('HOME'), '~')
      local directory = Path:new(path):parent() --:make_relative(cwd)

      -- compensate for both spacing chars (2) and the icons column (1) characters
      directory = require("plenary.strings").truncate(directory, math.max(opts.__length - name:len() - 3, 0), nil, -1)
      directory = directory:gsub(os.getenv('HOME'), '~')

      local icons, icons_highlight = devicons.get_icon(entry.value, string.match(entry.value, "%a+$"), { default = true })

      return displayer({
        { icons,     icons_highlight },
        name,
        { directory, "Comment" },
      })
    end

    entry_metatable.__index = function(t, k)
      local raw = rawget(entry_metatable, k)
      if raw then
        return raw
      end

      if k == "path" then
        local retpath = Path:new({ t.cwd, t.value }):absolute()
        if not vim.loop.fs_access(retpath, "R", nil) then
          retpath = t.value
        end
        return retpath
      end

      return rawget(t, rawget(lookup_keys, k))
    end

    return function(line)
      return setmetatable({ line }, entry_metatable)
    end
  end
end


do
  -- grep displayer helper function
  local parse = function(t)
    local _, _, filename, lnum, col, text = string.find(t.value, [[([^:]+):(%d+):(%d+):(.*)]])

    local ok
    ok, lnum = pcall(tonumber, lnum)
    if not ok then
      lnum = nil
    end

    ok, col = pcall(tonumber, col)
    if not ok then
      col = nil
    end

    t.filename = filename
    t.lnum = lnum
    t.col = col
    t.text = text

    return { filename, lnum, col, text }
  end

  local lookup_keys = {
    value = 1,
    ordinal = 1,
  }

  M.grep_displayer = function(opts)
    opts = opts or {}
    opts.cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local default_icons, _ = devicons.get_icon("file", "", { default = true })

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = vim.fn.strwidth(default_icons) },
        { width = 45 },       -- width of the file name column + (line:col) info
        { remaining = true }, -- width of directory + line info
      },
    })

    local make_display = function(entry)
      -- TODO: trim the filename, then add (line:col)
      local cwd = entry.cwd
      local icon, icon_highlight = devicons.get_icon(
        entry.filename,
        string.match(entry.filename, "%a+$"),
        { default = true }
      )

      if not opts.__length then
        opts.__length = calc_result_length()
      end

      local path = entry.filename -- in the form: ./lua/some/thing.py
      local name = require("telescope.utils").path_tail(path)
      local directory = Path:new(path):parent():make_relative(cwd)

      -- compensate for both spacing chars (2) and the icons column (1) characters
      directory = require("plenary.strings").truncate(directory, math.max(opts.__length - name:len() - 3, 0), nil, -1)

      local file_display = string.format("%s |%s:%s", name, entry.lnum, entry.col)
      local dir_display = string.format("%s |%s", directory, entry.text)

      return displayer({
        { icon,        icon_highlight },
        file_display,
        { dir_display, "Comment" },
      })
    end

    local execute_keys = {
      path = function(t)
        if Path:new(t.filename):is_absolute() then
          return t.filename, false
        else
          return Path:new({ t.cwd, t.filename }):absolute(), false
        end
      end,
      filename = function(t)
        return parse(t)[1], true
      end,
      lnum = function(t)
        return parse(t)[2], true
      end,
      col = function(t)
        return parse(t)[3], true
      end,
      text = function(t)
        return parse(t)[4], true
      end,
    }

    local entry_metatable

    entry_metatable = {
      cwd = opts.cwd,
      display = make_display,
      __index = function(t, k)
        local raw = rawget(entry_metatable, k)
        if raw then
          return raw
        end

        local executor = rawget(execute_keys, k)
        if executor then
          local val, save = executor(t)
          if save then
            rawset(t, k, val)
          end
          return val
        end

        return rawget(t, rawget(lookup_keys, k))
      end,
    }

    return function(line)
      return setmetatable({ line }, entry_metatable)
    end
  end
end

return M
