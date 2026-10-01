# History file and its size
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# Do not keep root's history
if [[ $UID == 0 ]]; then
    unset HISTFILE
    SAVEHIST=0
fi
# Ask before listing more completions than this
LISTMAX=50
# Do not offer corrections to internal functions and dotfiles
CORRECT_IGNORE='_*'
CORRECT_IGNORE_FILE='.*'

setopt auto_cd
setopt auto_pushd
setopt auto_resume
setopt brace_ccl
setopt complete_in_word
setopt correct
setopt correct_all
setopt extended_glob
setopt extended_history
setopt globdots
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_nodups
setopt hist_verify
setopt interactive_comments
setopt long_list_jobs
setopt magic_equal_subst
setopt mark_dirs
setopt no_beep
setopt no_case_glob
setopt no_clobber
setopt no_flow_control
setopt no_hist_beep
setopt no_list_beep
setopt no_prompt_cr
setopt path_dirs
setopt print_eight_bit
setopt print_exit_value
setopt pushd_ignore_dups
setopt pushd_minus
setopt pushd_to_home
setopt rc_quotes
setopt rm_star_wait
setopt sh_word_split
setopt share_history
