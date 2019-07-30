if !exists('g:env')
    finish
endif

function! s:b4b4r07() "{{{1
    hide enew
    setlocal buftype=nofile nowrap nolist nonumber bufhidden=wipe
    setlocal modifiable nocursorline nocursorcolumn

    let b4b4r07 = []
    call add(b4b4r07, 'Copyright (c) 2014                                 b4b4r07''s vimrc.')
    call add(b4b4r07, '.______    _  _    .______    _  _    .______        ___    ______  ')
    call add(b4b4r07, '|   _  \  | || |   |   _  \  | || |   |   _  \      / _ \  |____  | ')
    call add(b4b4r07, '|  |_)  | | || |_  |  |_)  | | || |_  |  |_)  |    | | | |     / /  ')
    call add(b4b4r07, '|   _  <  |__   _| |   _  <  |__   _| |      /     | | | |    / /   ')
    call add(b4b4r07, '|  |_)  |    | |   |  |_)  |    | |   |  |\  \----.| |_| |   / /    ')
    call add(b4b4r07, '|______/     |_|   |______/     |_|   | _| `._____| \___/   /_/     ')
    call add(b4b4r07, '           #VIM + #ZSH + #TMUX = Best Developer Environmen          ')

    silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2)
    let space = repeat(' ', winwidth(0)/2 - strlen(b4b4r07[0])/2)
    for line in b4b4r07
        put =space . line
    endfor
    silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2 + 1)
    silent file B4B4R07
    1

    execute 'syntax match Directory display ' . '"'. '^\s\+\U\+$'. '"'
    setlocal nomodifiable
    redraw
    let char = getchar()
    silent enew
    call feedkeys(type(char) == type(0) ? nr2char(char) : char)
endfunction

" augroup vimrc-without-plugin
"     autocmd!
"     autocmd VimEnter * if !argc() | call <SID>b4b4r07() | endif
" augroup END

