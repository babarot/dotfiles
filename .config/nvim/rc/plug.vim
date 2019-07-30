let g:plug = {
    \ "plug":   expand(g:env.path.vim) . "/autoload/plug.vim",
    \ "base":   expand(g:env.path.vim) . "/plugged",
    \ "url":    "https://raw.github.com/junegunn/vim-plug/master/plug.vim",
    \ "github": "https://github.com/junegunn/vim-plug",
    \ }

function! g:plug.ready()
    return filereadable(self.plug)
endfunction

if g:plug.ready()
    call plug#begin(g:plug.base)

    Plug 'natebosch/vim-lsc'
    Plug 'neoclide/coc.nvim'
    "Plug 'prabirshrestha/async.vim'
    "Plug 'prabirshrestha/asyncomplete-lsp.vim'
    "Plug 'prabirshrestha/asyncomplete.vim'
    "Plug 'prabirshrestha/vim-lsp'
    "let g:lsp_async_completion = 1

    " file and directory
    Plug 'AndrewRadev/gapply.vim'
    Plug 'Dkendal/fzy-vim'
    Plug 'aliou/bats.vim'
    Plug 'b4b4r07/mru.vim'
    Plug 'b4b4r07/vim-ansible-vault'
    Plug 'b4b4r07/vim-crowi'
    Plug 'b4b4r07/vim-hcl'
    Plug 'b4b4r07/vim-shellutils'
    Plug 'b4b4r07/vim-sqlfmt'
    Plug 'b4b4r07/vim-unicode'
    Plug 'chrisbra/csv.vim'
    Plug 'christianrondeau/vim-base64'
    Plug 'cocopon/vaffle.vim'
    Plug 'fatih/vim-hclfmt'
    Plug 'haya14busa/vim-gofmt'
    Plug 'hotwatermorning/auto-git-diff'
    Plug 'juliosueiras/vim-terraform-completion'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'justinmk/vim-dirvish'
    Plug 'juvenn/mustache.vim'
    Plug 'kylef/apiblueprint.vim'
    Plug 'lambdalisue/vim-gista'
    Plug 'lepture/vim-jinja'
    Plug 'mattn/gist-vim'
    Plug 'mattn/goplayground-vim'
    Plug 'mattn/vim-terminal'
    Plug 'mattn/webapi-vim'
    Plug 'mattn/webapi-vim'
    Plug 'millermedeiros/vim-esformatter'
    Plug 'osyo-manga/vim-anzu'
    Plug 'raphael/vim-present-simple'
    Plug 'raphael/vim-present-simple'
    Plug 'thinca/vim-quickrun'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-surround'
    Plug 'tweekmonster/fzf-filemru'
    Plug 'tyru/caw.vim'
    Plug 'tyru/open-browser-github.vim'
    Plug 'tyru/open-browser.vim'
    Plug 'vim-jp/vimdoc-ja'
    Plug 'w0rp/ale'

    " syntax? language support
    Plug 'b4b4r07/vim-ltsv', { 'for': 'ltsv' }
    Plug 'cespare/vim-toml', { 'for': 'toml' }
    Plug 'chase/vim-ansible-yaml'
    Plug 'dag/vim-fish', { 'for': 'fish' }
    Plug 'elzr/vim-json', { 'for': 'json' }
    Plug 'fatih/vim-go', { 'for': 'go' }
    Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
    Plug 'jnwhiteh/vim-golang', { 'for': 'go' }
    Plug 'keith/tmux.vim', { 'for': 'tmux' }
    Plug 'maksimr/vim-jsbeautify', { 'for': 'javascript' }
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    Plug 'rhysd/vim-fixjson', { 'for': 'json' }
    Plug 'zaiste/tmux.vim', { 'for': 'tmux' }
    Plug 'zplug/vim-zplug', { 'for': 'zplug' }

    " colorscheme
    Plug 'AlessandroYorba/Despacio'
    Plug 'arcticicestudio/nord-vim'
    Plug 'b4b4r07/solarized.vim'
    Plug 'chriskempson/vim-tomorrow-theme'
    Plug 'cocopon/iceberg.vim'
    Plug 'junegunn/seoul256.vim'
    Plug 'morhetz/gruvbox'
    Plug 'nanotech/jellybeans.vim'
    Plug 'nightsense/snow'
    Plug 'nightsense/stellarized'
    Plug 'tomasr/molokai'
    Plug 'tyrannicaltoucan/vim-deep-space'
    Plug 'w0ng/vim-hybrid'
    Plug 'whatyouhide/vim-gotham'
    Plug 'yuttie/hydrangea-vim'

    " Add plugins to &runtimepath
    call plug#end()
