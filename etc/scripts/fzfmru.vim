command! FZFMru call s:fzf_wrap({
            \ 'source':  'bash -c "'.
            \                'echo -e \"'.s:old_files().'\";'.
            \                'ag -l -g \"\"'.
            \            '"',
            \ })

function! s:fzf_wrap(dict)
    let defaults = {
                \ 'sink' : 'edit',
                \ 'options' : '+s -e -m',
                \ 'tmux_height': '40%',
                \ }
    call extend(a:dict, defaults, 'keep')
    call fzf#run(a:dict)
endfunction

function! s:old_files()
    let oldfiles = copy(v:oldfiles)
    call filter(oldfiles, 'v:val !~ "fugitive"')
    call filter(oldfiles, 'v:val !~ "NERD_tree"')
    call filter(oldfiles, 'v:val !~ "^/tmp/"')
    call filter(oldfiles, 'v:val !~ ".git/"')
    call filter(oldfiles, 'v:val !~ ".svg"')
    return join(oldfiles, '\n')
endfunction

command! FZFMru call fzf#run({
            \ 'source':  reverse(s:all_files()),
            \ 'sink':    'edit',
            \ 'options': '-m --no-sort -x',
            \ 'down':    '40%' })

function! s:all_files()
    return extend(
                \ filter(copy(v:oldfiles),
                \        "v:val !~ 'fugitive:\\|\\.svg|NERD_tree\\|^/tmp/\\|.git/'"),
                \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction
