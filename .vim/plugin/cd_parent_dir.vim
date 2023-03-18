function! s:cd_file_parentdir()
  let dir = expand("%:p:h")
  if !isdirectory(dir)
    return
  endif
  execute ":lcd " . expand("%:p:h")
endfunction

augroup cd-file-parentdir
  autocmd!
  autocmd BufRead,BufEnter * call <SID>cd_file_parentdir()
augroup END