endif

" Add plug's plugins
let g:plug.plugs = get(g:, 'plugs', {})
let g:plug.list  = keys(g:plug.plugs)

if !g:plug.ready()
    function! g:plug.init()
        let ret = system(printf("curl -fLo %s --create-dirs %s", self.plug, self.url))
        "call system(printf("git clone %s", self.github))
        if v:shell_error
            return Error('g:plug.init: error occured')
        endif

        " Restart vim
        if !g:env.is_gui
            silent! !vim
            quit!
        endif
    endfunction
    command! PlugInit call g:plug.init()

    if g:env.vimrc.suggest_neobundleinit == g:true
        autocmd! VimEnter * redraw
                    \ | echohl WarningMsg
                    \ | echo "You should do ':PlugInit' at first!"
                    \ | echohl None
    else
        " Install vim-plug
        PlugInit
    endif
endif

function! g:plug.is_installed(strict, ...)
    let list = []
    if type(a:strict) != type(0)
        call add(list, a:strict)
    endif
    let list += a:000

    for arg in list
        let name   = substitute(arg, '^vim-\|\.vim$', "", "g")
        let prefix = "vim-" . name
        let suffix = name . ".vim"

        if a:strict == 1
            let name   = arg
            let prefix = arg
            let suffix = arg
        endif

        if has_key(self.plugs, name)
                    \ ? isdirectory(self.plugs[name].dir)
                    \ : has_key(self.plugs, prefix)
                    \ ? isdirectory(self.plugs[prefix].dir)
                    \ : has_key(self.plugs, suffix)
                    \ ? isdirectory(self.plugs[suffix].dir)
                    \ : g:false
            continue
        else
            return g:false
        endif
    endfor

    return g:true
endfunction

function! g:plug.is_rtp(p)
    return index(split(&rtp, ","), get(self.plugs[a:p], "dir")) != -1
endfunction

function! g:plug.is_loaded(p)
    return g:plug.is_installed(1, a:p) && g:plug.is_rtp(a:p)
endfunction

function! g:plug.check_installation()
    if empty(self.plugs)
        return
    endif

    let list = []
    for [name, spec] in items(self.plugs)
        if !isdirectory(spec.dir)
            call add(list, spec.uri)
        endif
    endfor

    if len(list) > 0
        let unplugged = map(list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')
        " Ask whether installing plugs like NeoBundle
        echomsg 'Not installed plugs: ' . string(unplugged)
        if confirm('Install plugs now?', "yes\nNo", 2) == 1
            PlugInstall
            " Close window for vim-plug
            "silent! close
            "" Restart vim
            "if !g:env.is_gui
            "     silent! !vim
            "     quit!
            "endif
        endif
    endif
endfunction

if g:plug.ready() && g:env.vimrc.plugin_on
    function! PlugList(A,L,P)
        return join(g:plug.list, "\n")
    endfunction

    command! -nargs=1 -complete=custom,PlugList PlugHas
                \ if g:plug.is_installed('<args>')
                \ | echo g:plug.plugs['<args>'].dir
                \ | endif
endif

if executable('golsp')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'go-lang',
        \ 'cmd': {server_info->['golsp', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
  augroup END
endif

"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction


colorscheme hyper-solarized
