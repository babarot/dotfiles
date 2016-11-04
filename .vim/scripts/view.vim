if !exists('g:env')
    finish
endif

syntax enable on
set number

if g:env.is_gui
    set background=light
else
    set background=dark
endif

set t_Co=256
if g:plug.is_installed('solarized.vim') && $TERM_PROGRAM ==# "Apple_Terminal"
    colorscheme solarized
elseif g:plug.is_installed('seoul256')
    colorscheme seoul256
elseif g:plug.is_installed('hybrid')
    colorscheme hybrid
endif

" StatusLine {{{1
set laststatus=2

highlight BlackWhite ctermfg=black ctermbg=white cterm=none guifg=black guibg=white gui=none
highlight WhiteBlack ctermfg=white ctermbg=black cterm=none guifg=white guibg=black gui=none

function! MakeStatusLine()
    let line = ''
    let line .= '[%n] '
    let line .= '%f'
    let line .= ' %m'
    let line .= '%<'

    let line .= '%='
    let line .= '%#BlackWhite#'
    let line .= '%y'
    let line .= "[%{(&fenc!=#''?&fenc:&enc).(&bomb?'(BOM)':'')}:"
    let line .= "%{&ff.(&bin?'(BIN'.(&eol?'':'-noeol').')':'')}]"
    let line .= '%r'
    let line .= '%h'
    let line .= '%w'
    let line .= ' %l/%LL %2vC'
    let line .= ' %3p%%'

    if g:env.vimrc.statusline_manually == g:true
        return line
    else
        return ''
    endif
endfunction

function! MakeBigStatusLine()
    if g:env.vimrc.statusline_manually == g:true
        set statusline=
        set statusline+=%#BlackWhite#
        set statusline+=[%n]:
        if filereadable(expand('%'))
            set statusline+=%{GetBufname(bufnr('%'),'s')}
        else
            set statusline+=%F
        endif
        set statusline+=\ %m
        set statusline+=%#StatusLine#

        set statusline+=%=
        set statusline+=%#BlackWhite#
        if exists('*TrailingSpaceWarning')
            "set statusline+=%{TrailingSpaceWarning()}
        endif
        set statusline+=%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
        set statusline+=%r
        set statusline+=%h
        set statusline+=%w
        if exists('*GetFileSize')
            set statusline+=[%{GetFileSize()}]
        endif
        if exists('*GetCharacterCode')
            set statusline+=[%{GetCharacterCode()}]
        endif
        set statusline+=\ %4l/%4LL,%3cC\ %3p%%
        if exists('*WordCount')
            set statusline+=\ [WC=%{WordCount()}]
        endif
        if exists('*GetDate')
            set statusline+=\ (%{GetDate()})
        endif
    endif
endfunction

if !g:plug.is_installed('lightline.vim')
    call MakeBigStatusLine()
    if g:env.vimrc.statusline_manually == g:true
        " Refresh Manually StatusLine
        augroup automatically-statusline
            autocmd!
            autocmd BufEnter * call MakeBigStatusLine()
        augroup END
    endif

    augroup minimal-statusline
        autocmd!
        autocmd WinEnter,CursorMoved * if winwidth(0) <  &columns | set statusline=%!MakeStatusLine() | endif
    augroup END
endif

" Tabpages {{{1
set showtabline=2
set tabline=%!MakeTabLine()

function! s:tabpage_label(n) "{{{3
    let n = a:n
    let bufnrs = tabpagebuflist(n)
    let curbufnr = bufnrs[tabpagewinnr(n) - 1]

    let hi = n == tabpagenr() ? 'TabLineSel' : 'TabLine'

    let label = ''
    let no = len(bufnrs)
    if no == 1
        let no = ''
    endif
    let mod = len(filter(bufnrs, 'getbufvar(v:val, "&modified")')) ? '+' : ''
    let sp = (no . mod) ==# '' ? '' : ' '
    let fname = GetBufname(curbufnr, 's')

    if no !=# ''
        let label .= '%#' . hi . 'Number#' . no
    endif
    let label .= '%#' . hi . '#'
    let label .= fname . sp . mod

    return '%' . a:n . 'T' . label . '%T%#TabLineFill#'
