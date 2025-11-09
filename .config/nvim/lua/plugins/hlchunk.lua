-- ============================================================================
-- hlchunk.nvim - Code Chunk & Indent Highlighting
-- ============================================================================
--
-- Features:
--   - chunk: Highlight code block under cursor
--   - indent: Indent guide lines (disabled - using indent-blankline instead)
--   - line_num: Line number highlighting
--   - blank: Blank line highlighting

return {
  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('hlchunk').setup({
        -- Chunk: Highlight the code block under cursor
        chunk = {
          enable = true,
          priority = 15,
          style = {
            { fg = '#806d9c' },  -- Chunk border color
            { fg = '#c21f30' },  -- Error chunk color
          },
          use_treesitter = true,
          chars = {
            horizontal_line = '─',
            vertical_line = '│',
            left_top = '╭',
            left_bottom = '╰',
            right_arrow = '>',
          },
          textobject = '',  -- Disable textobject by default
          max_file_size = 1024 * 1024,  -- 1MB
          error_sign = true,
          duration = 200,
          delay = 300,
        },

        -- Indent: Disabled (using indent-blankline.nvim instead)
        indent = {
          enable = false,
        },

        -- Line number: Highlight line numbers in chunk
        line_num = {
          enable = false,  -- Disabled by default
          style = '#806d9c',
          priority = 10,
        },

        -- Blank: Highlight blank lines
        blank = {
          enable = false,  -- Disabled by default
          chars = {
            ' ',
          },
          style = {
            { bg = '#434437' },
            { bg = '#2f4440' },
            { bg = '#433054' },
            { bg = '#284251' },
          },
          priority = 9,
        },
      })
    end,
  },
}
