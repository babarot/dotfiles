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

function! rc#misc#get_buf_name(bufnr, ...)
  let bufname = bufname(a:bufnr)
  if bufname =~# '^[[:alnum:].+-]\+:\\\\'
    let bufname = substitute(bufname, '\\', '/', 'g')
  endif
  let buftype = getbufvar(a:bufnr, '&buftype')
  if bufname ==# ''
    if buftype ==# ''
      return '[No Name]'
    elseif buftype ==# 'quickfix'
      return '[Quickfix List]'
    elseif buftype ==# 'nofile' || buftype ==# 'acwrite'
      return '[Scratch]'
    endif
  endif
  if buftype ==# 'nofile' || buftype ==# 'acwrite'
    return bufname
  endif
  if a:0 && a:1 ==# 't'
    return fnamemodify(bufname, ':t')
  elseif a:0 && a:1 ==# 'f'
    return (fnamemodify(bufname, ':~:p'))
  elseif a:0 && a:1 ==# 's'
    return pathshorten(fnamemodify(bufname, ':~:h')).'/'.fnamemodify(bufname, ':t')
  endif
  return bufname
endfunction

function! rc#misc#toggle_option(option_name)
  if exists('&' . a:option_name)
    execute 'setlocal' a:option_name . '!'
    execute 'setlocal' a:option_name . '?'
  endif
endfunction

function! rc#misc#get_buflists(...)
  if a:0 && a:1 ==# 'n'
    silent bnext
  elseif a:0 && a:1 ==# 'p'
    silent bprev
  endif

  let list  = ''
  let lists = []
  for buf in range(1, bufnr('$'))
    if bufexists(buf) && buflisted(buf)
      let list  = bufnr(buf) . "#" . fnamemodify(bufname(buf), ':t')
      let list .= getbufvar(buf, "&modified") ? '+' : ''
      if bufnr('%') ==# buf
        let list = "[" . list . "]"
      else
        let list = " " . list . " "
      endif
      call add(lists, list)
    endif
  endfor
  redraw | echo join(lists, "")
endfunction

function! rc#misc#splitw()
  if winnr('$') == 1
    return ":vsplit\<CR>"
  else
    return ":wincmd w\<CR>"
  endif
endfunction

function! rc#misc#open(file)
  if !g:config.bin.open
    return g:false
    " return Error('open: not supported yet.')
  endif
  let file = empty(a:file) ? expand('%') : fnamemodify(a:file, ':p')
  call system(printf('%s %s &', 'open', shellescape(file)))
  return v:shell_error ? g:false : g:true
endfunction

function! rc#misc#copy_current_path(...)
  let path = a:0 ? expand('%:p:h') : expand('%:p')
  if IsWindows()
    let @* = substitute(path, '\\/', '\\', 'g')
  else
    let @* = path
  endif
  echo path
endfunction

function! rc#misc#junkfile()
  let junk_dir = $HOME . '/.vim/junk'. strftime('/%Y/%m/%d')
  if !isdirectory(junk_dir)
    call s:mkdir(junk_dir)
  endif

  let ext = input('Junk Ext: ')
  let filename = junk_dir . tolower(strftime('/%A')) . strftime('_%H%M%S')
  if !empty(ext)
    let filename = filename . '.' . ext
  endif
  execute 'edit ' . filename
endfunction

function! rc#misc#rename(new, type)
  if a:type ==# 'file'
    if empty(a:new)
      let new = input('New filename: ', expand('%:p:h') . '/', 'file')
    else
      let new = a:new
    endif
  elseif a:type ==# 'ext'
    if empty(a:new)
      let ext = input('New extention: ', '', 'filetype')
      let new = expand('%:p:t:r')
      if !empty(ext)
        let new .= '.' . ext
      endif
    else
      let new = expand('%:p:t:r') . '.' . a:new
    endif
  endif

  if filereadable(new)
    redraw
    echo printf("overwrite `%s'? ", new)
    if nr2char(getchar()) ==? 'y'
      silent call delete(new)
    else
      return g:false
    endif
  endif

  if new != '' && new !=# 'file'
    let oldpwd = getcwd()
    lcd %:p:h
    execute 'file' new
    execute 'setlocal filetype=' . fnamemodify(new, ':e')
    write
    call delete(expand('#'))
    execute 'lcd' oldpwd
  endif
endfunction

function! rc#misc#smart_execute(expr)
  let wininfo = winsaveview()
  execute a:expr
  call winrestview(wininfo)
endfunction

function! rc#misc#smart_foldcloser()
  if foldlevel('.') == 0
    normal! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  normal! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  normal! zM
endfunction
