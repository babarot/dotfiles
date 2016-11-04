if !exists('g:env')
    finish
endif

"if g:env.is_tmux_running
"  augroup titlesettings
"    autocmd!
"    autocmd BufEnter * call system("tmux rename-window " . "'[vim] " . expand("%:t") . "'")
"    autocmd VimLeave * call system("tmux rename-window ".g:env.tmux_proc)
"    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
"  augroup END
"endif

autocmd GUIEnter * call s:gui()

function! s:gui()
    "colorscheme solarized
    "set background=light
    syntax enable

    " Tabpages
    set guitablabel=%{GuiTabLabel()}

    " Change cursor color if IME works.
    if has('multi_byte_ime') || has('xim')
        "highlight Cursor   guibg=NONE guifg=Yellow
        "highlight CursorIM guibg=NONE guifg=Red
        set iminsert=0 imsearch=0
        inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
    endif
    "autocmd VimEnter,ColorScheme * highlight Cursor   guibg=Yellow guifg=Black
    "autocmd VimEnter,ColorScheme * highlight CursorIM guibg=Red    guifg=Black
    autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight Cursor   guibg=Yellow guifg=Black | endif
    autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight CursorIM guibg=Red    guifg=Black | endif
    autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight Cursor   guibg=Black  guifg=NONE  | endif
    autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight CursorIM guibg=Red    guifg=Black | endif
    inoremap <silent> <ESC><ESC>:set iminsert=0<CR>

    " Remove all menus.
    try
        source $VIMRUNTIME/delmenu.vim
    catch
    endtry

    " Font
    if IsMac()
        set guifont=Andale\ Mono:h12
    endif
endfunction

autocmd MyAutoCmd BufReadPost *
            \ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
            \ | setlocal fileencoding=
            \ | endif

nmap <silent> gZZ :set t_te= t_ti= <cr>:quit<cr>:set t_te& t_ti&<cr>
nmap <silent> gsh :set t_te= t_ti= <cr>:sh<cr>:set t_te& t_ti&<cr>

" GUI IME Cursor colors
if has('multi_byte_ime') || has('xim')
    highlight Cursor guibg=NONE guifg=Yellow
    highlight CursorIM guibg=NONE guifg=Red
    set iminsert=0 imsearch=0
    if has('xim') && has('GUI_GTK')
        ""set imactivatekey=s-space
    endif
    inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
