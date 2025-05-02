" AWK Embedding: {{{1
" ==============
" Shamelessly ripped from aspperl.vim by Aaron Hope.
if exists("b:current_syntax")
  unlet b:current_syntax
endif
syn include @AWKScript syntax/awk.vim
syn region AWKScriptCode matchgroup=AWKCommand start=+[=\\]\@<!'+ skip=+\\'+ end=+'+ contains=@AWKScript contained
syn region AWKScriptEmbedded matchgroup=AWKCommand start=+\<awk\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1 contains=@shIdList,@shExprList2 nextgroup=AWKScriptCode
syn cluster shCommandSubList add=AWKScriptEmbedded
hi def link AWKCommand Type
