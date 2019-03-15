"
" Note: Skip initialization for vim-tiny or vim-small.
"
if 1
  if $DEBUG ==# ''
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/scripts/init.vim'
  else
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/rc/init.vim'
  endif
  " execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/rc/init.vim'
endif

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction
