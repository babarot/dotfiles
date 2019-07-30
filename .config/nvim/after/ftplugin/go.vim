setlocal noexpandtab

" automatically run gofmt
" augroup custom-ftplugin-go
"   autocmd! * <buffer>
"   if executable('gofmt')
"     autocmd BufWritePre <buffer> call s:format()
"   endif
" augroup END
"
" function! s:format()
"   let cursor = getpos('.')
"   silent! %!gofmt
"   if v:shell_error
"     let error = join(getline(1, '$'), "\n")
"     undo
"   endif
"   call setpos('.', cursor)
" endfunction

set completeopt-=preview

augroup goautocmd
  autocmd!
  autocmd BufWritePre *.go :GoImports
augroup END

let g:go_fmt_command = "goimports"

let g:go_gocode_unimported_packages = 1

let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_generate_tags = 1

set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
