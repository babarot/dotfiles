setlocal shiftwidth=2 tabstop=2

" augroup jsautocmd
"   " https://github.com/millermedeiros/vim-esformatter
"   autocmd!
"   autocmd BufWritePre *.js :Esformatter
" augroup END

command! -range=% JSFmt :Esformatter
