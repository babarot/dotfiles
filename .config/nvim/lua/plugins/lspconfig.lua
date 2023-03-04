return function()
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local all_clients = vim.lsp.get_active_clients()
  for _, client in pairs(all_clients) do
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
      return;
    end
  end

  require("neodev").setup()

  local lspconfig = require('lspconfig')
  lspconfig.gopls.setup { capabilities = capabilities }
  lspconfig.golangci_lint_ls.setup { capabilities = capabilities }
  lspconfig.sqlls.setup { capabilities = capabilities }
  lspconfig.graphql.setup { capabilities = capabilities }
  lspconfig.pyright.setup { capabilities = capabilities }
  lspconfig.tsserver.setup { capabilities = capabilities }
  lspconfig.dartls.setup { capabilities = capabilities }
  -- lspconfig.terraformls.setup { capabilities = capabilities }
  lspconfig.tflint.setup { capabilities = capabilities }
  lspconfig.dockerls.setup { capabilities = capabilities }
  lspconfig.vimls.setup { capabilities = capabilities }
  lspconfig.bashls.setup { capabilities = capabilities }
  lspconfig.jsonnet_ls.setup { capabilities = capabilities }
  lspconfig.lua_ls.setup { capabilities = capabilities }
  lspconfig.terraformls.setup { "terraform-ls", "serve" }


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
