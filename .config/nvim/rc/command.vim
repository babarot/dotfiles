if !exists('g:env')
    finish
endif

" In particular effective when I am garbled in a terminal
command! -bang -bar -complete=file -nargs=? Utf8      edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932     edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc       edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16     edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be   edit<bang> ++enc=ucs-2 <args>
command! -bang -bar -complete=file -nargs=? Jis       Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis      Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode   Utf16<bang> <args>

" Tried to make a file note version
" Don't save it because dangerous.
command! WUtf8      setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932     setlocal fenc=cp932
command! WEuc       setlocal fenc=euc-jp
command! WUtf16     setlocal fenc=ucs-2le
command! WUtf16be   setlocal fenc=ucs-2
command! WJis       WIso2022jp
command! WSjis      WCp932
command! WUnicode   WUtf16

" Appoint a line feed
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos  write<bang> ++fileformat=dos <args>  | edit <args>
command! -bang -complete=file -nargs=? WMac  write<bang> ++fileformat=mac <args>  | edit <args>

" Make random string such as password
command! -nargs=? Random echo Random(<q-args>)

command! RemoveBlankLine silent! global/^$/delete | nohlsearch | normal! ``

" Measure fighting strength of Vim.
command! -bar -bang -nargs=? -complete=file Scouter echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)

" Ls like a shell-ls
command! -nargs=? -bang -complete=file Ls call s:ls(<q-args>, <q-bang>)

" Show all runtimepaths.
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

" View all mappings
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>

" Handle buffers {{{2
" Wipeout all buffers
command! -nargs=0 AllBwipeout call s:all_buffers_bwipeout()

" Get buffer queue list for restore
command! -nargs=0 BufQueue echo len(s:bufqueue)
            \ ? reverse(split(substitute(join(s:bufqueue, ' '), $HOME, '~', 'g')))
            \ : "No buffers in 's:bufqueue'."

" Get buffer list like ':ls'
command! -nargs=0 BufList call s:get_buflists()

" Smart bnext/bprev
command! Bnext call s:smart_bchange('n')
command! Bprev call s:smart_bchange('p')

" Show buffer kind.
command! -bar EchoBufKind setlocal bufhidden? buftype? swapfile? buflisted?

" Open new buffer or scratch buffer with bang.
command! -bang -nargs=? -complete=file BufNew call <SID>bufnew(<q-args>, <q-bang>)

" Bwipeout(!) for all-purpose.
command! -nargs=0 -bang Bwipeout call <SID>smart_bwipeout(0, <q-bang>)


" Handle tabpages {{{2
" Make tabpages
command! -nargs=? TabNew call s:tabnew(<q-args>)

"Open again with tabpages
command! -nargs=? Tab call s:tabdrop(<q-args>)

" Open the buffer again with tabpages
command! -nargs=? -complete=buffer ROT call <SID>recycle_open('tabedit', empty(<q-args>) ? expand('#') : expand(<q-args>))


" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
