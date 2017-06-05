if !exists('g:env')
    finish
endif

if g:plug.is_installed('enhancd') "{{{1
    let g:enhancd_action = g:plug.is_installed('dirvish') ? 'Dirvish' : 'Ex'
endif

if g:plug.is_installed('caw') "{{{1
    vmap <C-k> <Plug>(caw:i:toggle)
    vmap K     <Plug>(caw:i:toggle)
endif

if g:plug.is_installed('anzu') "{{{1
    nmap n <Plug>(anzu-n)
    nmap N <Plug>(anzu-N)
    nmap * <Plug>(anzu-star)
    nmap # <Plug>(anzu-sharp)
    nmap n <Plug>(anzu-n-with-echo)
    nmap N <Plug>(anzu-N-with-echo)
    nmap * <Plug>(anzu-star-with-echo)
    nmap # <Plug>(anzu-sharp-with-echo)

    augroup vim-anzu
        autocmd!
        autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
    augroup END
endif

if g:plug.is_installed('fzf.vim') "{{{1
    let g:fzf_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'tab split',
                \ 'ctrl-v': 'tab split' }

    function! s:search_with_ag_under_cursor()
        let g:env.vimrc.auto_cd_file_parentdir = g:false
        let cwd = expand('%:p:h')
        silent! call s:root()

        call fzf#vim#ag(expand('<cword>'), {
                    \ 'sink': 'edit',
                    \ 'options': '--ansi --delimiter : --nth 4..,.. --prompt "Ag?> " '.
                    \            '--color hl:68,hl+:110 --multi '.
                    \            '--bind=ctrl-d:page-down,ctrl-u:page-up ',
                    \ 'tmux_height': '40%',
                    \ })
        "execute 'lcd' cwd
        execute 'lcd' expand('%:p:h')
        let g:env.vimrc.auto_cd_file_parentdir = g:true
    endfunction
    nnoremap <silent> K :call <SID>search_with_ag_under_cursor()<CR>

    nnoremap <silent> <Leader>m :call fzf#run({
                \ 'source': 'sed "1d" $HOME/.vim_mru_files',
                \ 'options' : '+s -e -m',
                \ 'tmux_height': '40%',
                \ 'sink': 'tabe'
                \ })<CR>
endif

if g:plug.is_installed('vim-dirvish') "{{{1
    " Override netrw
    let g:dirvish_hijack_netrw = 1

    augroup my_dirvish_events
        au!
        " always show hidden files
        au User DirvishEnter let b:dirvish.showhidden = 1
    augroup END

    nnoremap <silent> [Space]d :<C-u>call <SID>toggle_dirvish()<CR>
    function! s:toggle_dirvish()
        if &filetype == 'dirvish'
            if exists('b:dirvish')
                if winnr('$') > 1
                    wincmd c
                else
                    bdelete
                endif
            endif
        else
            Dirvish
        endif
    endfunction
endif

