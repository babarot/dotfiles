au BufNewFile,BufRead *.yml,*.yaml call s:DetectAnsibleVault()

fun! s:DetectAnsibleVault()
    let n=1
    while n<10 && n < line("$")
        if getline(n) =~ 'ANSIBLE_VAULT'
            set filetype=ansible-vault
        endif
        let n = n + 1
    endwhile
endfun

let g:hcl_fmt_autosave = 1
let g:tf_fmt_autosave = 1
let g:nomad_fmt_autosave = 1

let g:ale_linters = {
\   'terraform': ['tflint'],
\   'hcl': ['tflint'],
\}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save = 1

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction
