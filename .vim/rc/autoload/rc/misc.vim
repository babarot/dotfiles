function! rc#misc#mkdir(dir)
  if !exists("*mkdir")
    return g:false
  endif

  let dir = expand(a:dir)
  if isdirectory(dir)
    return g:true
  endif

  return mkdir(dir, "p")
endfunction