if g:plug.is_installed('neocomplete.vim') "{{{1
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_camel_case = 1
    let g:neocomplete#enable_underbar_completion = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#auto_completion_start_length = 2
    let g:neocomplete#manual_completion_start_length = 0
    let g:neocomplete#min_keyword_length = 3
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:jedi#auto_vim_configuration = 0
    let g:neocomplete#sources#omni#input_patterns = {
                \ 'ruby' : '[^. *\t]\.\w*\|\h\w*::',
                \}
    let g:neocomplete#force_omni_input_patterns = {
                \ 'python': '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
                \}

    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#disable_auto_select_buffer_name_pattern =
                \ '\[Command Line\]'
    let g:neocomplete#max_list = 100
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#enable_auto_close_preview = 1

    let g:neocomplete#force_omni_input_patterns.markdown =
                \ ':\w*'
    let g:neocomplete#force_omni_input_patterns.ruby =
                \ '[^. *\t]\.\w*\|\h\w*::\w*'

    let g:neocomplete#force_omni_input_patterns.python =
                \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

    let g:neocomplete#sources#omni#functions.go =
                \ 'gocomplete#Complete'

    let g:neocomplete#sources#omni#input_patterns.php =
                \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    "if !exists('g:neocomplete#keyword_patterns')
    "  let g:neocomplete#keyword_patterns = {}
    "endif
    "let g:neocomplete#keyword_patterns._ = '\h\w*'
    "let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'
    "let g:neocomplete#keyword_patterns.rst =
    "      \ '\$\$\?\w*\|[[:alpha:]_.\\/~-][[:alnum:]_.\\/~-]*\|\d\+\%(\.\d\+\)\+'

    "let g:neocomplete#ignore_source_files = []

    "let g:neocomplete#enable_at_startup = 1
    "let g:neocomplete#disable_auto_complete = 0
    "let g:neocomplete#enable_smart_case = 1
    "let g:neocomplete#enable_camel_case = 1
    "let g:neocomplete#enable_fuzzy_completion = 1
    "let g:neocomplete#auto_completion_start_length = 2
    "let g:neocomplete#manual_completion_start_length = 0
    "let g:neocomplete#min_keyword_length = 3
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#enable_cursor_hold_i = 0

    "let g:neocomplete#enable_auto_delimiter = 1
    "let g:neocomplete#disable_auto_select_buffer_name_pattern =
    "      \ '\[Command Line\]'
    "let g:neocomplete#max_list = 100
    "if !exists('g:neocomplete#sources#omni#input_patterns')
    "  let g:neocomplete#sources#omni#input_patterns = {}
    "endif
    "if !exists('g:neocomplete#sources#omni#functions')
    "  let g:neocomplete#sources#omni#functions = {}
    "endif
    "if !exists('g:neocomplete#force_omni_input_patterns')
    "  let g:neocomplete#force_omni_input_patterns = {}
    "endif
    "let g:neocomplete#enable_auto_close_preview = 1

    "let g:neocomplete#force_omni_input_patterns.markdown =
    "      \ ':\w*'
    "let g:neocomplete#force_omni_input_patterns.ruby =
    "      \ '[^. *\t]\.\w*\|\h\w*::\w*'

    "let g:neocomplete#force_omni_input_patterns.python =
    "      \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

    "let g:neocomplete#sources#omni#functions.go =
    "      \ 'gocomplete#Complete'

    "let g:neocomplete#sources#omni#input_patterns.php =
    "      \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    "if !exists('g:neocomplete#keyword_patterns')
    "  let g:neocomplete#keyword_patterns = {}
    "endif
    "let g:neocomplete#keyword_patterns._ = '\h\w*'
    "let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'
    "let g:neocomplete#keyword_patterns.rst =
    "      \ '\$\$\?\w*\|[[:alpha:]_.\\/~-][[:alnum:]_.\\/~-]*\|\d\+\%(\.\d\+\)\+'

    "let g:neocomplete#ignore_source_files = []

    "let g:neocomplete#sources#vim#complete_functions = {
    "      \ 'Emoji' : 'emoji#complete',
    "      \ 'Ref' : 'ref#complete',
    "      \ 'Unite' : 'unite#complete_source',
    "      \ 'VimShellExecute' :
    "      \      'vimshell#vimshell_execute_complete',
    "      \ 'VimShellInteractive' :
    "      \      'vimshell#vimshell_execute_complete',
    "      \ 'VimShellTerminal' :
    "      \      'vimshell#vimshell_execute_complete',
    "      \ 'VimShell' : 'vimshell#complete',
    "      \ 'VimFiler' : 'vimfiler#complete',
    "      \ 'Vinarise' : 'vinarise#complete',
    "      \}
    ""call neocomplete#custom#source('look', 'min_pattern_length', 4)

    "" mappings."{{{
    "" <C-f>, <C-b>: page move.
    "inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
    "inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
    "" <C-h>, <BS>: close popup and delete backword char.
    ""inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
    ""inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
    "" <C-n>: neocomplete.
    "inoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
    "" <C-p>: keyword completion.
    "inoremap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
    "inoremap <expr> '  pumvisible() ? "\<C-y>" : "'"

    "inoremap <silent><expr> <C-x><C-f>
    "      \ neocomplete#start_manual_complete('file')

    "inoremap <expr> <C-g>     neocomplete#undo_completion()
    "inoremap <expr> <C-l>     neocomplete#complete_common_string()

    "" <CR>: close popup and save indent.
    ""inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    ""function! s:my_cr_function()
    ""  return neocomplete#smart_close_popup() . "\<CR>"
    ""endfunction

    "" <TAB>: completion.
    "inoremap <silent><expr> <TAB>
    "      \ pumvisible() ? "\<C-n>" :
    "      \ <SID>check_back_space() ? "\<TAB>" :
    "      \ neocomplete#start_manual_complete()
    "function! s:check_back_space() "{{{
    "  let col = col('.') - 1
    "  return !col || getline('.')[col - 1]  =~ '\s'
    "endfunction"}}}
    "" <S-TAB>: completion back.
    "inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

    "" For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    ""}}}

    let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]
