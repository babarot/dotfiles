-- ============================================================================
-- Neovim Configuration
-- ============================================================================
--
-- Structure:
--   ~/.config/nvim/
--   ├── init.lua                    (this file)
--   └── lua/
--       └── config/
--           ├── options.lua         (vim options and settings)
--           ├── keymaps.lua         (key mappings)
--           ├── autocmds.lua        (autocommands)
--           ├── filetypes.lua       (filetype detection and settings)
--           └── commands.lua        (custom user commands)

-- Load configuration modules
require('config.options')
require('config.lazy')
require('config.keymaps')
require('config.autocmds')
require('config.filetypes')
require('config.commands')
