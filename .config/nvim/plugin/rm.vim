function! s:rm(bang)
  let file = fnamemodify(expand('%'), ':p')
  " https://github.com/babarot/gomi
  let cmd = "system(printf('%s %s', executable('gomi') ? 'gomi' : 'rm', shellescape(file)))"

  if !filereadable(file)
    echo printf("%s does not exist", file)
    return
  endif

  if empty(a:bang)
    redraw | echo printf("Delete '%s?' [y/N]: ", file)
  endif

  if !empty(a:bang) || nr2char(getchar()) ==? 'y'
    silent! update
    if eval(cmd == "" ? delete(file) : cmd) == 0
      let bufname = bufname(fnamemodify(file, ':p'))
      if bufexists(bufname) && buflisted(bufname)
        execute "bwipeout" bufname
      endif
      echo printf("Deleted '%s' successfully!", file)
    else
      echo printf("Failed to delete '%s'", file)
    endif
  endif
endfunction

command! -nargs=? -bang -complete=file Rm call s:rm(<q-bang>)
