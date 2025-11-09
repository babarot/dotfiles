vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    -- html = function(path, bufnr)
    --   -- https://tech.serhatteker.com/post/2022-06/nvim-syntax-highlight-hugo-html/
    --   if string.find('{{', vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)) then
    --     return 'gohtmltmpl'
    --   end
    -- end
    tape = 'vhs',
    tf = 'terraform',
    tfvars = 'terraform',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    [".*/layouts/.*%.html"] = "gohtmltmpl",
  },
  filename = {
    ["README$"] = function(path, bufnr)
      if string.find("#", vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)) then
        return "markdown"
      end
      -- no return means the filetype won't be set and to try the next method
    end,
  },
  literal = {
    Brewfile = 'brewfile',
    ['.tagpr'] = 'ini'
  },
  function_extensions = {
    ['sh'] = function()
      vim.bo.filetype = 'sh'
      vim.bo.iskeyword = vim.bo.iskeyword .. ',:'
    end,
    ['zsh'] = function()
      vim.bo.filetype = 'zsh'
      vim.bo.iskeyword = vim.bo.iskeyword .. ',:'
    end,
    ['go'] = function()
      vim.bo.filetype = 'go'
      vim.bo.autoindent = true
      vim.bo.expandtab = false
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.tabstop = 4
    end,
  },
  function_literal = {},
})
