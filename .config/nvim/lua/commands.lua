vim.api.nvim_create_user_command('JQ',
  function(opts)
    local arg
    if #opts.args == 0 then
      arg = "."
    else
      arg = opts.args[0]
    end
    vim.fn.execute("%! jq " .. arg, true)
  end, {})