"function! s:cd_file_parentdir() "{{{1
"  execute ":lcd " . expand("%:p:h")
"endfunction
"command! Cdcd call <SID>cd_file_parentdir()
"
""if g:env.vimrc.auto_cd_file_parentdir == g:true
"augroup cd-file-parentdir
"  autocmd!
"  autocmd BufRead,BufEnter * if g:env.vimrc.auto_cd_file_parentdir == g:true | call <SID>cd_file_parentdir() | endif
"augroup END
""endif

command! -nargs=? -complete=dir -bang CD call s:change_current_dir('<args>', '<bang>')
function! s:change_current_dir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . expand(a:directory)
    endif
    if a:bang == ''
        redraw
        call s:ls('', '')
    endif
endfunction

if g:env.vimrc.auto_cd_file_parentdir == g:true
    augroup cd-file-parentdir
        autocmd!
        autocmd BufEnter * call <SID>change_current_dir('', '!')
    augroup END
endif

function! s:win_tab_switcher(...) "{{{1
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

    if g:plug.is_installed("vim-buftabs")
    else
        redraw
        call <SID>get_buflists()
    endif
endfunction
"nnoremap <silent> <C-l> :<C-u>call <SID>win_tab_switcher('l')<CR>
"nnoremap <silent> <C-h> :<C-u>call <SID>win_tab_switcher('h')<CR>

function! s:get_buflists(...) "{{{1
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

function! s:root() "{{{1
    let me = expand('%:p:h')
    let gitd = finddir('.git', me.';')
    if empty(gitd)
        echo "Not in git repo"
    else
        let gitp = fnamemodify(gitd, ':h')
        echo "Change directory to: ".gitp
        execute 'lcd' gitp
    endif
endfunction
command! Root call <SID>root()

function! s:get_buflists(...) "{{{1
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
    nnoremap <silent> <C-j> :<C-u>silent bnext<CR>:<C-u>call <SID>get_buflists()<CR>
    nnoremap <silent> <C-k> :<C-u>silent bprev<CR>:<C-u>call <SID>get_buflists()<CR>
endif

" Kill buffer
if !g:plug.is_installed('vim-buftabs')
    nnoremap <silent> <C-x>k     :<C-u>call <SID>smart_bwipeout(0)<CR>
    nnoremap <silent> <C-x>K     :<C-u>call <SID>smart_bwipeout(1)<CR>
    nnoremap <silent> <C-x><C-k> :<C-u>call <SID>smart_bwipeout(2)<CR>
else
    "autocmd BufUnload,BufLeave,BufDelete,BufWipeout * call <SID>get_buflists()
    nnoremap <silent> <C-x>k     :<C-u>call <SID>smart_bwipeout(0)<CR>
    nnoremap <silent> <C-x>K     :<C-u>call <SID>smart_bwipeout(1)<CR>
    nnoremap <silent> <C-x><C-k> :<C-u>call <SID>smart_bwipeout(2)<CR>
    "nnoremap <silent> <C-x>k     :<C-u>silent call <SID>smart_bwipeout(0)<CR>:<C-u>call <SID>get_buflists()<CR>
    "nnoremap <silent> <C-x>K     :<C-u>silent call <SID>smart_bwipeout(1)<CR>:<C-u>call <SID>get_buflists()<CR>
    "nnoremap <silent> <C-x><C-k> :<C-u>silent call <SID>smart_bwipeout(2)<CR>:<C-u>call <SID>get_buflists()<CR>
endif


function! s:buf_delete(bang) "{{{1
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

" Delete the current buffer and the file.
command! -bang -nargs=0 -complete=buffer Delete call s:buf_delete(<bang>0)
nnoremap <silent> <C-x>d     :<C-u>Delete<CR>
nnoremap <silent> <C-x><C-d> :<C-u>Delete!<CR>

function! s:open(file) "{{{1
    if !g:env.bin.open
        return Error('open: not supported yet.')
    endif
    let file = empty(a:file) ? expand('%') : fnamemodify(a:file, ':p')
    call system(printf('%s %s &', 'open', shellescape(file)))
    return v:shell_error ? g:false : g:true
endfunction

command! -nargs=? -complete=file Open call <SID>open(<q-args>)
command! -nargs=0                Op   call <SID>open('.')

function! s:load_source(path) "{{{1
    let path = expand(a:path)
    if filereadable(path)
        execute 'source ' . path
    endif
endfunction
" Source file
command! -nargs=? Source call <SID>load_source(empty(<q-args>) ? expand('%:p') : <q-args>)

function! s:copy_current_path(...) "{{{1
    let path = a:0 ? expand('%:p:h') : expand('%:p')
    if IsWindows()
        let @* = substitute(path, '\\/', '\\', 'g')
    else
        let @* = path
    endif
    echo path
endfunction

" Get current file path
command! CopyCurrentPath call s:copy_current_path()
" Get current directory path
command! CopyCurrentDir call s:copy_current_path(1)
command! CopyPath CopyCurrentPath

function! s:make_junkfile() "{{{1
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

" Make the notitle file called 'Junk'.
command! -nargs=0 JunkFile call s:make_junkfile()

function! s:rename(new, type) "{{{1
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

" Rename the current editing file
command! -nargs=? -complete=file Rename call s:rename(<q-args>, 'file')

" Change the current editing file extention
if v:version >= 730
    command! -nargs=? -complete=filetype ReExt  call s:rename(<q-args>, 'ext')
else
    command! -nargs=?                    ReExt  call s:rename(<q-args>, 'ext')
endif

function! s:smart_execute(expr) "{{{1
    let wininfo = winsaveview()
    execute a:expr
    call winrestview(wininfo)
endfunction

" Remove EOL ^M
command! RemoveCr call s:smart_execute('silent! %substitute/\r$//g | nohlsearch')
" Remove EOL space
command! RemoveEolSpace call s:smart_execute('silent! %substitute/ \+$//g | nohlsearch')

function! s:smart_foldcloser() "{{{1
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
nnoremap <silent> <C-_> :<C-u>call <SID>smart_foldcloser()<CR>

function! s:win_tab_switcher(...) "{{{1
    " TODO: refactor
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
                        call Warn('Last tabpages')
                    endif
                endif
                if (is_split || is_vsplit) && winnr() == winnr('$')
                    if buffer_switcher
                        silent bnext
                    else
                        call Warn('Last tabpages')
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
                    call Warn('Last tabpages')
                endif
            endif
            if (is_split || is_vsplit) && winnr() == winnr('$')
                if buffer_switcher
                    silent bnext
                else
                    call Warn('Last tabpages')
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
                        call Warn('First tabpages')
                    endif
                endif
                if (is_split || is_vsplit) && winnr() == 1
                    if buffer_switcher
                        silent bprevious
                    else
                        call Warn('First tabpages')
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
                    call Warn('First tabpages')
                endif
            endif
            if (is_split || is_vsplit) && winnr() == 1
                if buffer_switcher
                    silent bprevious
                else
                    call Warn('First tabpages')
                endif
            else
                silent wincmd W
            endif
        endif
    endif

    if g:plug.is_installed('vim-buftabs')
    else
        redraw
        call <SID>get_buflists()
    endif
endfunction

nnoremap <silent> <C-l> :<C-u>call <SID>win_tab_switcher('l')<CR>
nnoremap <silent> <C-h> :<C-u>call <SID>win_tab_switcher('h')<CR>

" Add execute permission {{{1
if g:env.vimrc.add_execute_perm == g:true
    if g:env.bin.chmod
        augroup auto-add-executable
            autocmd!
            autocmd BufWritePost * call <SID>add_permission_x()
        augroup END

        function! s:add_permission_x()
            let file = expand('%:p')
            if !executable(file)
                if getline(1) =~# '^#!'
                            \ || &filetype =~ "\\(z\\|c\\|ba\\)\\?sh$"
                            \ && input(printf('"%s" is not perm 755. Change mode? [y/N] ', expand('%:t'))) =~? '^y\%[es]$'
                    call system("chmod 755 " . shellescape(file))
                    redraw | echo "Set permission 755!"
                endif
            endif
        endfunction
    endif
endif

" Backup automatically {{{1
if IsWindows()
    set nobackup
else
    set backup
    call Mkdir('~/.vim/backup')
    augroup backup-files-automatically
        autocmd!
        autocmd BufWritePre * call s:backup_files()
    augroup END

    function! s:backup_files()
        let dir = strftime("~/.backup/vim/%Y/%m/%d", localtime())
        if !isdirectory(dir)
            call system("mkdir -p " . dir)
            call system("chown goth:staff " . dir)
        endif
        execute "set backupdir=" . dir
        execute "set backupext=." . strftime("%H_%M_%S", localtime())
    endfunction
endif

" Restore cursor position {{{1
if g:env.vimrc.restore_cursor_position == g:true
    function! s:restore_cursor_postion()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction
    augroup restore-cursor-position
        autocmd!
        autocmd BufWinEnter * call <SID>restore_cursor_postion()
    augroup END
endif

" Restore the buffer that has been deleted {{{1
let s:bufqueue = []
augroup buffer-queue-restore
    autocmd!
    "autocmd BufDelete * call <SID>buf_enqueue(expand('#'))
augroup END

" Automatically get buffer list {{{1
if !g:plug.is_installed('vim-buftabs')
    augroup bufenter-get-buffer-list
        autocmd!
        " Escape getting buflist by "@% != ''" when "VimEnter"
        autocmd BufEnter,BufAdd,BufWinEnter * if @% != '' | call <SID>get_buflists() | endif
    augroup END
endif

" Automatically cd parent directory when opening the file {{{1
function! s:cd_file_parentdir()
    execute ":lcd " . expand("%:p:h")
endfunction
command! Cdcd call <SID>cd_file_parentdir()
nnoremap Q :<C-u>call <SID>cd_file_parentdir()<CR>

if g:env.vimrc.auto_cd_file_parentdir == g:true
    augroup cd-file-parentdir
        autocmd!
        autocmd BufRead,BufEnter * call <SID>cd_file_parentdir()
    augroup END
endif

" QuickLook for mac {{{1
if IsMac() && !g:env.bin.qlmanage
    command! -nargs=? -complete=file QuickLook call s:quicklook(<f-args>)
    function! s:quicklook(...)
        let file = a:0 ? expand(a:1) : expand('%:p')
        if !s:has(file)
            echo printf('%s: No such file or directory', file)
            return 0
        endif
        call system(printf('qlmanage -p %s >& /dev/null', shellescape(file)))
    endfunction
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
