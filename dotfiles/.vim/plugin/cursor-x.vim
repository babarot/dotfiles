" based on https://thinca.hatenablog.com/entry/20090530/1243615055
"
augroup auto-cursorcolumn-appear
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorcolumn('CursorMoved')
  autocmd CursorHold,CursorHoldI   * call s:auto_cursorcolumn('CursorHold')
  autocmd BufEnter * call s:auto_cursorcolumn('WinEnter')
  autocmd BufLeave * call s:auto_cursorcolumn('WinLeave')

  let s:cursorcolumn_lock = 0
  function! s:auto_cursorcolumn(event)
    if a:event ==# 'WinEnter'
      setlocal cursorcolumn
      let s:cursorcolumn_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorcolumn
    elseif a:event ==# 'CursorMoved'
      setlocal nocursorcolumn
      if s:cursorcolumn_lock
        if 1 < s:cursorcolumn_lock
          let s:cursorcolumn_lock = 1
        else
          setlocal nocursorcolumn
          let s:cursorcolumn_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorcolumn
      let s:cursorcolumn_lock = 1
    endif
  endfunction
augroup END

augroup multi-window-toggle-cursor
  autocmd!
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline nocursorcolumn
augroup END

augroup cursor-highlight-emphasis
  autocmd!
  autocmd CursorMoved,CursorMovedI,WinLeave * hi! link CursorLine CursorLine | hi! link CursorColumn CursorColumn
  autocmd CursorHold,CursorHoldI            * hi! link CursorLine Visual     | hi! link CursorColumn Visual
augroup END
