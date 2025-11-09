-- ============================================================================
-- Markdown Preview
-- ============================================================================
--
-- Prerequisites:
--   1. GitHub CLI: https://cli.github.com/
--   2. gh extension: gh extension install yusukebe/gh-markdown-preview

return {
  {
    'babarot/markdown-preview.nvim',
    ft = 'markdown',  -- Lazy load on markdown files
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview<cr>', desc = 'Markdown Preview', ft = 'markdown' },
      { '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', desc = 'Markdown Preview Stop', ft = 'markdown' },
      { '<leader>mt', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview Toggle', ft = 'markdown' },
    },
  },
}