endfunction

function! MakeTabLine() "{{{3
    let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
    let sep = ' | '
    let tabs = join(titles, sep) . sep . '%#TabLineFill#%T'

    "hi TabLineFill ctermfg=white
    let info = '%#TabLineFill#'
    let info .= fnamemodify(getcwd(), ':~') . ' '
    return tabs . '%=' . info
endfunction

function! GuiTabLabel() "{{{3
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Append the tab number
    "let label .= v:lnum.': '
    " Append the buffer name
    let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    if name == ''
        " give a name to no-name documents
        if &buftype=='quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[No Name]'
        endif
    else
        " get only the file name
        let name = fnamemodify(name,":t")
    endif
    "let label .= name
    let label .= GetBufname('%', 't')
    " Append the number of windows in the tab page
    let wincount = tabpagewinnr(v:lnum, '$')

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in l:bufnrlist
        if getbufvar(bufnr, "&modified")
            let l:label .= ' +'
            break
        endif
    endfor
    let wincount = wincount == 1 ? '' : wincount . ' '

    ""return label . '  [' . wincount . ']'
    return wincount . label
endfunction "}}}

" Emphasize statusline in the insert mode {{{1
if !g:plug.is_installed('lightline.vim')
    augroup colorize-statusline-insert
        autocmd!
        autocmd InsertEnter * call s:colorize_statusline_insert('Enter')
        autocmd InsertLeave * call s:colorize_statusline_insert('Leave')
    augroup END

    function! ReverseHighlight(hi)
        let hl = a:hi
        let hl = substitute(hl, 'fg', 'swp', 'g')
        let hl = substitute(hl, 'bg', 'fg',  'g')
        let hl = substitute(hl, 'swp', 'bg', 'g')
        return hl
    endfunction
    function! GetHighlight(hi)
        redir => hl
        silent execute 'highlight ' . a:hi
        redir END
        return substitute(hl, '.*xxx ', '', '')
    endfunction

    let s:hi_insert = 'highlight StatusLine ' . ReverseHighlight(GetHighlight('ModeMsg'))
    let s:slhlcmd = ''

    function! s:colorize_statusline_insert(mode)
        if a:mode == 'Enter'
            let s:slhlcmd = 'highlight StatusLine ' . GetHighlight('StatusLine')
            silent execute s:hi_insert

        elseif a:mode == 'Leave'
            highlight clear StatusLine
            silent execute s:slhlcmd
        endif
    endfunction

endif

" Cursor line/column {{{1
set cursorline
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

augroup multi-window-toggle-cursor "{{{1
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline nocursorcolumn
augroup END 

augroup cursor-highlight-emphasis "{{{1
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinLeave * hi! link CursorLine CursorLine | hi! link CursorColumn CursorColumn
    autocmd CursorHold,CursorHoldI            * hi! link CursorLine Visual     | hi! link CursorColumn Visual
augroup END

" ZEN-KAKU
" Display zenkaku-space {{{1
augroup hilight-idegraphic-space
    autocmd!
    "autocmd VimEnter,ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    "autocmd WinEnter * match IdeographicSpace /　/
    autocmd VimEnter,ColorScheme * call <SID>hl_trailing_spaces()
    autocmd VimEnter,ColorScheme * call <SID>hl_zenkaku_space()
augroup END

function! s:hl_trailing_spaces()
    highlight! link TrailingSpaces Error
    syntax match TrailingSpaces containedin=ALL /\s\+$/
endfunction

function! s:hl_zenkaku_space()
    highlight! link ZenkakuSpace Error
    syntax match ZenkakuSpace containedin=ALL /　/
endfunction

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
