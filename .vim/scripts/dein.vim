if !exists('g:env')
    finish
endif

" Load dein.
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
        let s:dein_dir = expand('$HOME/.dein')
                    \. '/repos/github.com/Shougo/dein.vim'
        if !isdirectory(s:dein_dir)
            execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
        endif
    endif
    execute ' set runtimepath^=' . substitute(
                \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" dein configurations.

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1
let g:dein#notification_icon = '~/.vim/signs/warn.png'

let s:path = expand('$HOME/.dein')
if !dein#load_state(s:path)
    finish
endif

call dein#begin(s:path, [expand('<sfile>')]
            \ + split(glob('~/.vim/scripts/*.toml'), '\n'))

call dein#load_toml(
            \ '~/.vim/scripts/dein.toml',
            \ {'lazy': 0}
            \ )
call dein#load_toml('~/.vim/scripts/dein_lazy.toml', {'lazy' : 1})

"if has('nvim')
"  call dein#load_toml('~/.vim/rc/deineo.toml', {})
"endif
"call dein#load_toml('~/.vim/rc/deinft.toml')
"
"let s:vimrc_local = findfile('vimrc_local.vim', '.;')
"if s:vimrc_local !=# ''
"  " Load develop version plugins.
"  call dein#local(fnamemodify(s:vimrc_local, ':h'),
"        \ {'frozen': 1, 'merged': 0},
"        \ ['vim*', 'unite-*', 'neco-*', '*.vim'])
"  if has('nvim')
"    call dein#local(fnamemodify(s:vimrc_local, ':h'),
"          \ {'frozen': 1, 'merged': 0},
"          \ ['deoplete-*', '*.nvim'])
"  endif
"endif
"
"if dein#tap('deoplete.nvim') && has('nvim')
"  call dein#disable('neocomplete.vim')
"endif
"call dein#disable('neobundle.vim')
"call dein#disable('neopairs.vim')

call dein#end()
call dein#save_state()

if dein#check_install()
    " Installation check.
    call dein#install()
endif
