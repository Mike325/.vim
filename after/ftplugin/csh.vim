" Csh Settings
" github.com/mike325/.vim

setlocal expandtab
setlocal shiftround
setlocal tabstop=4
setlocal shiftwidth=0
setlocal softtabstop=-1

" let g:filetype_csh = 'tcsh'

" Since '$' is part of the variables, lets treat it as part of the word
" setlocal iskeyword+=$

nnoremap <silent><buffer> <CR> :call mappings#cr()<CR>

" CREDITS: https://github.com/demophoon/bash-fold-expr
" LICENSE: MIT
function! GetCshFold()
    let line = getline(v:lnum)

    " End of if statement
    if line =~? '\v^\s*endif\s*$'
        return 's1'
    endif
    " Start of if statement
    if line =~? '\v^\s*if.*(\s*then)?$'
        return 'a1'
    endif

    " " End of while/for statement
    if line =~? '\v^\s*end\s*$'
        return 's1'
    endif

    " " Start of while/foreach statement
    if line =~? '\v^\s*(while|foreach).*'
        return 'a1'
    endif

    " " End of case statement
    " if line =~? '\v^\s*esac\s*$'
    "     return 's1'
    " endif

    " " Start of case statement
    " if line =~? '\v^\s*case.*(\s*in)$'
    "     return 'a1'
    " endif

    " End of function statement
    if line =~? '\v^\s*\}$'
        return 's1'
    endif

    " Start of function statement
    if line =~? '\v^\s*(function\s+)?\S+\(\) \{'
        return 'a1'
    endif

    " Default
    return '='
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetCshFold()
