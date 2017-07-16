function! rc#buf#win_tab_switcher(...)
  let minus = 0
  if &laststatus == 1 && winnr('$') != 1
    let minus += 1
  elseif &laststatus == 2
    let minus += 1
  endif
  let minus += &cmdheight
  if &showtabline == 1 && tabpagenr('$') != 1
    let minus += 1
  elseif &showtabline == 2
    let minus += 1
  endif

  let is_split   = winheight(0) != &lines - minus
  let is_vsplit  = winwidth(0)  != &columns
  let is_tabpage = tabpagenr('$') >= 2

  let buffer_switcher = get(g:, 'buffer_switcher', 0)
  if a:0 && a:1 ==# 'l'
    if is_tabpage
      if tabpagenr() == tabpagenr('$')
        if !is_split && !is_vsplit
          if buffer_switcher
            silent bnext
          else
            echohl WarningMsg
            echo 'Last tabpages'
            echohl None
          endif
        endif
        if (is_split || is_vsplit) && winnr() == winnr('$')
          if buffer_switcher
            silent bnext
          else
            echohl WarningMsg
            echo 'Last tabpages'
            echohl None
          endif
        elseif (is_split || is_vsplit) && winnr() != winnr('$')
          silent wincmd w
        endif
      else
        if !is_split && !is_vsplit
          silent tabnext
        endif
        if (is_split || is_vsplit) && winnr() == winnr('$')
          silent tabnext
        elseif (is_split || is_vsplit) && winnr() != winnr('$')
          silent wincmd w
        endif
      endif
    else
      if !is_split && !is_vsplit
        if buffer_switcher
          silent bnext
        else
          echohl WarningMsg
          echo 'Last tabpages'
          echohl None
        endif
      endif
      if (is_split || is_vsplit) && winnr() == winnr('$')
        if buffer_switcher
          silent bnext
        else
          echohl WarningMsg
          echo 'Last tabpages'
          echohl None
        endif
      else
        silent wincmd w
      endif
    endif
  endif
  if a:0 && a:1 ==# 'h'
    if is_tabpage
      if tabpagenr() == 1
        if !is_split && !is_vsplit
          if buffer_switcher
            silent bprevious
          else
            echohl WarningMsg
            echo 'First tabpages'
            echohl None
          endif
        endif
        if (is_split || is_vsplit) && winnr() == 1
          if buffer_switcher
            silent bprevious
          else
            echohl WarningMsg
            echo 'First tabpages'
            echohl None
          endif
        elseif (is_split || is_vsplit) && winnr() != 1
          silent wincmd W
        endif
      else
        if !is_split && !is_vsplit
          silent tabprevious
        endif
        if (is_split || is_vsplit) && winnr() == 1
          silent tabprevious
        elseif (is_split || is_vsplit) && winnr() != 1
          silent wincmd W
        endif
      endif
    else
      if !is_split && !is_vsplit
        if buffer_switcher
          silent bprevious
        else
          echohl WarningMsg
          echo 'First tabpages'
          echohl None
        endif
      endif
      if (is_split || is_vsplit) && winnr() == 1
        if buffer_switcher
          silent bprevious
        else
          echohl WarningMsg
          echo 'First tabpages'
          echohl None
        endif
      else
        silent wincmd W
      endif
    endif
  endif

  if !g:plug.is_installed("vim-buftabs")
    redraw
    call rc#buf#list()
  endif
endfunction

nnoremap <silent> <C-l> :<C-u>call rc#buf#win_tab_switcher('l')<CR>
nnoremap <silent> <C-h> :<C-u>call rc#buf#win_tab_switcher('h')<CR>

function! rc#buf#list(...)
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

if g:plug.is_installed('vim-buftabs')
    nnoremap <silent> <C-j> :<C-u>silent bnext<CR>
    nnoremap <silent> <C-k> :<C-u>silent bprev<CR>
else
    nnoremap <silent> <C-j> :<C-u>silent bnext<CR>:<C-u>call rc#buf#list()<CR>
    nnoremap <silent> <C-k> :<C-u>silent bprev<CR>:<C-u>call rc#buf#list()<CR>
endif

" Kill buffer
if !g:plug.is_installed('vim-buftabs')
  nnoremap <silent> <C-x>k     :<C-u>call <SID>smart_bwipeout(0)<CR>
  nnoremap <silent> <C-x>K     :<C-u>call <SID>smart_bwipeout(1)<CR>
  nnoremap <silent> <C-x><C-k> :<C-u>call <SID>smart_bwipeout(2)<CR>
else
  "autocmd BufUnload,BufLeave,BufDelete,BufWipeout * call rc#buf#list()
  nnoremap <silent> <C-x>k     :<C-u>call <SID>smart_bwipeout(0)<CR>
  nnoremap <silent> <C-x>K     :<C-u>call <SID>smart_bwipeout(1)<CR>
  nnoremap <silent> <C-x><C-k> :<C-u>call <SID>smart_bwipeout(2)<CR>
  "nnoremap <silent> <C-x>k     :<C-u>silent call <SID>smart_bwipeout(0)<CR>:<C-u>call rc#buf#list()<CR>
  "nnoremap <silent> <C-x>K     :<C-u>silent call <SID>smart_bwipeout(1)<CR>:<C-u>call rc#buf#list()<CR>
  "nnoremap <silent> <C-x><C-k> :<C-u>silent call <SID>smart_bwipeout(2)<CR>:<C-u>call rc#buf#list()<CR>
endif

function! rc#buf#delete(bang)
  let file = fnamemodify(expand('%'), ':p')
  let g:buf_delete_safety_mode = 1
  let g:buf_delete_custom_command = "system(printf('%s %s', 'gomi', shellescape(file)))"

  if filereadable(file)
    if empty(a:bang)
      redraw | echo 'Delete "' . file . '"? [y/N]: '
    endif
    if !empty(a:bang) || nr2char(getchar()) ==? 'y'
      silent! update
      if g:buf_delete_safety_mode == 1
        silent! execute has('clipboard') ? '%yank "*' : '%yank'
      endif
      if eval(g:buf_delete_custom_command == "" ? delete(file) : g:buf_delete_custom_command) == 0
        let bufname = bufname(fnamemodify(file, ':p'))
        if bufexists(bufname) && buflisted(bufname)
          execute "bwipeout" bufname
        endif
        echo "Deleted '" . file . "', successfully!"
        return g:true
      endif
      "echo "Could not delete '" . file . "'"
      return Error("Could not delete '" . file . "'")
    else
      echo "Do nothing."
    endif
  else
    return Error("The '" . file . "' does not exist")
  endif
endfunction
