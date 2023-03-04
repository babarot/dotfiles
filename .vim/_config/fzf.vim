
let g:fzf_preview_window = ['up,70%', 'ctrl-/']

" command! -bang -nargs=? FZFMru call fzf_mru#actions#mru(<q-args>,
"      \{
"      \'window': {'width': 0.9, 'height': 0.8},
"      \'options': [
"        \'--preview', 'cat {}',
"        \'--preview-window', 'up:60%',
"        \'--bind', 'ctrl-_:toggle-preview'
"        \]
"        \}
"        \)

nnoremap <Space>j :History<CR>
nnoremap <Space>k :Files<CR>
"nnoremap <Space>j :FZFMru<CR>
"nnoremap <Space>j :History<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number -- '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

