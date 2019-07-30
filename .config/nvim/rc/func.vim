if !exists('g:env')
    finish
endif

" func s:toggle_option() {{{1
function! s:toggle_option(option_name)
    if exists('&' . a:option_name)
        execute 'setlocal' a:option_name . '!'
        execute 'setlocal' a:option_name . '?'
    endif
endfunction

" func s:toggle_variable() {{{1
function! s:toggle_variable(variable_name)
    if eval(a:variable_name)
        execute 'let' a:variable_name . ' = 0'
    else
        execute 'let' a:variable_name . ' = 1'
    endif
    echo printf('%s = %s', a:variable_name, eval(a:variable_name))
endfunction


" func s:ls() {{{1
function! s:ls(path, bang)
    let path = empty(a:path) ? getcwd() : expand(a:path)
    if filereadable(path)
        if executable("ls")
            echo system("ls -l " . path)
            return v:shell_error ? g:false : g:true
        else
            return s:error('ls: command not found')
        endif
    endif

    if !isdirectory(path)
        return s:error(path.":No such file or directory")
    endif

    let save_ignore = &wildignore
    set wildignore=
    let filelist = glob(path . "/*")
    if !empty(a:bang)
        let filelist .= "\n".glob(path . "/.*[^.]")
    endif
    let &wildignore = save_ignore
    let filelist = substitute(filelist, '', '^M', 'g')

    if empty(filelist)
        return s:error("no file")
    endif

    let lists = []
    for file in split(filelist, "\n")
        if isdirectory(file)
            call add(lists, fnamemodify(file, ":t") . "/")
        else
            if executable(file)
                call add(lists, fnamemodify(file, ":t") . "*")
            elseif getftype(file) == 'link'
                call add(lists, fnamemodify(file, ":t") . "@")
            else
                call add(lists, fnamemodify(file, ":t"))
            endif
        endif
    endfor

    echohl WarningMsg | echon len(lists) . ":\t" | echohl None
    highlight LsDirectory  cterm=bold ctermfg=NONE ctermfg=26        gui=bold guifg=#0096FF   guibg=NONE
    highlight LsExecutable cterm=NONE ctermfg=NONE ctermfg=Green     gui=NONE guifg=Green     guibg=NONE
    highlight LsSymbolick  cterm=NONE ctermfg=NONE ctermfg=LightBlue gui=NONE guifg=LightBlue guibg=NONE

    for item in lists
        if item =~ '/'
            echohl LsDirectory | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        elseif item =~ '*'
            echohl LsExecutable | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        elseif item =~ '@'
            echohl LsSymbolick | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        else
            echon item . " "
        endif
    endfor

    return g:true
endfunction

" func s:count_buffers() {{{1
function! s:count_buffers()
    let l:count = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && buflisted(i)
            let l:count += 1
        endif
    endfor
    return l:count
endfunction

" func s:get_buflists() {{{1
function! s:get_buflists(...)
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

" func s:smart_bwipeout() {{{1
function! s:smart_bwipeout(mode)
    " Bwipeout! all buffers except current buffer.
    if a:mode == 1
        for i in range(1, bufnr('$'))
            if bufexists(i)
                if bufnr('%') ==# i | continue | endif
                execute 'silent bwipeout! ' . i
            endif
        endfor
        return
    endif

    if a:mode == 0
        if winnr('$') != 1
            quit
            return
        elseif tabpagenr('$') != 1
            tabclose
            return
        endif
    endif

    let bufname = empty(bufname(bufnr('%'))) ? bufnr('%') . "#" : bufname(bufnr('%'))
    if &modified == 1
        echo printf("'%s' is unsaved. Quit!? [y(f)/N/w] ", bufname)
        let c = nr2char(getchar())

        if c ==? 'w'
            let filename = ''
            if bufname(bufnr("%")) ==# filename
                redraw
                while empty(filename)
                    let filename = input('Tell me filename: ')
                endwhile
            endif
            execute "write " . filename
            silent bwipeout!

        elseif c ==? 'y' || c ==? 'f'
            silent bwipeout!
        else
            redraw
            echo "Do nothing"
            return
        endif
    else
        silent bwipeout
    endif

    if s:has_plugin("vim-buftabs")
        echo "Bwipeout " . bufname
    else
        redraw
        call <SID>get_buflists()
    endif
endfunction

" func s:smart_bchange() {{{1
function! s:smart_bchange(mode)
    let mode = a:mode

    " If window splitted, no working
    if winnr('$') != 1
        " Normal bnext/bprev
        execute 'silent' mode ==? 'n' ? 'bnext' : 'bprevious'
        if exists("*s:get_buflists") && exists("*s:count_buffers")
            if s:count_buffers() > 1
                call s:get_buflists()
            endif
        endif
        return
    endif

    " Get all buffer numbers in tabpages
    let tablist = []
    for i in range(tabpagenr('$'))
        call add(tablist, tabpagebuflist(i + 1))
    endfor

    " Get buffer number
    execute 'silent' mode ==? 'n' ? 'bnext' : 'bprevious'
    let bufnr = bufnr('%')
    execute 'silent' mode ==? 'n' ? 'bprevious' : 'bnext'

    " Check next/prev buffer number if exists in l:tablist
    let nextbuf = []
    call add(nextbuf, bufnr)
    if index(tablist, nextbuf) >= 0
        execute 'silent tabnext' index(tablist, nextbuf) + 1
    else
        " Normal bnext/bprev
        execute 'silent' mode ==? 'n' ? 'bnext' : 'bprevious'
    endif
