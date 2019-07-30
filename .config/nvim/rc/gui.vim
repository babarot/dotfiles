if !exists('g:env')
    finish
endif

autocmd GUIEnter * call s:gui()
function! s:gui()
    set background=dark
    if g:plug.is_installed('seoul256')
        colorscheme seoul256
    endif

    set columns=150
    set lines=50
    language C

    "colorscheme solarized
    "set background=light
    syntax enable

    " Tabpages
    set guitablabel=%{GuiTabLabel()}

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

    " Change cursor color if IME works.
    if has('multi_byte_ime') || has('xim')
        highlight Cursor guibg=NONE guifg=Yellow
        highlight CursorIM guibg=NONE guifg=Red
        set iminsert=0 imsearch=0
        if has('xim') && has('GUI_GTK')
            ""set imactivatekey=s-space
        endif
        inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
    endif
endfunction

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
