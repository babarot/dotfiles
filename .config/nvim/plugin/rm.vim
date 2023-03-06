function! s:rm(bang)
  let file = fnamemodify(expand('%'), ':p')
  let cmd = "system(printf('%s %s', 'gomi', shellescape(file)))"

  if !filereadable(file)
    return Error("The '" . file . "' does not exist")
    return
  endif

  if empty(a:bang)
    redraw | echo 'Delete "' . file . '"? [y/N]: '
  endif

  if !empty(a:bang) || nr2char(getchar()) ==? 'y'
    silent! update
    if eval(cmd == "" ? delete(file) : cmd) == 0
      let bufname = bufname(fnamemodify(file, ':p'))
      if bufexists(bufname) && buflisted(bufname)
        execute "bwipeout" bufname
      endif
      echo "Deleted '" . file . "', successfully!"
      return v:true
    endif
    return Error("Could not delete '" . file . "'")
  else
    echo "Do nothing."
  endif
endfunction

command! -nargs=? -bang -complete=file Rm call s:rm(<q-bang>)
