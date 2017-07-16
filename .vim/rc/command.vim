if !exists('g:config')
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

command! RemoveBlankLine silent! global/^$/delete | nohlsearch | normal! ``

" Show all runtimepaths.
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

" View all mappings
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>

" Show buffer kind.
command! -bar EchoBufKind setlocal bufhidden? buftype? swapfile? buflisted?

command! -nargs=? -complete=file Open call rc#misc#open(<q-args>)
command! -nargs=0                Op   call rc#misc#open('.')

command! CopyCurrentPath call rc#misc#copy_current_path()
command! CopyCurrentDir  call rc#misc#copy_current_path(1)
command! CopyPath CopyCurrentPath

command! -nargs=0 JunkFile call rc#misc#junkfile()

command! -nargs=? -complete=file Rename call rc#misc#rename(<q-args>, 'file')
if v:version >= 730
  command! -nargs=? -complete=filetype ReExt  call rc#misc#rename(<q-args>, 'ext')
else
  command! -nargs=?                    ReExt  call rc#misc#rename(<q-args>, 'ext')
endif

" Remove EOL ^M
command! RemoveCr call rc#misc#smart_execute('silent! %substitute/\r$//g | nohlsearch')
" Remove EOL space
command! RemoveEolSpace call rc#misc#smart_execute('silent! %substitute/ \+$//g | nohlsearch')

" Delete the current buffer and the file.
command! -bang -nargs=0 -complete=buffer Delete call rc#buf#delete(<bang>0)
nnoremap <silent> <C-x>d     :<C-u>Delete<CR>
nnoremap <silent> <C-x><C-d> :<C-u>Delete!<CR>

nnoremap <silent> <C-_> :<C-u>call rc#misc#smart_foldcloser()<CR>
