let s:home = expand("<sfile>:h")
let s:init_file = s:home . "/.vim/init.vim"

if filereadable(s:init_file)
  execute 'source ' . s:init_file
endif
