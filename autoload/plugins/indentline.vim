scriptencoding 'utf-8'
" IndentLine settings
" github.com/mike325/.vim

if !exists('g:plugs["indentLine"]') && exists('g:config_indentline')
    finish
endif

let g:config_indentline = 1

" Show indentation lines for space indented code
" If you use code tab indention you can set this
" set list lcs=tab:\┊\
" Check plugin/settings.vim for more details

" nnoremap tdi :IndentLinesToggle<CR>

if empty($NO_COOL_FONTS)
    let g:indentLine_char            = '┊'
else
    let g:indentLine_char            = '│'
endif

" Set the inline characters for each indent
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']

let g:indentLine_color_gui       = '#DDC188'
let g:indentLine_color_term      = 214
let g:indentLine_enabled         = 1
let g:indentLine_setColors       = 1

" let g:indentLine_fileType = [
"             \
"             \]

let g:indentLine_fileTypeExclude = [
    \   'text',
    \   'conf',
    \   'markdown',
    \   'help',
    \   'man',
    \   'git',
    \   '',
    \ ]

let g:indentLine_bufNameExclude = [
    \   '',
    \   '*.org',
    \   '*.log',
    \   'COMMIT_EDITMSG',
    \   'NERD_tree.*',
    \   'term://*',
    \   'man://*',
    \ ]