endfunction

function! s:bufnew(buf, bang)
    let buf = empty(a:buf) ? '' : a:buf
    execute "new" buf | only
    if !empty(a:bang)
        let bufname = empty(buf) ? '[Scratch]' : buf
        setlocal bufhidden=unload
        setlocal nobuflisted
        setlocal buftype=nofile
        setlocal noswapfile
        silent file `=bufname`
    endif
endfunction

" func s:buf_enqueue() {{{1
function! s:buf_enqueue(buf)
    let buf = fnamemodify(a:buf, ':p')
    if bufexists(buf) && buflisted(buf) && filereadable(buf)
        let idx = match(s:bufqueue ,buf)
        if idx != -1
            call remove(s:bufqueue, idx)
        endif
        call add(s:bufqueue, buf)
    endif
endfunction

" func s:buf_dequeue() {{{1
function! s:buf_dequeue(buf)
    if empty(s:bufqueue)
        throw 'bufqueue: Empty queue.'
    endif

    if a:buf =~# '\d\+'
        return remove(s:bufqueue, a:buf)
    else
        return remove(s:bufqueue, index(s:bufqueue, a:buf))
    endif
endfunction

" func s:buf_restore() {{{1
function! s:buf_restore()
    try
        execute 'edit' s:buf_dequeue(-1)
    catch /^bufqueue:/
        "echohl ErrorMsg
        "echomsg v:exception
        "echohl None
        call s:error(v:exception)
    endtry
endfunction

" func s:all_buffers_bwipeout() {{{1
function! s:all_buffers_bwipeout()
    for i in range(1, bufnr('$'))
        if bufexists(i) && buflisted(i)
            execute 'bwipeout' i
        endif
    endfor
endfunction

" func s:win_tab_switcher() {{{1
function! s:win_tab_switcher(...)
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

    if s:has_plugin("vim-buftabs")
    else
        redraw
        call <SID>get_buflists()
    endif
endfunction

" func s:tabdrop() {{{1
function! s:tabdrop(target)
    let target = empty(a:target) ? expand('%:p') : bufname(a:target + 0)
    if !empty(target) && bufexists(target) && buflisted(target)
        execute 'tabedit' target
    else
        call s:warning("Could not tabedit")
    endif
endfunction

" func s:tabnew() {{{1
function! s:tabnew(num)
    let num = empty(a:num) ? 1 : a:num
    for i in range(1, num)
        tabnew
    endfor
endfunction

" func s:move_tabpage() {{{1
function! s:move_tabpage(dir)
    if a:dir == "right"
        let num = tabpagenr()
    elseif a:dir == "left"
        let num = tabpagenr() - 2
    endif
    if num >= 0
        execute "tabmove" num
    endif
endfunction

" func s:close_all_right_tabpages() {{{1
function! s:close_all_right_tabpages()
    let current_tabnr = tabpagenr()
    let last_tabnr = tabpagenr("$")
    let num_close = last_tabnr - current_tabnr
    let i = 0
    while i < num_close
        execute "tabclose " . (current_tabnr + 1)
        let i = i + 1
    endwhile
endfunction

" func s:close_all_left_tabpages() {{{1
function! s:close_all_left_tabpages()
    let current_tabnr = tabpagenr()
    let num_close = current_tabnr - 1
    let i = 0
    while i < num_close
        execute "tabclose 1"
        let i = i + 1
    endwhile
endfunction

" func s:find_tabnr() {{{1
function! s:find_tabnr(bufnr)
    for tabnr in range(1, tabpagenr("$"))
        if index(tabpagebuflist(tabnr), a:bufnr) !=# -1
            return tabnr
        endif
    endfor
    return -1
endfunction

" func s:find_winnr() {{{1
function! s:find_winnr(bufnr)
    for winnr in range(1, winnr("$"))
        if a:bufnr ==# winbufnr(winnr)
            return winnr
        endif
    endfor
    return 1
endfunction

" func s:find_winnr() {{{1
function! s:recycle_open(default_open, path)
    let default_action = a:default_open . ' ' . a:path
    if bufexists(a:path)
        let bufnr = bufnr(a:path)
        let tabnr = s:find_tabnr(bufnr)
        if tabnr ==# -1
            execute default_action
            return
        endif
        execute 'tabnext ' . tabnr
        let winnr = s:find_winnr(bufnr)
        execute winnr . 'wincmd w'
    else
        execute default_action
    endif
endfunction

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
