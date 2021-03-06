" Markdown Settings
" github.com/mike325/.vim

setlocal spell
setlocal complete+=k,kspell " Add spell completion
setlocal foldmethod=indent
setlocal textwidth=80

if has('nvim-0.4')
    lua require"tools".helpers.abolish(require'nvim'.bo.spelllang)
else
    call tools#abolish(&l:spelllang)
endif
