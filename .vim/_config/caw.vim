if !g:plug.installed('caw.vim')
  finish
endif

vmap <C-k> <Plug>(caw:i:toggle)
vmap K     <Plug>(caw:i:toggle)
