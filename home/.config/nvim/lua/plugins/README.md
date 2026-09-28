## Currently Installed Plugins

### Color Schemes (12)

- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [junegunn/seoul256.vim](https://github.com/junegunn/seoul256.vim)
- [marko-cerovac/material.nvim](https://github.com/marko-cerovac/material.nvim)
- [projekt0n/github-nvim-theme](https://github.com/projekt0n/github-nvim-theme)
- [gbprod/nord.nvim](https://github.com/gbprod/nord.nvim)
- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
- [akinsho/horizon.nvim](https://github.com/akinsho/horizon.nvim)
- [olivercederborg/poimandres.nvim](https://github.com/olivercederborg/poimandres.nvim)
- [cocopon/iceberg.vim](https://github.com/cocopon/iceberg.vim)
- [AlessandroYorba/Despacio](https://github.com/AlessandroYorba/Despacio)
- [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
- [maxmx03/solarized.nvim](https://github.com/maxmx03/solarized.nvim)

### Color Scheme Switcher (1)

- [babarot/ftcolor.nvim](https://github.com/babarot/ftcolor.nvim) - Automatic colorscheme switching per filetype

### Foundation & LSP (3)

- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Per-server defaults (lsp/*.lua) for Neovim's vim.lsp.config / vim.lsp.enable (gopls, lua_ls)
- [nvimdev/lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) - LSP UI enhancement (hover, peek, outline, etc.)
- [saghen/blink.cmp](https://github.com/saghen/blink.cmp) - Completion engine (Rust-based, fast)

LSP servers and treesitter parsers (with their queries) come from Nix, in `nix/home/tools/neovim.nix`, not from mason or nvim-treesitter. Highlighting is Neovim's own (`vim.treesitter.start` in `lua/config/autocmds.lua`).

### Completion & Snippets (2)

- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippet collection (blink.cmp dependency)
- [moyiz/blink-emoji.nvim](https://github.com/moyiz/blink-emoji.nvim) - Emoji completion source for blink.cmp

### Editing Features (4)

- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close brackets
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround) - Surround text operations (ys, ds, cs)
- [Wansmer/treesj](https://github.com/Wansmer/treesj) - Split/join code blocks (Tree-sitter based)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) - Code formatter (200+ formatters, minimal diff, range format)

### UI & Integration Tools (6)

- [folke/snacks.nvim](https://github.com/folke/snacks.nvim) - Integrated UI toolkit (picker, dashboard, explorer, notifier, gitbrowse :GH, GitHub issues/PRs, etc.)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding hints display
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line (fast, beautiful, LSP/Git integration)
- [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim) - Tab line (buffer list display, lightweight and fast)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim) - Integrated display of diagnostics and LSP references
- [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) - Claude Code IDE integration (Claude Code in a herdr pane connects with /ide; its edits open as diffs)

### Visual Aids (6)

- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight TODO/FIXME comments
- [ntpeters/vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace) - Highlight and auto-remove trailing whitespace
- [dstein64/nvim-scrollview](https://github.com/dstein64/nvim-scrollview) - Display scrollbar
- [utilyre/barbecue.nvim](https://github.com/utilyre/barbecue.nvim) - Breadcrumb list in winbar (LSP integration)
- [tummetott/reticle.nvim](https://github.com/tummetott/reticle.nvim) - Auto show/hide cursor line
- [babarot/cursor-x.nvim](https://github.com/babarot/cursor-x.nvim) - Auto-highlight cursor position (after delay)

### Git Integration (2)

- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git diff display, hunk operations, blame display
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) - Single tabpage interface for cycling through diffs, file history, and merge conflicts

### Language-Specific (3)

- [ray-x/go.nvim](https://github.com/ray-x/go.nvim) - Go development tools (goimport, add tags, run tests, etc.)
- [babarot/markdown-preview.nvim](https://github.com/babarot/markdown-preview.nvim) - Markdown preview (using GitHub API)
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Markdown rendering (headings, code blocks, tables, etc.)

### Icons (2)

- [echasnovski/mini.icons](https://github.com/echasnovski/mini.icons) - Icon support (snacks/lspsaga/barbecue/oil dependency)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - Icon support (barbar dependency)

### File Operations (3)

- [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim) - File explorer as a buffer (edit filesystem like a buffer)
- [babarot/rm.nvim](https://github.com/babarot/rm.nvim) - Safe file deletion (:Rm command, gomi support)
- [babarot/backup.nvim](https://github.com/babarot/backup.nvim) - Automatic backup on file save (~/.backup/vim, organized by date)

### Utility Libraries (3)

- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua function library (todo-comments dependency)
- [SmiteshP/nvim-navic](https://github.com/SmiteshP/nvim-navic) - LSP-based navigation (barbecue dependency)
- [ray-x/guihua.lua](https://github.com/ray-x/guihua.lua) - GUI/floating window library (go.nvim dependency)

### Replaced by Neovim itself

- Comment.nvim → `gc` / `gcc` (Visual `K` still toggles comments)
- atone.nvim → `:Undotree` (`<Space>u`)
- nvim-hlslens → the search count Neovim shows (`[3/12]`)
- traces.vim → `inccommand` (default `nosplit`)
- wilder.nvim → built-in cmdline autocompletion (`wildtrigger()` in `lua/config/options.lua`)
- indent-blankline.nvim → snacks.nvim's indent
