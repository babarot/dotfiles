return function()
  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end

  local lspkind = require 'lspkind'
  local cmp = require 'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-e>']  = cmp.mapping.abort(),
      ['<C-b>']  = cmp.mapping.scroll_docs( -4),
      ['<C-f>']  = cmp.mapping.scroll_docs(4),
      ['<C-k>']  = cmp.mapping.complete(),
      ['<C-n>']  = cmp.mapping.select_next_item(),
      ['<C-p>']  = cmp.mapping.select_prev_item(),
      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<Up>']   = cmp.mapping.select_prev_item(),
      ['<CR>']   = cmp.mapping.confirm({ select = true }),
      ['<Tab>']  = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
      ['<C-g>']  = cmp.mapping(function(fallback)
        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n',
          true)
      end)
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'emoji' },
      { name = 'cmdline' },
      { name = 'copilot' },
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        ellipsis_char = '...',
      }),
    },
    experimental = {
      ghost_text = false -- this feature conflict to the copilot.vim's preview.
    }
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    -- mapping = cmp.mapping.preset.cmdline(),
    mapping = cmp.mapping.preset.cmdline({
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end
