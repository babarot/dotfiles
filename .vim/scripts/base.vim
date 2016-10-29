if !exists('g:env')
    finish
endif

function! s:echomsg(hl, msg) "{{{1
    execute 'echohl' a:hl
    try
        echomsg a:msg
    finally
        echohl None
    endtry
endfunction

function! Error(msg) abort "{{{1
    echohl ErrorMsg
    echo 'ERROR: ' . a:msg
    echohl None
    return g:false
endfunction

function! Warn(msg) abort "{{{1
    echohl WarningMsg
    echo 'WARNING: ' . a:msg
    echohl None
    return g:true
endfunction

function! s:rm(...) "{{{1
    let files = []
    for file in a:0 ? map(copy(a:000), 'expand(v:val)') : split(simplify(expand('%:p')))

        let file = fnamemodify(file, ":p")
        if isdirectory(file)
            let dest = "/tmp/".Random(20)
            if rename(file, dest) == 0
                call add(files, file)
            else
                return Error("not support a directory")
            endif
        elseif filereadable(file)
            if delete(file) == 0
                call add(files, file)
                let bufname = bufname(fnamemodify(file, ':p'))
                if bufexists(bufname) && buflisted(bufname)
                    execute "bwipeout" bufname
                endif
            endif
        else
            echohl WarningMsg | echo "The '" . file . "' does not exist" | echohl NONE
        endif
    endfor

    echo len(files) ? "Removed " . string(files) . "!" : "Removed nothing"
endfunction

function! s:rand(n) "{{{1
    let match_end = matchend(reltimestr(reltime()), '\d\+\.') + 1
    return reltimestr(reltime())[match_end : ] % (a:n + 1)
endfunction

function! s:random_string(n)
    let n = a:n ==# '' ? 8 : a:n
    let s = []
    let chars = split('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '\ze')
    let max = len(chars) - 1
    for x in range(n)
        call add(s, (chars[s:rand(max)]))
    endfor
    let @+ = join(s, '')
    return join(s, '')
endfunction

function! Random(n) abort
    return s:random_string(a:n)
endfunction

function! s:mkdir(dir) "{{{1
    if !exists("*mkdir")
        return g:false
    endif

    let dir = expand(a:dir)
    if isdirectory(dir)
        return g:true
    endif

    return mkdir(dir, "p")
endfunction

function! Mkdir(dir) abort
    return s:mkdir(a:dir)
endfunction

function! s:has_plugin(name) "{{{1
    " Check {name} plugin whether there is in the runtime path
    let nosuffix = a:name =~? '\.vim$' ? a:name[:-5] : a:name
    let suffix   = a:name =~? '\.vim$' ? a:name      : a:name . '.vim'
    return &rtp =~# '\c\<' . nosuffix . '\>'
                \   || globpath(&rtp, suffix, 1) != ''
                \   || globpath(&rtp, nosuffix, 1) != ''
                \   || globpath(&rtp, 'autoload/' . suffix, 1) != ''
                \   || globpath(&rtp, 'autoload/' . tolower(suffix), 1) != ''
endfunction

function! GetBufname(bufnr, ...) "{{{1
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

command! -nargs=? -complete=file -bang Ls2 call s:ls('<args>', '<bang>')
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

    let max = 0
    for item in lists
        let max += len(item)
        if max > &columns * 1.5
            echon "...more"
            break
        endif
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

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:

