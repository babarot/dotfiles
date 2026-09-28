if !g:pkg.installed('caw.vim')
  finish
endif

vmap K <Plug>(caw:i:toggle)
