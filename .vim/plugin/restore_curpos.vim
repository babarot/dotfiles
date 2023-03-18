function! s:restore_cursor_postion()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup restore-cursor-position
  autocmd!
  autocmd BufWinEnter * call <SID>restore_cursor_postion()
augroup END
