" Has Settings
" github.com/mike325/.vim

function! has#minimal() abort
    return exists('g:minimal') || !empty($VIM_MIN)
endfunction

function! has#bare() abort
    return exists('g:bare') || !empty($VIM_BARE)
endfunction

function! has#gui() abort
    return ( has('nvim') && ( exists('g:gonvim_running') || exists('g:GuiLoaded') || exists('veonim') )) || ( !has('nvim') && has('gui_running') )
endfunction

function! has#patch(patch) abort
    return has('patch-'.a:patch)
endfunction

function! has#augroup(augroup) abort
    return exists('#'.a:augroup)
endfunction

function! has#autocmd(autocmd) abort
    return exists('##'.a:autocmd)
endfunction

function! has#cmd(cmd) abort
    return exists(':'.a:cmd)
endfunction

function! has#func(func) abort
    return exists('*'.a:func)
endfunction

function! has#option(option) abort
    return exists('+'.a:option)
endfunction

function! has#variable(variable) abort
    return exists(a:variable)
endfunction

function! has#plugin(plugin) abort
    if exists('g:plugs')
        return has_key(g:plugs, a:plugin)
    endif
    return 0
endfunction

function! has#plugin_manager() abort
    return has#cmd('Plug') == 2
endfunction

if has('nvim-0.5')

    function! has#async() abort
        return 1
    endfunction

    function! has#python(...) abort
        if !luaeval("require('python').setup()")
            return 0
        endif

        return v:lua.python.has_version(a:000)
    endfunction

    finish
endif

function! s:python_setup() abort
    return has('nvim') ? luaeval("require'python'.setup()") : setup#python()
endfunction

" Check an specific version of python (empty==2)
function! has#python(...) abort

    if !exists('g:python_host_prog') && !exists('g:python3_host_prog')
        if ! s:python_setup()
            return 0
        endif
    endif

    let l:version = (a:0 > 0) ? a:1 : 'any'

    if l:version ==# 'any' || l:version ==# ''
        return (has('python') || has('python3'))
    else
        if !exists('s:pyversion')
            if exists('g:python_host_prog')
                let s:pyversion = {'2' : ''}
                if has('nvim')
                    let s:pyversion['2'] = luaeval("require('python')['2'].version")
                else
                    let s:pyversion['2'] = matchstr(system(g:python_host_prog . ' --version'), "\\S\\+\\ze\n")
                endif
            endif
            if exists('g:python3_host_prog')
                let s:pyversion = exists('s:pyversion["2"]') ? {'2': s:pyversion['2'], '3': ''} : {'3': ''}
                if has('nvim')
                    let s:pyversion['3'] = luaeval("require('python')['3'].version")
                else
                    let s:pyversion['3'] = matchstr(system(g:python3_host_prog . ' --version'), "\\S\\+\\ze\n")
                endif
            endif
        endif

        if !exists('s:pyversion[a:1]')
            return 0
        endif

        let l:version = s:pyversion[a:1]
        let l:components = split(l:version, '\D\+')
        let l:has_version = ''

        for l:i in range(len(a:000))
            if a:000[l:i] > +get(l:components, l:i)
                let l:has_version = 0
                break
            elseif a:000[l:i] < +get(l:components, l:i)
                let l:has_version = 1
                break
            endif
        endfor
        if empty(l:has_version)
            let l:has_version = (a:000[l:i] ==# get(l:components, l:i)) ? 1 : 0
        endif

        if l:has_version
            if l:version[0] ==# '3'
                return has('python3')
            elseif l:version[0] ==# '2'
                return has('python')
            endif
        endif
    endif

    return 0
endfunction

" Check whether or not we have async support
function! has#async() abort
    let l:async = 0

    if has('nvim') || v:version > 800 || ( v:version == 800 && has#patch('8.0.902') )
        let l:async = 1
    elseif v:version ==# 704 && has#patch('7.4.1689')
        let l:async = 1
    elseif has('job') && has('timers') && has('channel')
        let l:async = 1
    endif

    return l:async
endfunction
