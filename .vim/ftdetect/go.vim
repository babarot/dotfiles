set completeopt-=preview

augroup goautocmd
  autocmd!
  autocmd BufWritePre *.go :GoImports
augroup END
