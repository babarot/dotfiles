" Note: Skip initialization for vim-tiny or vim-small.
if 1
    execute 'source' fnamemodify(expand('<sfile>'), ':h') . '/rc/init.vim'
endif
