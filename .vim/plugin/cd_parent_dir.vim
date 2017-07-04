function! s:cd_file_parentdir()
  execute ":lcd " . expand("%:p:h")
endfunction

augroup cd-file-parentdir
  autocmd!
  autocmd BufRead,BufEnter * call <SID>cd_file_parentdir()
augroup END
