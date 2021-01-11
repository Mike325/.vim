" Colorscheme settings
" github.com/mike325/.vim

if has('nvim-0.5')
    finish
endif

set background=dark
set cursorline

if has#option('termguicolors')
    set termguicolors
endif

if !has('nvim')
    set t_Co=256
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

try
    if has#plugin('sonokai')
        if has#plugin('vim-airline')
            let g:airline_theme = 'sonokai'
        endif
        let g:sonokai_better_performance = 1
        let g:sonokai_style = 'shusia'
        let g:sonokai_enable_italic = 1
        let g:sonokai_disable_italic_comment = 1
        let g:sonokai_diagnostic_line_highlight = 1
        colorscheme sonokai
    elseif has#plugin('ayu-vim') && has('nvim')
        let g:ayucolor = 'dark'
        colorscheme ayu
    elseif has#plugin('onedark.vim')
        colorscheme onedark
    else
        colorscheme torte
        set nocursorline
    endif
catch /E185/
    colorscheme torte
    set nocursorline
endtry