endif

if g:plug.is_installed('mru.vim') "{{{1
    let MRU_Auto_Close = 1
    let MRU_Window_Height = 30
    let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
    let MRU_Max_Entries = 1000
    nnoremap <silent> [Space]j :<C-u>MRU<CR>
else
    " MRU configuration variables {{{3
    if !exists('s:MRU_File')
        if has('unix') || has('macunix')
            let s:MRU_File = $HOME . '/.vim_mru_files'
        else
            let s:MRU_File = $VIM . '/_vim_mru_files'
            if has('win32')
                if $USERPROFILE != ''
                    let s:MRU_File = $USERPROFILE . '\_vim_mru_files'
                endif
            endif
        endif
    endif

    function! s:MRU_LoadList() "{{{3
        if filereadable(s:MRU_File)
            let s:MRU_files = readfile(s:MRU_File)
            if s:MRU_files[0] =~# '^#'
                call remove(s:MRU_files, 0)
            else
                let s:MRU_files = []
            endif
        else
            let s:MRU_files = []
        endif
    endfunction

    function! s:MRU_SaveList() "{{{3
        let l = []
        call add(l, '# Most recently used files list')
        call extend(l, s:MRU_files)
        call writefile(l, s:MRU_File)
    endfunction
    function! s:MRU_AddList(buf) "{{{3
        if s:mru_list_locked
            return
        endif

        let fname = fnamemodify(bufname(a:buf + 0), ':p')
        if fname == ''
            return
        endif

        if &buftype != ''
            return
        endif

        if index(s:MRU_files, fname) == -1
            if !filereadable(fname)
                return
            endif
        endif

        call s:MRU_LoadList()
        call filter(s:MRU_files, 'v:val !=# fname')
        call insert(s:MRU_files, fname, 0)

        "let s:MRU_Max_Entries = 100
        "if len(s:MRU_files) > s:MRU_Max_Entries
        " call remove(s:MRU_files, s:MRU_Max_Entries, -1)
        "endif

        call s:MRU_SaveList()

        let bname = '__MRU_Files__'
        let winnum = bufwinnr(bname)
        if winnum != -1
            let cur_winnr = winnr()
            call s:MRU_Create_Window()
            if winnr() != cur_winnr
                exe cur_winnr . 'wincmd w'
            endif
        endif
    endfunction

    function! s:MRU_RemoveList() "{{{3
        call s:MRU_LoadList()
        let lnum = line('.')
        call remove(s:MRU_files, line('.')-1)
        call s:MRU_SaveList()
        close
        call s:MRU_Create_Window()
        call cursor(lnum, 1)
    endfunction

    function! s:MRU_Open_File() range "{{{3
        for f in getline(a:firstline, a:lastline)
            if f == ''
                continue
            endif

            let file = substitute(f, '^.*| ','','')

            let winnum = bufwinnr('^' . file . '$')
            silent quit
            if winnum != -1
                return
            else
                if &filetype ==# 'mru'
                    silent quit
                endif
            endif

            exe 'edit ' . fnameescape(substitute(file, '\\', '/', 'g'))
        endfor
    endfunction

    function! s:MRU_Create_Window() "{{{3
        if &filetype == 'mru' && bufname("%") ==# '__MRU_Files__'
            quit
            return
        endif

        call s:MRU_LoadList()
        if empty(s:MRU_files)
            echohl WarningMsg | echo 'MRU file list is empty' | echohl None
            return
        endif

        let bname = '__MRU_Files__'
        let winnum = bufwinnr(bname)
        if winnum != -1
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif

            setlocal modifiable
            " Delete the contents of the buffer to the black-hole register
            silent! %delete _
        else
            " If the __MRU_Files__ buffer exists, then reuse it. Otherwise open
            " a new buffer
            let bufnum = bufnr(bname)
            if bufnum == -1
                let wcmd = bname
            else
                let wcmd = '+buffer' . bufnum
            endif
            let wcmd = bufnum == -1 ? bname : '+buffer' . bufnum
            let s:MRU_Window_Height = &lines / 3
            exe 'silent! botright ' . s:MRU_Window_Height . 'split ' . wcmd
        endif

        " Mark the buffer as scratch
        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal noswapfile
        setlocal nowrap
        setlocal nobuflisted
        setlocal filetype=mru
        setlocal winfixheight
        setlocal modifiable

        let old_cpoptions = &cpoptions
        set cpoptions&vim

        " Create mappings to select and edit a file from the MRU list
        nnoremap <buffer> <silent> <CR>   :call <SID>MRU_Open_File()<CR>
        vnoremap <buffer> <silent> <CR>   :call <SID>MRU_Open_File()<CR>
        nnoremap <buffer> <silent> <S-CR> :call <SID>MRU_Open_File_Tab()<CR>
        vnoremap <buffer> <silent> <S-CR> :call <SID>MRU_Open_File_Tab()<CR>
        nnoremap <buffer> <silent> K      :call <SID>MRU_RemoveList()<CR>
        nnoremap <buffer> <silent> S      :setlocal modifiable<CR>:sort<CR>:setlocal nomodifiable<CR>

        " Restore the previous cpoptions settings
        let &cpoptions = old_cpoptions

        let output = copy(s:MRU_files)
        let idx = 0
        for file in output
            if !filereadable(file)
                call remove(output, idx)
                continue
            endif
            let idx += 1
        endfor

        silent! 0put =output

        " Delete the empty line at the end of the buffer
        silent! $delete _
        let glist = getline(1, '$')
        let max = 0
        let max_h = 0
        for idx in range(0, len(glist)-1)
            if strlen(fnamemodify(glist[idx], ':t')) > max
                let max = strlen(fnamemodify(glist[idx], ':t'))
            endif
            if strlen(substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', '')) > max_h
                let max_h = strlen(substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', ''))
            endif
        endfor
        for idx in range(0, len(glist)-1)
            let glist[idx] = printf("%-" . max .  "s | %-" . max_h . "s | %s" ,
                        \ fnamemodify(glist[idx], ':t'), substitute(fnamemodify(glist[idx], ':p:h'), '^.*\/', '', ''), glist[idx])
        endfor
        silent! %delete _
        call setline(1, glist)
        if glist[idx] == '| '
            silent! $delete _
        endif

        exe 'syntax match Directory display ' . '"'. '|\zs[^|]*\ze|'. '"'
        exe 'syntax match Constant  display ' . '"' . '[^|]*[\/]' . '"'

        " Move the cursor to the beginning of the file
        normal! gg

        setlocal nonumber cursorline nomodifiable
    endfunction

    " MRU Essentials {{{3
    let s:mru_list_locked = 0
    call s:MRU_LoadList()
    command! MRU call s:MRU_Create_Window()
    augroup mru-files-vimrc
        autocmd!
        autocmd BufRead      * call s:MRU_AddList(expand('<abuf>'))
        autocmd BufNewFile   * call s:MRU_AddList(expand('<abuf>'))
        autocmd BufWritePost * call s:MRU_AddList(expand('<abuf>'))
        autocmd QuickFixCmdPre  *grep* let s:mru_list_locked = 1
        autocmd QuickFixCmdPost *grep* let s:mru_list_locked = 0
    augroup END

    " MRU within the vimrc
    "if !g:plug.is_installed('mru.vim') 
    if exists('*s:MRU_Create_Window')
        nnoremap <silent> [Space]j :<C-u>call <SID>MRU_Create_Window()<CR>
    endif
    "endif
endif

if g:plug.is_installed('vim-sqlfmt') "{{{1
    let g:sqlfmt_command = "sqlformat"
    let g:sqlfmt_options = "-r -k upper"
    let g:sqlfmt_auto = true
endif

if g:plug.is_installed('syntastic') " {{{1
    let g:syntastic_mode_map = { 'mode': 'passive',
                \ 'active_filetypes': ['go'] }
    let g:syntastic_go_checkers = ['go', 'golint']
endif

if g:plug.is_installed('') " {{{1
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
