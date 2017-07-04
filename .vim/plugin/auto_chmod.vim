function! s:add_permission_x()
  let file = expand('%:p')
  if !executable(file)
    if getline(1) =~# '^#!'
          \ || &filetype =~ "\\(z\\|c\\|ba\\)\\?sh$"
          \ && input(printf('"%s" is not perm 755. Change mode? [y/N] ', expand('%:t'))) =~? '^y\%[es]$'
      call system("chmod 755 " . shellescape(file))
      redraw | echo "Set permission 755!"
    endif
  endif
endfunction

augroup auto-add-executable
  autocmd!
  " autocmd BufWritePost * call <SID>add_permission_x()
augroup END
