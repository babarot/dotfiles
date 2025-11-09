-- ============================================================================
-- Delete Current File
-- ============================================================================
--
-- Provides :Rm command to delete the current file
--
-- Usage:
--   :Rm    - Delete with confirmation prompt
--   :Rm!   - Delete without confirmation
--
-- If 'gomi' command is available (https://github.com/babarot/gomi),
-- uses it for trash-like deletion. Otherwise, uses rm.
--
-- Based on: nvim.old/plugin/rm.vim

local function rm_file(opts)
  local file = vim.fn.fnamemodify(vim.fn.expand('%'), ':p')

  -- Check if file exists
  if vim.fn.filereadable(file) ~= 1 then
    vim.notify(string.format("%s does not exist", file), vim.log.levels.WARN)
    return
  end

  -- Check if confirmation is needed (!bang)
  local need_confirm = not opts.bang

  if need_confirm then
    local confirm = vim.fn.confirm(
      string.format("Delete '%s'?", file),
      "&Yes\n&No",
      2  -- Default to No
    )
    if confirm ~= 1 then
      return
    end
  end

  -- Save file before deleting
  pcall(vim.cmd.update)

  -- Use gomi if available, otherwise use Lua's os.remove
  local success = false
  local cmd = nil

  if vim.fn.executable('gomi') == 1 then
    cmd = string.format('gomi %s', vim.fn.shellescape(file))
    success = vim.fn.system(cmd)
    success = (vim.v.shell_error == 0)
  else
    success = os.remove(file)
  end

  if success then
    -- Close buffer if it exists
    local bufname = vim.fn.bufname(file)
    if vim.fn.bufexists(bufname) == 1 and vim.fn.buflisted(bufname) == 1 then
      vim.cmd('bwipeout ' .. bufname)
    end
    vim.notify(string.format("Deleted '%s' successfully!", file), vim.log.levels.INFO)
  else
    vim.notify(string.format("Failed to delete '%s'", file), vim.log.levels.ERROR)
  end
end

-- Create :Rm command
vim.api.nvim_create_user_command('Rm', rm_file, {
  bang = true,
  desc = 'Delete current file (! for no confirmation)',
})
