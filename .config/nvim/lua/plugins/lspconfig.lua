return function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.api.nvim_create_augroup("lsp_document_format", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_format" }
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function() vim.lsp.buf.format() end,
      buffer = bufnr,
      group = "lsp_document_format",
      desc = "Document Format",
    })
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local all_clients = vim.lsp.get_active_clients()
  for _, client in pairs(all_clients) do
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_augroup("lsp_document_format", { clear = true })
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_format" }
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        callback = vim.lsp.buf.format,
        buffer = bufnr,
        group = "lsp_document_format",
        desc = "Document Format",
      })
    end
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = vim.lsp.buf.document_highlight,
        buffer = bufnr,
        group = "lsp_document_highlight",
        desc = "Document Highlight",
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = vim.lsp.buf.clear_references,
        buffer = bufnr,
        group = "lsp_document_highlight",
        desc = "Clear All the References",
      })
    end
  end

  require("neodev").setup()

  local lspconfig = require('lspconfig')
  lspconfig.gopls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.golangci_lint_ls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.sqlls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.graphql.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.pyright.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.tsserver.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.dartls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.terraformls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.tflint.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.dockerls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.vimls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.bashls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.jsonnet_ls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.lua_ls.setup { capabilities = capabilities, on_attach = on_attach }

  local json_schemas = require('schemastore').json.schemas {}
  local yaml_schemas = {}
  vim.tbl_map(function(schema)
    yaml_schemas[schema.url] = schema.fileMatch
  end, json_schemas)

  local yaml_config = require("yaml-companion").setup({
    schemas = {
      {
        name = "Kubernetes",
        uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.6-standalone-strict/all.json",
      },
    },
    lspconfig = {
      settings = {
        yaml = {
          schemas = yaml_schemas,
        }
      }
    }
  })
  lspconfig.yamlls.setup(yaml_config)

  lspconfig.jsonls.setup {
    capabilities = capabilities,
    settings = {
      json = {
        schemas = json_schemas,
      }
    },
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        end
      }
    },
  }

  vim.cmd 'sign define LspDiagnosticsSignError text='
  vim.cmd 'sign define LspDiagnosticsSignWarning text='
  vim.cmd 'sign define LspDiagnosticsSignInformation text='
  vim.cmd 'sign define LspDiagnosticsSignHint text='
  vim.cmd 'setlocal omnifunc=v:lua.vim.lsp.omnifunc'
end
