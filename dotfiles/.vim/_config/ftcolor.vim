if !g:pkg.installed('ftcolor.vim')
  finish
endif

let g:ftcolor_plugin_enabled = 1
let g:ftcolor_redraw = 1
let g:ftcolor_default_color_scheme = 'seoul256'
let g:ftcolor_color_mappings = {
      \ 'vim': 'Tomorrow-Night',
      \ 'hcl':  'gruvbox',
      \ 'go':   'seoul256',
      \ 'yaml': 'seoul256',
      \ 'bash': 'despacio',
      \ 'zsh':  'despacio',
      \ 'sh':   'seoul256',
      \ }
