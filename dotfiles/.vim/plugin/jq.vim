function! s:jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction
command! -nargs=? JQ call s:jq(<f-args>)
