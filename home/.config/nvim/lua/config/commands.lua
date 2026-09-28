-- Custom user commands

-- Copy file path to clipboard
vim.api.nvim_create_user_command('CP', function(opts)
  local path
  if opts.args == 'name' then
    path = vim.fn.expand('%:t')  -- ファイル名のみ
  elseif opts.args == 'dir' then
    path = vim.fn.expand('%:p:h')  -- ディレクトリのみ
  elseif opts.args == 'rel' then
    path = vim.fn.expand('%:.')  -- 相対パス
  else
    path = vim.fn.expand('%:p')  -- フルパス（デフォルト）
  end
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, {
  nargs = '?',
  desc = 'Copy file path to clipboard (name/dir/rel or full path by default)'
})
