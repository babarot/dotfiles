-- ============================================================================
-- render-markdown.nvim - Enhanced Markdown Rendering
-- ============================================================================
--
-- Features:
--   - Render headings with icons and backgrounds
--   - Code blocks with language indicators
--   - Tables with borders
--   - Lists with custom bullet points
--   - Checkboxes with multiple states
--   - Links with icons
--
-- Commands:
--   :RenderMarkdown toggle  - Toggle rendering
--   :RenderMarkdown enable  - Enable rendering
--   :RenderMarkdown disable - Disable rendering

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',  -- Load only for markdown files
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',  -- Icon support
    },
    opts = {
      -- Only render markdown files (not injected markdown)
      file_types = { 'markdown' },

      -- Rendering mode
      render_modes = { 'n', 'c' },  -- Normal and Command mode only (not insert mode)

      -- Heading configuration
      heading = {
        -- Enable heading rendering
        enabled = true,
        -- Add icons to headings
        sign = true,
        -- Icons for each heading level
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Heading backgrounds
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },

      -- Code block configuration
      code = {
        -- Enable code block rendering
        enabled = true,
        -- Show language name
        sign = true,
        -- Style: 'full' (default), 'normal', 'language', or 'none'
        style = 'full',
        -- Left padding
        left_pad = 0,
        -- Right padding
        right_pad = 0,
        -- Width: 'full' or 'block'
        width = 'full',
        -- Border style
        border = 'thin',
      },

      -- Inline code configuration
      inline_code = {
        enabled = true,
        highlight = 'RenderMarkdownCode',
      },

      -- Dash (horizontal rule) configuration
      dash = {
        enabled = true,
        icon = '─',
        width = 'full',
      },

      -- Bullet configuration
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },

      -- Checkbox configuration
      checkbox = {
        enabled = true,
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
      },

      -- Quote configuration
      quote = {
        enabled = true,
        icon = '▎',
      },

      -- Table configuration
      pipe_table = {
        enabled = true,
        style = 'full',
        cell = 'padded',
        border = {
          '┌', '┬', '┐',
          '├', '┼', '┤',
          '└', '┴', '┘',
          '│', '─',
        },
      },

      -- Callout configuration (for GitHub-style callouts)
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
      },

      -- Link configuration
      link = {
        enabled = true,
        image = '󰥶 ',
        hyperlink = '󰌹 ',
      },

      -- Sign column configuration
      sign = {
        enabled = true,
        highlight = 'RenderMarkdownSign',
      },

      -- Performance settings
      max_file_size = 1.5,  -- MB
      debounce = 100,  -- Milliseconds
    },

    config = function(_, opts)
      require('render-markdown').setup(opts)
    end,
  },
}
