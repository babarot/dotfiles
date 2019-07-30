"if IsWindows()
"  set nobackup
"else
  set backup
  silent! call rc#misc#mkdir('~/.vim/backup')
  augroup backup-files-automatically
    autocmd!
    autocmd BufWritePre * call s:backup_files()
  augroup END

  function! s:backup_files()
    let dir = strftime("~/.backup/vim/%Y/%m/%d", localtime())
    if !isdirectory(dir)
      call system("mkdir -p " . dir)
      call system("chown goth:staff " . dir)
    endif
    execute "set backupdir=" . dir
    execute "set backupext=." . strftime("%H_%M_%S", localtime())
  endfunction
"endif
